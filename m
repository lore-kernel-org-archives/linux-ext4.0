From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Sat, 30 Jul 2011 17:42:42 +0100
Message-ID: <20110730164242.GB2203@ZenIV.linux.org.uk>
References: <1311729192-30598-1-git-send-email-tytso@mit.edu>
 <20110727011554.GN22133@ZenIV.linux.org.uk>
 <20110728003421.GA3133@thunk.org>
 <20110728011129.GO22133@ZenIV.linux.org.uk>
 <20110730163204.GH7361@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1G3Qmp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jul 2011 12:42:45 -0400
Content-Disposition: inline
In-Reply-To: <20110730163204.GH7361@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 30, 2011 at 12:32:04PM -0400, Ted Ts'o wrote:
> 		spin_lock(&inode->i_lock);
> 		if (!list_empty(&inode->i_dentry)) {
> 			dentry = list_first_entry(&inode->i_dentry,
> 						  struct dentry, d_alias);
> 			dget(dentry);
> 		}
> 		spin_unlock(&inode->i_lock);

		dentry = d_find_alias(inode);
actually...

> 		if (!dentry)
> 			break;

> 		next = igrab(dentry->d_parent->d_inode);

and that one needs dentry->d_lock around it, to stabilize ->d_parent.
