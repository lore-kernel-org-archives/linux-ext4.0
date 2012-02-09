From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3
	00/23] ext4: Add metadata checksumming)
Date: Thu, 9 Feb 2012 11:54:44 -0800
Message-ID: <20120209195444.GA15164@tux1.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120208180847.GA3654@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58621 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758516Ab2BITzS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Feb 2012 14:55:18 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Thu, 9 Feb 2012 14:55:17 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 217036E8060
	for <linux-ext4@vger.kernel.org>; Thu,  9 Feb 2012 14:54:45 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q19Jsj9D216876
	for <linux-ext4@vger.kernel.org>; Thu, 9 Feb 2012 14:54:45 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q19Jsiai021888
	for <linux-ext4@vger.kernel.org>; Thu, 9 Feb 2012 14:54:45 -0500
Content-Disposition: inline
In-Reply-To: <20120208180847.GA3654@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 08, 2012 at 01:08:47PM -0500, Ted Ts'o wrote:
> So I've started looking at this patch series, and I'm wondering if it
> might be better if we collapse these two feature flags:
> 
> 	EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
> and
> 	EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM
> 
> To a single feature flag, EXT4_FEATURE_INCOMPAT_METADATA_CSUM, which
> also implies EXT4_FEATURE_RO_COMPAT_GDT_CSUM.  (So in the future, when
> we enable INCOMPAT_CSUM_METADATA, the presense or absence of
> EXT4_RO_COMPAT_GDT_CSUM won't matter, and in fact mke2fs will skip
> setting that feature flag altogether.  Tune2fs could also drop the
> GDT_CSUM flag when adding the CSUM_METADATA flag.)

I'm ok with this.

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
> 
> We can add inline functions in fs/ext4/ext4.h and in
> lib/ext2fs/ext2fs.h to make the source code look a bit simpler.
> 
> This would help to reduce our testing load, and it would also make the
> output of dumpe2fs easier to understand...

Hm... does this make it impossible to add checksums to a fs that doesn't have
flexbg set?  I'm not 100% sure what happens if you enable the flexbg bit on a
filesystem that wasn't mkfs'd with that turned on.  Most of the other flags
look like they've been mkfs default for years, but I could be wrong.

I'm concerned that implementing this second idea would make it more difficult
to add checksums to an older filesystem.

--D
> 
> 						- Ted
> 

