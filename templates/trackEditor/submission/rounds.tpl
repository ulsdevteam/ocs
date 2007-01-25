{**
 * rounds.tpl
 *
 * Copyright (c) 2003-2005 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate displaying past rounds for a submission.
 *
 * $Id$
 *}

<a name="rounds"></a>
<h3>{translate|escape key="trackEditor.regrets.regretsAndCancels"}</h3>

<table width="100%" class="listing">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr valign="top">
		<td class="heading" width="30%">{translate key="user.name"}</td>
		<td class="heading" width="25%">{translate key="submission.request"}</td>
		<td class="heading" width="25%">{translate key="trackEditor.regrets.result"}</td>
		{if $eventSettings.reviewPapers}<td class="heading" width="20%">{translate key="submissions.reviewType"}</td>{/if}
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
{foreach from=$cancelsAndRegrets item=cancelOrRegret name=cancelsAndRegrets}
	<tr valign="top">
		<td>{$cancelOrRegret->getReviewerFullName()|escape}</td>
		<td>
			{if $cancelOrRegret->getDateNotified()}
				{$cancelOrRegret->getDateNotified()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $cancelOrRegret->getDeclined()}
				{translate key="trackEditor.regrets"}
			{else}
				{translate key="common.cancelled"}
			{/if}
		</td>
		<td>{$cancelOrRegret->getRound()}</td>
	</tr>
	<tr>
		<td colspan="4" class="{if $smarty.foreach.cancelsAndRegrets.last}end{/if}separator">&nbsp;</td>
	</tr>
{foreachelse}
	<tr valign="top">
		<td colspan="4" class="nodata">{translate key="common.none}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{/foreach}
</table>

{foreach from=$reviewAssignmentTypes item=reviewAssignments key=type}

{assign var=numRounds value=$reviewAssignments|@count}
{section name=round loop=$numRounds}
{assign var=round value=$smarty.section.round.index}
{assign var=roundPlusOne value=$round+1}
{assign var=roundAssignments value=$reviewAssignments[$roundPlusOne]}
{assign var=roundDecisions value=$editorDecisions[$type][$roundPlusOne]}
{assign var=needsTypeHeading value=1}

{if $submission->getReviewProgress() != $type || $submission->getCurrentRound() != $roundPlusOne}

{if $needsTypeHeading}
	<h3>{if $type == REVIEW_PROGRESS_ABSTRACT}{translate key="submission.abstractReview"}{else}{translate key="submission.paperReview"}{/if}</h3>
	{assign var=needsTypeHeading value=0}
{/if}

<h4>{translate key="trackEditor.regrets.reviewRound" round=$roundPlusOne}</h4>

{if $type != REVIEW_PROGRESS_ABSTRACT}
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="submission.reviewVersion"}</td>
		<td class="value" width="80%">
			{assign var="reviewFile" value=$reviewFilesByRound[$roundPlusOne]}
			{if $reviewFile}
				<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatShort}
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
</table>
{/if}

{assign var="start" value="A"|ord}

{foreach from=$roundAssignments item=reviewAssignment key=reviewKey}

{if !$reviewAssignment->getCancelled()}
<div class="separator"></div>
<h5>{translate key="user.role.reviewer"} {$reviewKey+$start|chr} {$reviewAssignment->getReviewerFullName()|escape}</h5>

