From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] ext4: Handle different max offsets for bitmap & extent-based
 files
Date: Tue, 04 Dec 2007 09:55:28 -0600
Message-ID: <47557870.9060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbXLDPza (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 10:55:30 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB4FtU8V016041
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:55:30 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FtTFJ022987
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:55:29 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FtSti025038
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:55:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Basic approach: have both ext4_max_bitmap_size() and ext4_max_size()
functions to compute max offsets for both types of formats.

Use vfs sb->s_maxbytes for the "native" maxbytes, i.e. extent-format files.

Put the smaller bitmap limit in a new sbi->s_bitmap_maxbytes in the ext4
superblock info structure.

Catch bitmap files in ext4_file_write() and ext4_setattr() to limit
extending writes, llseeks, and truncates to too-large offsets which the
VFS let through due to the extent-format maxbytes.  On write, allow
writes up to the max, but then stop, by using iov_shorten() to limit the
size of the write to the maximum.

3 patches follow:

ext4_two_maxbytes_functions.patch - differentiate the maxbytes f'ns
ext4_bitmap_maxbytes_vfs.patch - export iov_shorten from kernel
ext4_bitmap_maxbytes.patch - store, and limit to, bitmap_maxbytes

Comments?

Thanks,
-Eric
