From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Make orphan functions no-op in no-journal mode
Date: Mon, 17 Sep 2012 23:32:04 -0400
Message-ID: <20120918033204.GA32195@thunk.org>
References: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dmonakhov@openvz.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51213 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab2IRDcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 23:32:08 -0400
Content-Disposition: inline
In-Reply-To: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:47:16AM -0700, Anatol Pomozov wrote:
> This avoids using shared mutext and thus improves scalability of
> no-journal mode. The goal of this change is similar to 3d287de3b828
> but it avoids mutex usage for all ext4_orphan_del(NULL,..) calls.

It doesn't really improve scalability in no-journal except in the
error case.  This is because....

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2a42cc0..6863cdf 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2362,6 +2362,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	struct ext4_iloc iloc;
>  	int err = 0, rc;
>  
> +	if (!EXT4_SB(sb)->s_journal)
> +		return 0;
>  	if (!ext4_handle_valid(handle))
>  		return 0;


The two checks above are equivalent.  If (!EXT4_SB(sb)->s_journal),
then ext4_journal_start() will return return an "invalid" handle.  So
this change is purely cosmetic.  I don't object to making the change
for consistency with the change to be made in ext4_orphan_del() below,
but we should remove the !ext4_handle_valid(handle) call in that case.


> @@ -2436,6 +2438,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  	struct ext4_iloc iloc;
>  	int err = 0;
>  
> +	if (!EXT4_SB(inode->i_sb)->s_journal)
> +		return 0;
>  	/* ext4_handle_valid() assumes a valid handle_t pointer */
>  	if (handle && !ext4_handle_valid(handle))
>  		return 0;

We can remove the (handle && !ext4_handle_valid(handle)) conditional
here too.

						- Ted
