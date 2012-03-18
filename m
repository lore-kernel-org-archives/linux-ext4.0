From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/5] e2fsck: print a notice when we've started suppressing a problem code
Date: Sun, 18 Mar 2012 17:17:20 -0600
Message-ID: <1D4F4E78-7F63-406D-9D35-09F716E04C43@dilger.ca>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu> <1332100368-2683-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50193 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2CRXQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Mar 2012 19:16:35 -0400
In-Reply-To: <1332100368-2683-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-18, at 1:52 PM, Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> e2fsck/problem.c |    5 +++++
> 1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 53e8e11..7d5b10d 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1868,6 +1868,11 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
> 		if ((ptr->flags & PR_LATCH_MASK) &&
> 		    (ldesc->flags & (PRL_YES | PRL_NO)))
> 			suppress++;
> +		if (ptr->count == ptr->max_count + 1) {
> +			printf("...problem 0x%06x suppressed\n",
> +			       ptr->e2p_code);
> +			fflush(stdout);
> +		}


Did a patch ever land to allow an interactive e2fsck run to set
a sticky answer (y/n) for a particular problem?  I know it has
been proposed several times.

Cheers, Andreas





