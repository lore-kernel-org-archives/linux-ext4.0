From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3 00/23] ext4: Add metadata checksumming)
Date: Sat, 11 Feb 2012 18:38:03 -0700
Message-ID: <28776282-021D-473A-99A1-F5A3DDC08966@dilger.ca>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120208180847.GA3654@thunk.org> <3EBD659A-0A10-4DAE-9EA9-E736CE187574@dilger.ca> <20120210211131.GB5381@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:53107 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2BLBrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Feb 2012 20:47:45 -0500
In-Reply-To: <20120210211131.GB5381@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-10, at 2:11 PM, Ted Ts'o wrote:
> On Fri, Feb 10, 2012 at 12:11:10PM -0700, Andreas Dilger wrote:
>>> In fact, if we wanted to take this to extremes, we could call it
>>> EXT4_FEATURE_INCOMPAT_NEW_METADATA, and then let it imply the
>>> following feature flags as well:
>>> 
>>> 	EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER
>>> 	EXT4_FEATURE_RO_COMPAT_LARGE_FILE
>>> 	EXT4_FEATURE_RO_COMPAT_HUGE_FILE
>>> 	EXT4_FEATURE_RO_COMPAT_DIR_NLINK
>>> 	EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE
>>> 	EXT4_FEATURE_INCOMPAT_FILETYPE
>>> 	EXT4_FEATURE_INCOMPAT_FLEX_BG
>> 
>> The above set of features itself looks harmless enough, since they
>> have been around for a long time and are mostly just relaxing checks
>> in the code.  However, I don't think that introducing a NEW feature
>> flag will allow the checks for the old features to be removed from
>> the code for a long time, so it will just mean checks for two features
>> everywhere in the kernel and e2fsprogs.
> 
> Oh, absolutely.  We'd define new inline functions which would check
> for METADATA_BUNDLE_1 (for example) as well as those extra features,
> and they would be around for a long time.
> 
>> Also consider things like INCOMPAT_COMPRESSION and HAS_JOURNAL.
>> It would be a shame if we had made a decision like this in the
>> past and could not turn these features off, so being able to
>> selectively disable these features in the future also has benefits.
> 
> Well, yes.  I specifically picked the above features as ones where
> there really is no downside to enabling them.  That's why the htree
> feature is missing from the list; that was a deliberate choice on my
> part.
> 
>> Couldn't this all be done in the tools level, instead of changing
>> the feature flags?  Have debugfs/dumpe2fs/tune2fs treat a set
>> of feature flags as "default_ext4" would be equivalent?
> 
> There are two reasons to do this, in my mind.  One is it shortens the
> long list of feature flags that get displayed by dumpe2fs and which
> some people might want to specify on the mke2fs command line.  That is
> definitely something that can be done at the tools level, yes.
> 
> The other reason to do this, though, is to make it very clear that
> this is the bundle that we really are supporting, to discourage people
> from creating file systems that have flex_bg, but not sparse_super,
> for example.  The goal is to reduce the testing matrix, very
> explicitly.  Yes, we could do the same thing on the ext4 wiki (once
> kernel.org fixes it so we can update it, sigh), but I think it makes
> much more of an impact when it's in the source code.
> 
>> This could also be done at the tools level, by preventing users from
>> setting strange combinations of feature flags unless they pass the
>> "--yes-this-feature-combination-is-untested" to mke2fs, tune2fs,
>> and debugfs, and deprecating truly ancient features entirely.

I think that making it difficult for users to use anything but the default
options in mke2fs/tune2fs/debugfs is equivalent to what you suggest.
Unless you prevent the use of the old feature flags entirely, then it
would still be possible to create filesystems with mixed up combinations
of features.  I think the important outcome is that users are clearly
made aware that they are stepping off the well-trodden path, and if
things break they get to keep both pieces.  Having two feature flags
that mean the same thing doesn't really help this, IMHO.

