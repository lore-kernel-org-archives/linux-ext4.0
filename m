From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsprogs: fix ZFS filesystem detection
Date: Thu, 5 Aug 2010 17:07:35 -0600
Message-ID: <028169F5-CC91-4E3F-872F-2CB105089006@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-89--52739202
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:38682 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab0HEX0b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 19:26:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-89--52739202
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

While blkid has mostly migrated to util-linux-ng (which has gotten a =
more
sophisticated checking routine), the existing e2fsprogs ZFS filesystem
detection isn't always correct.  Fix the ZFS device detection by looking =
at
multiple uberblocks to see if any are present, rather than looking for =
the ZFS
boot block which is not always present.

There may be up to 128 uberblocks, but the first 4 are not written to =
disk
on a newly-formatted filesystem so check several of them at different
offsets within the uberblock array.

Cheers, Andreas



--Apple-Mail-89--52739202
Content-Disposition: attachment;
	filename=e2fsprogs-blkid-zfs.patch
Content-Type: application/octet-stream;
	name="e2fsprogs-blkid-zfs.patch"
Content-Transfer-Encoding: 7bit

Fix the ZFS device detection by looking at multiple uberblocks to see if
any are present, rather than looking for the ZFS boot block which is not
always present.

There may be up to 128 uberblocks, but the first 4 are not written to disk
on a newly-formatted filesystem so check several of them at different
offsets within the uberblock array.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-1.41.4/lib/blkid/probe.h
===================================================================
--- e2fsprogs-1.41.4.orig/lib/blkid/probe.h
+++ e2fsprogs-1.41.4/lib/blkid/probe.h
@@ -193,6 +193,16 @@ struct jfs_super_block {
 	unsigned char	js_loguuid[16];
 };
 
+#define UBERBLOCK_MAGIC         0x00bab10c              /* oo-ba-bloc!  */
+struct zfs_uberblock {
+	__u64		ub_magic;	/* UBERBLOCK_MAGIC		*/
+	__u64		ub_version;	/* ZFS_VERSION			*/
+	__u64		ub_txg;		/* txg of last sync		*/
+	__u64		ub_guid_sum;	/* sum of all vdev guids	*/
+	__u64		ub_timestamp;	/* UTC time of last sync	*/
+	char		ub_rootbp;	/* MOS objset_phys_t		*/
+};
+
 struct romfs_super_block {
 	unsigned char	ros_magic[8];
 	__u32		ros_dummy1[2];
Index: e2fsprogs-1.41.4/lib/blkid/probe.c
===================================================================
--- e2fsprogs-1.41.4.orig/lib/blkid/probe.c
+++ e2fsprogs-1.41.4/lib/blkid/probe.c
@@ -1359,10 +1359,19 @@ static struct blkid_magic type_array[] =
   { "iso9660",	32,	 1,  5, "CD001",		probe_iso9660 },
   { "iso9660",	32,	 9,  5, "CDROM",		probe_iso9660 },
   { "jfs",	32,	 0,  4, "JFS1",			probe_jfs },
-  { "zfs",       8,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
-  { "zfs",       8,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },
-  { "zfs",     264,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
-  { "zfs",     264,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },
+  /* ZFS has 128 root blocks (#4 is the first used), check only 6 of them */
+  { "zfs",     128,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     128,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     132,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     132,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     136,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     136,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     384,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     384,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     388,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     388,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
+  { "zfs",     392,	 0,  8, "\0\0\0\0\0\xba\xb1\x0c", probe_zfs },
+  { "zfs",     392,	 0,  8, "\x0c\xb1\xba\0\0\0\0\0", probe_zfs },
   { "hfsplus",	 1,	 0,  2, "BD",			probe_hfsplus },
   { "hfsplus",	 1,	 0,  2, "H+",			probe_hfsplus },
   { "hfsplus",	 1,	 0,  2, "HX",			probe_hfsplus },

--Apple-Mail-89--52739202--
