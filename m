From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Wed, 27 Jul 2011 02:15:54 +0100
Message-ID: <20110727011554.GN22133@ZenIV.linux.org.uk>
References: <1311729192-30598-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:46670 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1G0BP5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 21:15:57 -0400
Content-Disposition: inline
In-Reply-To: <1311729192-30598-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 09:13:12PM -0400, Theodore Ts'o wrote:
> +	inode = igrab(inode);
> +	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
>  		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
> -		dentry = list_entry(inode->i_dentry.next,
> -				    struct dentry, d_alias);
> -		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
> +		dentry = list_first_entry(&inode->i_dentry,
> +					  struct dentry, d_alias);

... and what if you don't have a dentry for that inode anymore?

> +		next = igrab(dentry->d_parent->d_inode);

what protects you against rename() (OK, d_mode()) here?
