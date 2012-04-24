From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck,libquota: Update quota only if its inconsistent
Date: Tue, 24 Apr 2012 14:52:31 -0400
Message-ID: <20120424185231.GH18865@thunk.org>
References: <1334347864-12662-1-git-send-email-adityakali@google.com>
 <1334347864-12662-2-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: niu@whamcloud.com, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37042 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2DXSwd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 14:52:33 -0400
Content-Disposition: inline
In-Reply-To: <1334347864-12662-2-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 01:11:03PM -0700, Aditya Kali wrote:
> Currently fsck recomputes quotas and overwrites quota files
> whenever its run. This causes unnecessary modification of
> filesystem even when quotas were never inconsistent. We also
> lose the limits information because of this. With this patch,
> e2fsck compares the computed quotas to the on-disk quotas
> (while updating the in-memory limits) and writes out the
> quota inode only if it is inconsistent.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Thanks, applied with one change:

> +	/* Update quota information if it is inconsistent */
> +	{ PR_6_UPDATE_QUOTAS,
> +	  N_("Updating quota info for quota type %N "),
> +	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
> +

I changed "Updating" to "Update" since we will be asking a question.

  	  	     		       - Ted
