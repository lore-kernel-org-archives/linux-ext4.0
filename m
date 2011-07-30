From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Sat, 30 Jul 2011 12:32:04 -0400
Message-ID: <20110730163204.GH7361@thunk.org>
References: <1311729192-30598-1-git-send-email-tytso@mit.edu>
 <20110727011554.GN22133@ZenIV.linux.org.uk>
 <20110728003421.GA3133@thunk.org>
 <20110728011129.GO22133@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60881 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab1G3QcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jul 2011 12:32:08 -0400
Content-Disposition: inline
In-Reply-To: <20110728011129.GO22133@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 28, 2011 at 02:11:29AM +0100, Al Viro wrote:
> Once d_move() has happened, there's nothing to protect the old parent
> anymore...  Granted, it's a hell of a narrow race window, but you
> need at least ->d_lock on your dentry...

Right, got it.  So the following should be safe according to the
dcache locking protocols, right?

	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
		dentry = NULL;
		spin_lock(&inode->i_lock);
		if (!list_empty(&inode->i_dentry)) {
			dentry = list_first_entry(&inode->i_dentry,
						  struct dentry, d_alias);
			dget(dentry);
		}
		spin_unlock(&inode->i_lock);
		if (!dentry)
			break;
		next = igrab(dentry->d_parent->d_inode);
		dput(dentry);
		if (!next)
			break;
		iput(inode);
		inode = next;
		...

Let me know if I've missed anything....

						- Ted
