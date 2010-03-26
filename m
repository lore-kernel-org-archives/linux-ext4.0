From: tytso@mit.edu
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 09:51:36 -0400
Message-ID: <20100326135136.GF21658@thunk.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
 <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
 <20100326105441.GB3055@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58472 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0CZNwU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 09:52:20 -0400
Content-Disposition: inline
In-Reply-To: <20100326105441.GB3055@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 11:54:41AM +0100, Jan Kara wrote:
>   Yes, this should be a good option. I imagine we would create RO_COMPAT
> features USRQUOTA and GRPQUOTA meaning that the filesystem maintains
> quotas in hidden files. And mkfs would directly create these files if
> it was asked to.

Technically we don't even need to make this be an RO_COMPAT feature; a
COMPAT feature might suffice.  We just need to have new superblock
fields which indicate the inode numbers for the user and group quotas.
If the inode number is the reserved inode for user or group quotas,
then it's the hidden inode.  If it's the number corresponding to a
user-visible file then we simply haven't transitioned the file over.
See e2fsck to see how we handle automatically transinition a user
visible .journal file to inode #8.  That part's not hard.

I am worried about the transition to a model where quotas are always
enforced; that's quite different from what we had before.  What
happens if someone uses the command quotaoff command?  Does it turn
off quotas?  If the quota files are now hidden, a system administrator
can't use quotacheck (which is an on-line command) to fix bad quotas;
now they have to use e2fsck, which is normally an off-line checker.  I
suppose we could make e2fsck be able to run in an on-line quotacheck
mode, where it only updates quotas and accepts that there may be some
race conditions where the blocks/inodes-in-use numbers won't be
exactly right.

What about use cases where people were accustomed to letting BSD or
MacOS access an ext3 file system, and either accept the quota being
slightly off, or relying on quotacheck to fix tihngs up at some point
later?

These are all things which can be quite surprising to system
administrators...

					- Ted

P.S.  We can add a new superblock field, which is a "quota last
updated time", and if that is less than the superblock write time, it
could be a hint that e2fsck needs to do a quotacheck run.  That could
partially help address the situation of 3rd party OS's/tools accessing
the file system directly.... 
