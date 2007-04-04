From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue update
Date: Wed, 04 Apr 2007 15:40:14 -0700
Message-ID: <1175726415.3777.60.camel@ibm-237399vnbgl.beaverton.ibm.com>
References: <45FFFBAA.6080404@bull.net> <4613DB20.1040605@bull.net>
	 <20070404192159.GS5967@schatzie.adilger.int>
	 <1175721499.3777.32.camel@ibm-237399vnbgl.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: shaggy@us.ibm.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52789 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXDDWkR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 18:40:17 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l34MeHBm004448
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 18:40:17 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l34MeH4b105496
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 16:40:17 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l34MeG6X028226
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 16:40:17 -0600
In-Reply-To: <1175721499.3777.32.camel@ibm-237399vnbgl.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

I Just rebased the ext4 patch queue to 2.6.21-rc5,

# Added Reserve high 32 bit for 64 bit inode version
i_version_hi.patch

# Add mount option to turn off extents
ext4_noextent_mount_opt.patch

# Add mount option to turn off delayed allocation
ext4_nodelalloc_mount_opt.patch

And move nanosecond patch before the delayed allocation patches.

fsx test passed on ppc64,x86 and x86_64.
http://repo.or.cz/w/ext4-patch-queue.git


# Rebased the patches to 2.6.21-rc4

# New patch to fix whitespace before applying new patches
whitespace.patch

# Replaced truncated beginning comments
extent-overlap-bugfix

persistent_allocation_1_ioctl_and_unitialized_extents

# Fixed an endian error
persistent_allocation_2_support_for_writing_to_unitialized_extent

# updated to latest version
nanosecond_timestamps.patch

# i_verion
# Reserve high 32 bit for 64 bit inode version
# Missing the full inode version patch
i_version_hi.patch


# Add mount option to turn off extents
ext4_noextent_mount_opt.patch

##############################################################
# Unstable patches
# Note: still lots of outstanding comments from linux-ext4 list, 12/2006
# Missing signed-off-by:
booked-page-flag.patch

# Missing signed-off-by:
ext4-block-reservation.patch

# fixed a bunch of endianness errors reported by sparse
# Needs a signed-off-by from Alex, then can add shaggy's
ext4-delayed-allocation.patch

ext4-delalloc-extents-48bit.patch

# Add mount option to turn off delayed allocation
ext4_nodelalloc_mount_opt.patch