<table width="100%" class="listing">
	<tr valign="top">
		<td width="20%">{translate key="reviewer.paper.schedule"}</td>
		<td width="20%" class="heading">{translate key="submission.request"}</td>
		<td width="20%" class="heading">{translate key="submission.underway"}</td>
		<td width="20%" class="heading">{translate key="submission.due"}</td>
		<td width="20%" class="heading">{translate key="submission.acknowledge"}</td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{if $reviewAssignment->getDateNotified()}
				{$reviewAssignment->getDateNotified()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateConfirmed()}
				{$reviewAssignment->getDateConfirmed()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateDue()}
				{$reviewAssignment->getDateDue()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateAcknowledged()}
				{$reviewAssignment->getDateAcknowledged()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td>{translate key="submission.recommendation"}</td>
		<td colspan="4">
			{if $reviewAssignment->getRecommendation()}
				{assign var="recommendation" value=$reviewAssignment->getRecommendation()}
				{translate key=$reviewerRecommendationOptions.$recommendation}
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="reviewer.paper.reviewerComments"}</td>
		<td colspan="4">
			{if $reviewAssignment->getMostRecentPeerReviewComment()}
				{assign var="comment" value=$reviewAssignment->getMostRecentPeerReviewComment()}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getReviewId() anchor=$comment->getCommentId()}');" class="icon">{icon name="comment"}</a> {$comment->getDatePosted()|date_format:$dateFormatShort}
			{else}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getReviewId()}');" class="icon">{icon name="comment"}</a>
			{/if}
		</td>
	</tr>
 	<tr valign="top">
		<td class="label">{translate key="reviewer.paper.uploadedFile"}</td>
		<td colspan="4">
			<table width="100%" class="data">
				{foreach from=$reviewAssignment->getReviewerFileRevisions() item=reviewerFile key=key}
				<tr valign="top">
					<td valign="middle">
						<form name="authorView{$reviewAssignment->getReviewId()}" method="post" action="{url op="makeReviewerFileViewable"}">
							<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewerFile->getFileId():$reviewerFile->getRevision()}" class="file">{$reviewerFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatShort}
							<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}" />
							<input type="hidden" name="paperId" value="{$submission->getPaperId()}" />
							<input type="hidden" name="fileId" value="{$reviewerFile->getFileId()}" />
							<input type="hidden" name="revision" value="{$reviewerFile->getRevision()}" />
							{translate key="editor.paper.showAuthor"} <input type="checkbox"
name="viewable" value="1"{if $reviewerFile->getViewable()} checked="checked"{/if} />
							<input type="submit" value="{translate key="common.record"}" class="button" />
						</form>
					</td>
				</tr>
				{foreachelse}
				<tr valign="top">
					<td>{translate key="common.none"}</td>
				</tr>
				{/foreach}
			</table>
		</td>
	</tr>
</table>
{/if}
{/foreach}

<div class="separator"></div>

<h4>{translate key="trackEditor.regrets.decisionRound" round=$roundPlusOne}</h4>

{assign var=authorFiles value=$submission->getAuthorFileRevisions($roundPlusOne)}
{assign var=editorFiles value=$submission->getEditorFileRevisions($roundPlusOne)}

<table class="data" width="100%">
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.paper.decision"}</td>
		<td class="value" width="80%">
			{foreach from=$roundDecisions item=editorDecision key=decisionKey}
				{if $decisionKey neq 0} | {/if}
				{assign var="decision" value=$editorDecision.decision}
				{translate key=$editorDecisionOptions.$decision} {$editorDecision.dateDecided|date_format:$dateFormatShort}
			{foreachelse}
				{translate key="common.none"}
			{/foreach}
		</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="submission.notifyAuthor"}</td>
		<td class="value" width="80%">
			{translate key="submission.editorAuthorRecord"}
			{if $submission->getMostRecentEditorDecisionComment()}
				{assign var="comment" value=$submission->getMostRecentEditorDecisionComment()}
				<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getPaperId() anchor=$comment->getCommentId()}');" class="icon">{icon name="comment"}</a> {$comment->getDatePosted()|date_format:$dateFormatShort}
			{else}
				<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getPaperId()}');" class="icon">{icon name="comment"}</a>
			{/if}
		</td>
	</tr>
	{foreach from=$authorFiles item=authorFile key=key}
		<tr valign="top">
			{if !$authorRevisionExists}
				{assign var="authorRevisionExists" value=true}
				<td width="20%" class="label" rowspan="{$authorFiles|@count}" class="label">{translate key="submission.authorVersion"}</td>
			{/if}
			<td width="80%" class="value"><a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$authorFile->getFileId():$authorFile->getRevision()}" class="file">{$authorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$authorFile->getDateModified()|date_format:$dateFormatShort}</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.authorVersion"}</td>
			<td width="80%" colspan="4" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}
	{foreach from=$editorFiles item=editorFile key=key}
		<tr valign="top">
			{if !$editorRevisionExists}
				{assign var="editorRevisionExists" value=true}
				<td width="20%" class="label" rowspan="{$editorFiles|@count}" class="label">{translate key="submission.editorVersion"}</td>
			{/if}

			<td width="30%"><a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$editorFile->getFileId():$editorFile->getRevision()}" class="file">{$editorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$editorFile->getDateModified()|date_format:$dateFormatShort}</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.editorVersion"}</td>
			<td width="80%" colspan="4" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}
</table>

<div class="separator"></div>

{/if} {* End check to see that this is actually a past review, not the current one *}

{/section} {* End section to loop through all rounds *}

{/foreach} {* End foreach to loop through review types *}

