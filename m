From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2 v6] XFS TESTS: ENOSPC Punch Hole: Add new test 255
Date: Tue, 28 Jun 2011 07:02:19 -0700
Message-ID: <4E09DEEB.7070908@linux.vnet.ibm.com>
References: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com> <1309239163-3975-3-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36870 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab1F1ODQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 10:03:16 -0400
In-Reply-To: <1309239163-3975-3-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/27/2011 10:32 PM, Allison Henderson wrote:
> This patch adds a new test 255 that tests that a hole can be punched even when the
> disk is full.  Reserved blocks should be used to allow a punch hole to proceed even
> when there is not enough blocks to further fragment the file. To test this, the
> file system is fragmented by punching holes in regular intervals and filling
> the file system between punches. This will eventually force the file system to use
> reserved blocks to proceed with the punch hole operation.
>
> The work in this patch is a continuation from a previous patch set that has been
> partially accepted.
>
> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
> ---
>
> v5->v6
>
> Test moved out of 252 and put in its own test 255
>
> _fill_fs and _test_full_fs_punch have been moved from common.punch
> to test 255 and modified to use the _user_do routines in common.rc
>
> _fill_fs has been optimized to stop once files smaller than a block
> cannot be created.
>
> :100644 100644 1f86075... c045e70... M	group
>   group |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/group b/group
> index 1f86075..c045e70 100644
> --- a/group
> +++ b/group
> @@ -368,3 +368,4 @@ deprecated
>   252 auto quick prealloc
>   253 auto quick
>   254 auto quick
> +255 auto quick


Ah, sorry I obviously messed up the file add here. My apologies for the 
confusion!  Will resend this one.

Allison
