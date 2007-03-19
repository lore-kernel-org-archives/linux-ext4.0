From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: cleaned up ext4 patch series
Date: Mon, 19 Mar 2007 10:48:28 -0500
Message-ID: <1174319308.11636.8.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33595 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030268AbXCSPsd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2007 11:48:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2JFmVSm031718
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:48:31 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2JFmTwH219814
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:48:31 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2JFmTuX018813
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:48:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
I have rebased the ext4 patchset on 2.6.21-rc4 and cleaned up some bad
whitespace and sparse warnings.  The patches are here:
http://www.kernel.org/pub/linux/kernel/people/shaggy/ext4/ext4-2007-03-19.tar.bz2
Untarred here:
http://www.kernel.org/pub/linux/kernel/people/shaggy/ext4/ext4-2007-03-19/

I have commented the series file with the changes I've made.  Some of
the patches are missing signed-of-by:

# Rebased the patches to 2.6.21-rc4

# New patch to fix whitespace before applying new patches
whitespace.patch

# Replaced truncated beginning comments
extent-overlap-bugfix

persistent_allocation_1_ioctl_and_unitialized_extents

# Fixed an endian error
persistent_allocation_2_support_for_writing_to_unitialized_extent

# Note: still lots of outstanding comments from linux-ext4 list, 12/2006
# Missing signed-off-by:
booked-page-flag.patch

# Missing signed-off-by:
ext4-block-reservation.patch

# fixed a bunch of endianness errors reported by sparse
# Needs a signed-off-by from Alex, then can add shaggy's
ext4-delayed-allocation.patch

ext4-delalloc-extents-48bit.patch

# updated to latest version
nanosecond_timestamps.patch

-- 
David Kleikamp
IBM Linux Technology Center
