From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] - detect LVM2 PVs in libblkid
Date: Wed, 30 Jan 2008 17:25:03 -0600
Message-ID: <47A1074F.8090909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYA3XZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 18:25:05 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0UNP5Du021531
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:25:05 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0UNP4tQ014014
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:25:04 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0UNP3uq005976
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:25:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The anaconda folks are now using blkid instead of hand-rolled
tests for filesystem type at install time, but they had one
more request:

Bugzilla Bug 409321: RFE: information on blkdevs "formatted" as PVs
https://bugzilla.redhat.com/show_bug.cgi?id=409321

The attached patch does the right thing for me on my sample
set of exactly 1 PV...

Any issues with reporting back something which is not actually
a filesystem ("lvm2pv") ?

[root@host]# misc/blkid -c /dev/null /dev/sda2
/dev/sda2: UUID="guOQGdcOE3IafCm0190XkPZTy5fCEanQ" TYPE="lvm2pv" 
[root@host]# pvs -o pv_name,pv_uuid
  PV         PV UUID                               
  /dev/sda2  guOQGd-cOE3-IafC-m019-0XkP-ZTy5-fCEanQ

Bits liberally stolen from lvm2 userspace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: e2fsprogs-1.40.5/lib/blkid/probe.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/blkid/probe.h
+++ e2fsprogs-1.40.5/lib/blkid/probe.h
@@ -531,6 +531,20 @@ struct hfs_mdb {
         __u16        embed_blockcount;
 } __attribute__((packed));
 
+/* this is lvm's label_header & pv_header combined. */
+
+#define LVM2_ID_LEN 32
+
+struct lvm2_pv_label_header {
+	/* label_header */
+	__u8	id[8];		/* LABELONE */
+	__u64	sector_xl;	/* Sector number of this label */
+	__u32	crc_xl;		/* From next field to end of sector */
+	__u32	offset_xl;	/* Offset from start of struct to contents */
+	__u8	type[8];	/* LVM2 001 */
+	/* pv_header */
+	__u8	pv_uuid[LVM2_ID_LEN];
+} __attribute__ ((packed));
 
 /*
  * Byte swap functions
Index: e2fsprogs-1.40.5/lib/blkid/probe.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/blkid/probe.c
+++ e2fsprogs-1.40.5/lib/blkid/probe.c
@@ -895,6 +895,64 @@ static int probe_hfsplus(struct blkid_pr
 	return 1;
 }
 
+#define LVM2_LABEL_SIZE 512
+static int lvm2_calc_crc(const void *buf, uint size)
+{
+	static const uint crctab[] = {
+		0x00000000, 0x1db71064, 0x3b6e20c8, 0x26d930ac,
+		0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c,
+		0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c,
+		0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c
+	};
+	uint i, crc = 0xf597a6cf;
+	const __u8 *data = (const __u8 *) buf;
+
+	for (i = 0; i < size; i++) {
+		crc ^= *data++;
+		crc = (crc >> 4) ^ crctab[crc & 0xf];
+		crc = (crc >> 4) ^ crctab[crc & 0xf];
+	}
+	return crc;
+}
+
+static int probe_lvm2(struct blkid_probe *probe,
+			struct blkid_magic *id __BLKID_ATTR((unused)),
+			unsigned char *buf)
+{
+	int sector = (id->bim_kboff) << 1;;
+	struct lvm2_pv_label_header *label;
+	label = (struct lvm2_pv_label_header *)buf;
+
+	/* buf is at 0k or 1k offset; find label inside */
+	if (memcmp(buf, "LABELONE", 8) == 0) {
+		label = (struct lvm2_pv_label_header *)buf;
+	} else if (memcmp(buf + 512, "LABELONE", 8) == 0) {
+		label = (struct lvm2_pv_label_header *)(buf + 512);
+		sector++;
+	} else {
+		return 1;
+	}
+
+	if (blkid_le64(label->sector_xl) != sector) {
+		DBG(DEBUG_PROBE,
+		    printf("LVM2: label for sector %d found at sector %d\n",
+			   blkid_le64(label->sector_xl), sector));
+		return 1;
+	}
+
+	if (lvm2_calc_crc(&label->offset_xl, LVM2_LABEL_SIZE -
+		((void *)&label->offset_xl - (void *)label)) !=
+			blkid_le32(label->crc_xl)) {
+		DBG(DEBUG_PROBE,
+		    printf("LVM2: label checksum incorrect at sector %d\n",
+			   sector));
+		return 1;
+	}
+
+	blkid_set_tag(probe->dev, "UUID", label->pv_uuid, LVM2_ID_LEN);
+
+	return 0;
+}
 /*
  * BLKID_BLK_OFFS is at least as large as the highest bim_kboff defined
  * in the type_array table below + bim_kbalign.
@@ -988,6 +1046,10 @@ static struct blkid_magic type_array[] =
   { "crypt_LUKS", 0,	 0,  6,	"LUKS\xba\xbe",		probe_luks },
   { "squashfs",	 0,	 0,  4,	"sqsh",			0 },
   { "squashfs",	 0,	 0,  4,	"hsqs",			0 },
+  { "lvm2pv",	 0,  0x218,  8, "LVM2 001",		probe_lvm2 },
+  { "lvm2pv",	 0,  0x018,  8, "LVM2 001",		probe_lvm2 },
+  { "lvm2pv",	 1,  0x018,  8, "LVM2 001",		probe_lvm2 },
+  { "lvm2pv",	 1,  0x218,  8, "LVM2 001",		probe_lvm2 },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 
