From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Wed, 27 Jul 2011 20:34:22 -0400
Message-ID: <20110728003421.GA3133@thunk.org>
References: <1311729192-30598-1-git-send-email-tytso@mit.edu>
 <20110727011554.GN22133@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39905 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab1G1AeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 20:34:25 -0400
Content-Disposition: inline
In-Reply-To: <20110727011554.GN22133@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 27, 2011 at 02:15:54AM +0100, Al Viro wrote:
> On Tue, Jul 26, 2011 at 09:13:12PM -0400, Theodore Ts'o wrote:
> > +	inode = igrab(inode);
> > +	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
> >  		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
> > -		dentry = list_entry(inode->i_dentry.next,
> > -				    struct dentry, d_alias);
> > -		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
> > +		dentry = list_first_entry(&inode->i_dentry,
> > +					  struct dentry, d_alias);
> 
> ... and what if you don't have a dentry for that inode anymore?

I thought you were complaining that dentry could never be NULL
earlier?  We earlier checked for NULL, but I figured you knew
something I didn't....

> > +		next = igrab(dentry->d_parent->d_inode);
> 
> what protects you against rename() (OK, d_mode()) here?

Does it matter?  We'll get either the old or the new parent directory,
but either way it will be a valid inode, right?  Or am I missing
something?

						- Ted
