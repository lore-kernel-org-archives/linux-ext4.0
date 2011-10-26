From: Andreas Dilger <aedilger@gmail.com>
Subject: bigalloc and max file size
Date: Wed, 26 Oct 2011 17:36:31 -0600
Message-ID: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60458 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1JZXgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 19:36:41 -0400
Received: by pzk36 with SMTP id 36so5833367pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 16:36:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
we were having a discussion about bigalloc and the maximum file size
(as limited by the 2^32 logical block number in struct ext4_extent).

Currently the maximum file size is blocksize * 2^32, 16TB for 4kB blocks.

Since it is not possible to allocate sub-blocks in the bigalloc code,
what about storing the "chunk number" in the extent logical block?

This would allow us to create files up to chunksize * 2^32.  With
a bigalloc chunk size of 1MB we could have a maximum file size of
2^(20 + 32) = 2^52 = 4PB, which is within spitting distance of the
maximum filesystem size of 2^56 bytes (4kB blocks * 2^48 blocks)
with the current extent format, and beyond reasonable limits today.

This essentially allows creating files as large as the filesystem size
without having to change the extent format, which is a good thing.

Is this implemented in bigalloc?  If not, it would be great to do
this before landing bigalloc in the upstream kernel, since it is
basically free to do, can already fall under the INCOMPAT_BIGALLOC
feature flag, and avoids issues in the near future.  I don't think
the e2fsprogs with bigalloc support is released yet either, so it
should still be OK to change the on-disk format?

Cheers, Andreas





