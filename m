From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Thu, 28 Jul 2011 02:11:29 +0100
Message-ID: <20110728011129.GO22133@ZenIV.linux.org.uk>
References: <1311729192-30598-1-git-send-email-tytso@mit.edu>
 <20110727011554.GN22133@ZenIV.linux.org.uk>
 <20110728003421.GA3133@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54377 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1G1BLc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jul 2011 21:11:32 -0400
Content-Disposition: inline
In-Reply-To: <20110728003421.GA3133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 27, 2011 at 08:34:22PM -0400, Ted Ts'o wrote:
> > > +		dentry = list_first_entry(&inode->i_dentry,
> > > +					  struct dentry, d_alias);
> > 
> > ... and what if you don't have a dentry for that inode anymore?
> 
> I thought you were complaining that dentry could never be NULL
> earlier?  We earlier checked for NULL, but I figured you knew
> something I didn't....

The pointer won't be NULL, of course, but what guarantees that inode->i_dentry
won't be *empty*?  IOW, you could get a perfectly non-NULL pointer, equal to
	(char *)inode + offsetof(struct inode, i_dentry)
	 - offsetof(struct dentry, d_alias)
and treating it as struct dentry * won't do you any good...

> > > +		next = igrab(dentry->d_parent->d_inode);
> > 
> > what protects you against rename() (OK, d_mode()) here?
> 
> Does it matter?  We'll get either the old or the new parent directory,
> but either way it will be a valid inode, right?  Or am I missing
> something?

Once d_move() has happened, there's nothing to protect the old parent
anymore...  Granted, it's a hell of a narrow race window, but you
need at least ->d_lock on your dentry...
