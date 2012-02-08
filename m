From: Ted Ts'o <tytso@mit.edu>
Subject: Collapsing the number of feature flags (was Re: [PATCH v2.3 00/23]
 ext4: Add metadata checksumming)
Date: Wed, 8 Feb 2012 13:08:47 -0500
Message-ID: <20120208180847.GA3654@thunk.org>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35606 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2BHSIv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 13:08:51 -0500
Content-Disposition: inline
In-Reply-To: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I've started looking at this patch series, and I'm wondering if it
might be better if we collapse these two feature flags:

	EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
and
	EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM

To a single feature flag, EXT4_FEATURE_INCOMPAT_METADATA_CSUM, which
also implies EXT4_FEATURE_RO_COMPAT_GDT_CSUM.  (So in the future, when
we enable INCOMPAT_CSUM_METADATA, the presense or absence of
EXT4_RO_COMPAT_GDT_CSUM won't matter, and in fact mke2fs will skip
setting that feature flag altogether.  Tune2fs could also drop the
GDT_CSUM flag when adding the CSUM_METADATA flag.)

The reasoning behind this is that it simplifies the combinatorics we
need to test, and it also simplifies our code base.  In addition, it's
really easy to make tune2fs recalculate the checksums when the feature
flag is set, and reculate the block group checksums using the old
algorithm when the metadata flag is unset.  So if someone wants to
mount the file system on a downlevel kernel, it's really not that bad
that this feature is an INCOMPAT feature; we can easily downgrade it
using tune2fs.

In fact, if we wanted to take this to extremes, we could call it
EXT4_FEATURE_INCOMPAT_NEW_METADATA, and then let it imply the
following feature flags as well:

	EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER
	EXT4_FEATURE_RO_COMPAT_LARGE_FILE
	EXT4_FEATURE_RO_COMPAT_HUGE_FILE
	EXT4_FEATURE_RO_COMPAT_DIR_NLINK
	EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE
	EXT4_FEATURE_INCOMPAT_FILETYPE
	EXT4_FEATURE_INCOMPAT_FLEX_BG

We can add inline functions in fs/ext4/ext4.h and in
lib/ext2fs/ext2fs.h to make the source code look a bit simpler.

This would help to reduce our testing load, and it would also make the
output of dumpe2fs easier to understand...

						- Ted

