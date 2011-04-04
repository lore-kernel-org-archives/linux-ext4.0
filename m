From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Mon, 04 Apr 2011 15:11:52 -0400
Message-ID: <4D9A17F8.4000406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab1DDTLy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 15:11:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Block devices may set minimum or optimal IO hints equal to
blocksize; in this case there is really nothing for ext4
to do with this information (i.e. search for a block-aligned
allocation?) so don't set fs geometry with single-block
values.

Zeev also reported that with a block-sized stripe, the
ext4 allocator spends time spinning in ext4_mb_scan_aligned(),
oddly enough.

Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9798b88..74b838c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1135,8 +1135,11 @@ static int get_device_geometry(const char *file,
 	if ((opt_io == 0) && (psector_size > blocksize))
 		opt_io = psector_size;
 
-	fs_param->s_raid_stride = min_io / blocksize;
-	fs_param->s_raid_stripe_width = opt_io / blocksize;
+	/* setting stripe/stride to blocksize is pointless */
+	if (min_io > blocksize)
+		fs_param->s_raid_stride = min_io / blocksize;
+	if (opt_io > blocksize)
+		fs_param->s_raid_stripe_width = opt_io / blocksize;
 
 	rc = blkid_topology_get_alignment_offset(tp);
 out:

