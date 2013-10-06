From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 0/7] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Date: Mon,  7 Oct 2013 05:12:20 +0900
Message-ID: <1381090340-2693-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
	hch@infradead.org, david@fromorbit.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54611 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3JFUMl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Oct 2013 16:12:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch series is in response of the following post:
http://lwn.net/Articles/556136/
"ext4: introduce two new ioctls"

Dave chinner suggested that truncate_block_range (which was one of the ioctls name)
should be an fallocate operation and not any fs specific ioctl, hence
we add this functionality to fallocate.

This patch series introduces new flag FALLOC_FL_COLLAPSE_RANGE for fallocate
and implements it for XFS and Ext4.

The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned.

This new functionality of collapsing range could be used by media editing tools
which does non linear editing to quickly purge and edit parts of a media file.
This will immensely improve the performance of these operations.
The limitation of fs block size aligned offsets can be easily handled
by media codecs which are encapsulated in a conatiner as they have to
just change the offset to next keyframe value to match the proper alignment.

Change log
v3:
 Fix checkpatch.pl errors

v2:
 Fix review points from Dave Chinner.
  - merge adjacent extents
  - fix journal log usage.
  - change reasonable function name.
  - update xfsio, xfstest, manpage
  - etc.

Namjae Jeon (7):
  fs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  xfs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  ext4: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  xfstest: Add test case to check various corner cases for collapsing range
  xfstest: Add test case to test multiple collapse range call
  manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate

-- 
1.7.9.5

