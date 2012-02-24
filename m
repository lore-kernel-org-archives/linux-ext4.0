From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] ext4: clean up the flags passed to __blockdev_direct_IO for extent-based files
Date: Fri, 24 Feb 2012 16:49:21 -0500
Message-ID: <x49zkc7c36m.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2BXVtW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 16:49:22 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1OLnMgW021334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 16:49:22 -0500
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q1OLnLNp026734
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 16:49:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

For extent-based files, you can perform DIO to holes, as mentioned in
the comments in ext4_ext_direct_IO.  However, that function passes
DIO_SKIP_HOLES to __blockdev_direct_IO, which is *really* confusing to
the uninitiated reader.  The key, here, is that the get_block function
passed in, ext4_get_block_write, completely ignores the create flag that
is passed to it (the create flag is passed in from the direct I/O code,
which uses the DIO_SKIP_HOLES flag to determine whether or not it should
be cleared).

This is a long-winded way of saying that the DIO_SKIP_HOLES flag is
ultimately ignored.  So, in the interest of preserving sanity, I propose
the following patch.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..521ca03 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2940,7 +2940,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 					 ext4_get_block_write,
 					 ext4_end_io_dio,
 					 NULL,
-					 DIO_LOCKING | DIO_SKIP_HOLES);
+					 DIO_LOCKING);
 		if (iocb->private)
 			EXT4_I(inode)->cur_aio_dio = NULL;
 		/*
