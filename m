From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3
 00/23] ext4: Add metadata checksumming)
Date: Fri, 10 Feb 2012 16:11:31 -0500
Message-ID: <20120210211131.GB5381@thunk.org>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
 <20120208180847.GA3654@thunk.org>
 <3EBD659A-0A10-4DAE-9EA9-E736CE187574@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38432 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab2BJVLg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 16:11:36 -0500
Content-Disposition: inline
In-Reply-To: <3EBD659A-0A10-4DAE-9EA9-E736CE187574@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 10, 2012 at 12:11:10PM -0700, Andreas Dilger wrote:
> > In fact, if we wanted to take this to extremes, we could call it
> > EXT4_FEATURE_INCOMPAT_NEW_METADATA, and then let it imply the
> > following feature flags as well:
> > 
> > 	EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER
> > 	EXT4_FEATURE_RO_COMPAT_LARGE_FILE
> > 	EXT4_FEATURE_RO_COMPAT_HUGE_FILE
> > 	EXT4_FEATURE_RO_COMPAT_DIR_NLINK
> > 	EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE
> > 	EXT4_FEATURE_INCOMPAT_FILETYPE
> > 	EXT4_FEATURE_INCOMPAT_FLEX_BG
> 
> The above set of features itself looks harmless enough, since they
> have been around for a long time and are mostly just relaxing checks
> in the code.  However, I don't think that introducing a NEW feature
> flag will allow the checks for the old features to be removed from
> the code for a long time, so it will just mean checks for two features
> everywhere in the kernel and e2fsprogs.

Oh, absolutely.  We'd define new inline functions which would check
for METADATA_BUNDLE_1 (for example) as well as those extra features,
and they would be around for a long time.

> Also consider things like INCOMPAT_COMPRESSION and HAS_JOURNAL.
> It would be a shame if we had made a decision like this in the
> past and could not turn these features off, so being able to
> selectively disable these features in the future also has benefits.

Well, yes.  I specifically picked the above features as ones where
there really is no downside to enabling them.  That's why the htree
feature is missing from the list; that was a deliberate choice on my
part.

> Couldn't this all be done in the tools level, instead of changing
> the feature flags?  Have debugfs/dumpe2fs/tune2fs treat a set
> of feature flags as "default_ext4" would be equivalent?

There are two reasons to do this, in my mind.  One is it shortens the
long list of feature flags that get displayed by dumpe2fs and which
some people might want to specify on the mke2fs command line.  That is
definitely something that can be done at the tools level, yes.

The other reason to do this, though, is to make it very clear that
this is the bundle that we really are supporting, to discourage people
from creating file systems that have flex_bg, but not sparse_super,
for example.  The goal is to reduce the testing matrix, very
explicitly.  Yes, we could do the same thing on the ext4 wiki (once
kernel.org fixes it so we can update it, sigh), but I think it makes
much more of an impact when it's in the source code.

> This could also be done at the tools level, by preventing users from
> setting strange combinations of feature flags unless they pass the
> "--yes-this-feature-combination-is-untested" to mke2fs, tune2fs,
> and debugfs, and deprecating truly ancient features entirely.
> 
> I would be happy to just deprecate ancient features like
> SPARSE_SUPER, LARGE_FILE, FILETYPE, v1 filesystems entirely, and
> prevent them from being turned off, and have e2fsck "fix" any such
> filesystem that it finds (with a clear warning).  If such ancient
> filesystems exist, they will not be running new e2fsprogs either.

Sure, and in some sense that's what I am doing by proposing that we
define a new INCOMPAT metadata flag which does exactly this.  I could
have done it by just bumping the major number in the superblock, but
that would have caused progams like dumpe2fs to completely break.
Using a new flag to bundle a new ones, especially when it's very easy
to convert back and forth, is something that makes a lot of sense.

> Next in line would be EXT_ATTR (with v1 xattrs) and DIR_INDEX,
> since they have been supported in ext3 for a long time.  It is
> probably too early to deprecate DIR_NLINK, EXTRA_ISIZE, HUGE_FILE
> and FLEX_BG, since they are new in ext4, but eventually those too.

I'd bundle EXT_ATTR in as well, but I wouldn't bundle in DIR_INDEX,
since there are times when people don't want it on.  

> One improvement of the ZFS implementation is that it distinguishes
> between "allowed" features and "in-use" features.  That allows the
> maximum set of features to be enabled at format/upgrade time, but
> doesn't cause interoperability problems until the features are used.

How does this work in practice?  How does the feature make the
transition from "allowed" to "in-use"?  What does it mean if a feature
bit is set in the "allowed" field of the superblock?  And who gets to
make the decision about starting to use some new feature?  How do you
know that you have both an upgraded kernel *and* upgraded userspace?
Or is that part of an automatic assumption made by Sun that upgrades
of kernel and userspace are always coordinated?

						- Ted
