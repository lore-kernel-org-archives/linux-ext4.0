From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3 00/23] ext4: Add metadata checksumming)
Date: Fri, 10 Feb 2012 12:11:10 -0700
Message-ID: <3EBD659A-0A10-4DAE-9EA9-E736CE187574@dilger.ca>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120208180847.GA3654@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6587 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760Ab2BJTLM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Feb 2012 14:11:12 -0500
In-Reply-To: <20120208180847.GA3654@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-08, at 11:08 AM, Ted Ts'o wrote:
> So I've started looking at this patch series, and I'm wondering if it
> might be better if we collapse these two feature flags:
> 
> 	EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
> and
> 	EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM
> 
> To a single feature flag, EXT4_FEATURE_INCOMPAT_METADATA_CSUM, which
> also implies EXT4_FEATURE_RO_COMPAT_GDT_CSUM.  (So in the future, when
> we enable INCOMPAT_CSUM_METADATA, the presence or absence of
> EXT4_RO_COMPAT_GDT_CSUM won't matter, and in fact mke2fs will skip
> setting that feature flag altogether.  Tune2fs could also drop the
> GDT_CSUM flag when adding the CSUM_METADATA flag.)

The only reason for INCOMPAT_BG_USE_META_CSUM is to change the checksum
algorithm for group descriptors from crc16 to half-crc32 to match the
other metadata checksums.

I'd rather keep the metadata checksum feature RO_COMPAT rather than
push it to INCOMPAT over this tiny-and-mostly-meaningless change.  If
enabling RO_COMPAT_METADATA_CSUM implies RO_COMPAT_GDT_CSUM, then it
could also imply that the GDT checksum is using half-crc32 easily.

> The reasoning behind this is that it simplifies the combinatorics we
> need to test, and it also simplifies our code base.  In addition, it's
> really easy to make tune2fs recalculate the checksums when the feature
> flag is set, and reculate the block group checksums using the old
> algorithm when the metadata flag is unset.  So if someone wants to
> mount the file system on a downlevel kernel, it's really not that bad
> that this feature is an INCOMPAT feature; we can easily downgrade it
> using tune2fs.
> 
> In fact, if we wanted to take this to extremes, we could call it
> EXT4_FEATURE_INCOMPAT_NEW_METADATA, and then let it imply the
> following feature flags as well:
> 
> 	EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER
> 	EXT4_FEATURE_RO_COMPAT_LARGE_FILE
> 	EXT4_FEATURE_RO_COMPAT_HUGE_FILE
> 	EXT4_FEATURE_RO_COMPAT_DIR_NLINK
> 	EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE
> 	EXT4_FEATURE_INCOMPAT_FILETYPE
> 	EXT4_FEATURE_INCOMPAT_FLEX_BG

The above set of features itself looks harmless enough, since they
have been around for a long time and are mostly just relaxing checks
in the code.  However, I don't think that introducing a NEW feature
flag will allow the checks for the old features to be removed from
the code for a long time, so it will just mean checks for two features
everywhere in the kernel and e2fsprogs.

A simpler implementation would be to have something like:

#define EXT4_FEATURE_RO_COMPAT_DEFAULT_EXT4 (list of above RO_COMPAT)
#define EXT4_FEATURE_INCOMPAT_DEFAULT_EXT4 (list of above INCOMPAT)

and fix libe2p to use "default_ext4" if all these flags are set.

Also consider things like INCOMPAT_COMPRESSION and HAS_JOURNAL.
It would be a shame if we had made a decision like this in the
past and could not turn these features off, so being able to
selectively disable these features in the future also has benefits.

> We can add inline functions in fs/ext4/ext4.h and in
> lib/ext2fs/ext2fs.h to make the source code look a bit simpler.

Couldn't this all be done in the tools level, instead of changing
the feature flags?  Have debugfs/dumpe2fs/tune2fs treat a set
of feature flags as "default_ext4" would be equivalent?

> This would help to reduce our testing load, and it would also make
> the output of dumpe2fs easier to understand...

This could also be done at the tools level, by preventing users from
setting strange combinations of feature flags unless they pass the
"--yes-this-feature-combination-is-untested" to mke2fs, tune2fs,
and debugfs, and deprecating truly ancient features entirely.


I would be happy to just deprecate ancient features like
SPARSE_SUPER, LARGE_FILE, FILETYPE, v1 filesystems entirely, and
prevent them from being turned off, and have e2fsck "fix" any such
filesystem that it finds (with a clear warning).  If such ancient
filesystems exist, they will not be running new e2fsprogs either.

Next in line would be EXT_ATTR (with v1 xattrs) and DIR_INDEX,
since they have been supported in ext3 for a long time.  It is
probably too early to deprecate DIR_NLINK, EXTRA_ISIZE, HUGE_FILE
and FLEX_BG, since they are new in ext4, but eventually those too.


Interestingly, ZFS had sequential versions (i.e. version N has to
support the on-disk format of every feature in N-1 forever), and
they have now moved over to using feature flags after I suggested
this to them 4 years ago, exactly for the reason that it gives them
the ability to develop/use features that may not be used everywhere.

One improvement of the ZFS implementation is that it distinguishes
between "allowed" features and "in-use" features.  That allows the
maximum set of features to be enabled at format/upgrade time, but
doesn't cause interoperability problems until the features are used.

Cheers, Andreas




 
