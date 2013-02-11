From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/12] ext4: start handle at the last possible moment
 when creating inodes
Date: Sun, 10 Feb 2013 20:47:50 -0500
Message-ID: <20130211014750.GE10801@thunk.org>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47807 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3BKBrw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2013 20:47:52 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 09, 2013 at 04:53:52PM -0500, Theodore Ts'o wrote:
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 10bd6fe..943665b 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -725,6 +727,15 @@ repeat_in_this_group:
>  				   "inode=%lu", ino + 1);
>  			continue;
>  		}
> +		if (!handle) {
> +			BUG_ON(nblocks == 0);

I've changed this to be:

			BUG_ON(nblocks <= 0);

... since nblocks should (obviously) never be negative.

    	  	  	 	     	      - Ted
