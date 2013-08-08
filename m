From: Andreas Dilger <adilger@dilger.ca>
Subject: i_file_acl bug with 64-bit
Date: Thu, 8 Aug 2013 17:20:39 -0600
Message-ID: <B394E5FB-91EE-4F8B-9CDF-5672D389EAB4@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49449 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Aug 2013 19:20:42 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so675080pbc.11
        for <linux-ext4@vger.kernel.org>; Thu, 08 Aug 2013 16:20:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was just looking at a problem with s_mmp_block and its
incorrect check to be within the filesystem - it was checking
that the 64-bit MMP block was below s_blocks_count (i.e. the
low 32 bits) instead of using ext2fs_blocks_count() (a patch
for this will follow).

However, a much bigger problem is that it appears i_file_acl
is being used directly in many places without checking for
i_file_acl_high, so xattr blocks written beyond 2^32 may
incorrectly be considered corrupt by e2fsck, since it is
checking the 32-bit truncated block number.

Unfortunately, I'm on my way out of the house for vacation, but
I thought I'd at least send a note about this.

Cheers, Andreas





