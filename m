From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Tue, 30 Mar 2010 02:43:08 +0200
Message-ID: <20100330004308.GI5835@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
 <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
 <20100326105441.GB3055@quack.suse.cz>
 <20100326135136.GF21658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Andreas Dilger <andreas.dilger@oracle.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55065 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0C3Amx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 20:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20100326135136.GF21658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 26-03-10 09:51:36, tytso@mit.edu wrote:
> On Fri, Mar 26, 2010 at 11:54:41AM +0100, Jan Kara wrote:
> >   Yes, this should be a good option. I imagine we would create RO_COMPAT
> > features USRQUOTA and GRPQUOTA meaning that the filesystem maintains
> > quotas in hidden files. And mkfs would directly create these files if
> > it was asked to.
> Technically we don't even need to make this be an RO_COMPAT feature; a
> COMPAT feature might suffice.  We just need to have new superblock
> fields which indicate the inode numbers for the user and group quotas.
> If the inode number is the reserved inode for user or group quotas,
> then it's the hidden inode.  If it's the number corresponding to a
> user-visible file then we simply haven't transitioned the file over.
> See e2fsck to see how we handle automatically transinition a user
> visible .journal file to inode #8.  That part's not hard.
  Yes, this should be fine.

> I am worried about the transition to a model where quotas are always
> enforced; that's quite different from what we had before.  What
  I didn't mean quotas would be always enforced. They would be always
accounted (when appropriate quota features are set). They will be enforced
only if admin calls quotaon (and quotaoff turns off only enforcement, not
accounting).

> happens if someone uses the command quotaoff command?  Does it turn
> off quotas?  If the quota files are now hidden, a system administrator
> can't use quotacheck (which is an on-line command) to fix bad quotas;
> now they have to use e2fsck, which is normally an off-line checker.  I
> suppose we could make e2fsck be able to run in an on-line quotacheck
> mode, where it only updates quotas and accepts that there may be some
> race conditions where the blocks/inodes-in-use numbers won't be
> exactly right.
  Well, normally, quota information should never be wrong when we journal
quotas and always account them. So we can treat it as other kinds of
filesystem corruption (although this inconsistency is rather harmless for
data).

> What about use cases where people were accustomed to letting BSD or
> MacOS access an ext3 file system, and either accept the quota being
> slightly off, or relying on quotacheck to fix tihngs up at some point
> later?
  Well, I'm not sure how often people have multi-OS system with quotas.
I expect quotas to be used on multiuser machines where the amount of
trust among users is low - i.e. university servers, hosting servers, ...
Not exactly the case where I would expect the possibility to modify
filesystem externally. So I don't expect this to be common and offline
e2fsck should be fine IMHO. But given it's not too hard to implement
online quotacheck in e2fsck we provide it as well...

> P.S.  We can add a new superblock field, which is a "quota last
> updated time", and if that is less than the superblock write time, it
> could be a hint that e2fsck needs to do a quotacheck run.  That could
> partially help address the situation of 3rd party OS's/tools accessing
> the file system directly.... 
  Yes, I think this will be fine for detecting someone modifying the fs
although having USRQUOTA feature RO_COMPAT would do as well. But I guess
your solution is easier for users.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
