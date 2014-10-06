From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: add ext4_iget_normal() which is to be used for
 dir tree lookups
Date: Mon, 6 Oct 2014 14:55:34 -0400
Message-ID: <20141006185534.GA7567@thunk.org>
References: <20141005001239.GD27150@sli.dy.fi>
 <1412563682-5720-1-git-send-email-tytso@mit.edu>
 <1412563682-5720-2-git-send-email-tytso@mit.edu>
 <20141006150903.GI7526@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38816 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaJFSzh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Oct 2014 14:55:37 -0400
Content-Disposition: inline
In-Reply-To: <20141006150903.GI7526@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2014 at 05:09:03PM +0200, Jan Kara wrote:
> > +	if (ret_inode && !IS_ERR(ret_inode) &&
> > +	    ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
> > +		make_bad_inode(ret_inode);
> > +	return ret_inode;
>   Hum, why don't we just return an error (like EIO) when invalid inode
> number is passed?

Yeah, I guess we can do that.  We need to support the make_bad_inode()
for the sake of EXT4_IOC_SWAP_BOOT.  But that code path doesn't need
to use ext4_iget_normal().  So yeah, in the case of
ext4_iget_normal(), we should be able to just return -EIO and let the
userspace fail fast with the open(2) instead of later on with the
read(2) or write(2) or truncate(2) call.

						- Ted