>> I would be happy to just deprecate ancient features like
>> SPARSE_SUPER, LARGE_FILE, FILETYPE, v1 filesystems entirely, and
>> prevent them from being turned off, and have e2fsck "fix" any such
>> filesystem that it finds (with a clear warning).  If such ancient
>> filesystems exist, they will not be running new e2fsprogs either.
> 
> Sure, and in some sense that's what I am doing by proposing that we
> define a new INCOMPAT metadata flag which does exactly this.

I think the only way to simplify the code is to explicitly remove the
ability to disable certain features (like the above) and then treat
filesystems without those features as broken and fix them with e2fsck.
That allows removing the conditional code from mke2fs/tune2fs at least.

> I could
> have done it by just bumping the major number in the superblock, but
> that would have caused progams like dumpe2fs to completely break.
> Using a new flag to bundle a new ones, especially when it's very easy
> to convert back and forth, is something that makes a lot of sense.

Changing the version number would be a step in the wrong direction.

>> Next in line would be EXT_ATTR (with v1 xattrs) and DIR_INDEX,
>> since they have been supported in ext3 for a long time.  It is
>> probably too early to deprecate DIR_NLINK, EXTRA_ISIZE, HUGE_FILE
>> and FLEX_BG, since they are new in ext4, but eventually those too.
> 
> I'd bundle EXT_ATTR in as well, but I wouldn't bundle in DIR_INDEX,
> since there are times when people don't want it on.  
> 
>> One improvement of the ZFS implementation is that it distinguishes
>> between "allowed" features and "in-use" features.  That allows the
>> maximum set of features to be enabled at format/upgrade time, but
>> doesn't cause interoperability problems until the features are used.
> 
> How does this work in practice?  How does the feature make the
> transition from "allowed" to "in-use"?

"allowed" features are set at format time or at "upgrade" time
(there was always an "upgrade" step needed for ZFS to explicitly
enable all of those features, whether they are needed or not).
The "in use" feature is actually a counter associated with each one,
which is basically a reference count for that feature.

What it means when a feature is allowed is that it can be used at
any time by the kernel.  If ext4 had allowed flags, then features
like LARGE_FILE and HUGE_FILE would normally be "allowed", and if
a file >2GB or >2TB were created the appropriate feature would be
incremented and become "in use".  Older kernels that didn't understand
e.g. HUGE_FILE would be prevented from mounting (or writing) to that
filesystem while there are files >2TB in existence.  Before any
exist, or when they are all deleted the HUGE_FILE feature reverts
to "allowed" and older kernels can access the filesystem.

> What does it mean if a feature bit is set in the "allowed" field
> of the superblock?

A feature which is "allowed" can become "in use" at any time, as
needed by usage or configuration of the filesystem.  If the admin
doesn't want a feature to become "in use" (e.g. wants to be able
to downgrade to some older kernel that doesn't understand some
specific feature) then it should not be marked "allowed" at all.

> And who gets to make the decision about starting to use some new
> feature?

That depends on the feature.  In some cases, the feature becomes
in-use based on filesystem usage.  Ext4 cases like this would be
EXT_ATTR (when xattrs are first set), LARGE_FILE (file >2GB created),
HUGE_FILE (file >2TB created), DIR_NLINK (>32000 hard links/subdirs),
RECOVER (journaled filesystem is mounted r/w).  If any of those
features are not in "allowed", then the kernel would refuse to use
this feature.

In other cases, the feature becomes in use depending on administrator
action.  For example EXTENTS would be enabled only if a filesystem is
mounted "-o extent" and file is created.

In essence, the ext4 feature flags are equivalent to "allowed", since
they have to be set before a feature can be used.  There is no way of
tracking if a feature _is_ being used, so if there may be files over
2TB in size then HUGE_FILE has to be enabled (making the filesystem
immediately RO_COMPAT to older kernels) even if there are not yet
any files that large.

> How do you know that you have both an upgraded kernel *and* upgraded
> userspace?

If userspace is not upgraded, then the feature flags would not yet
be set to "allowed".  If someone upgrades userspace, sets a feature
as allowed, and then it becomes in-use, it means that an older
kernel can only mount read-only, or not at all.  If a feature is
allowed, but not yet in-use, then there is no affect on the older
kernel.

Cheers, Andreas





