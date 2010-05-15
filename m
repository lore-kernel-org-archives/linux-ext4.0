From: Ivan Shmakov <ivan@main.uusia.org>
Subject: Re: [PATCH] libblkid: support for GUID Partition Table (GPT), please?
Date: Sat, 15 May 2010 10:06:23 +0700
Message-ID: <87vdapkgnk.fsf@violet.siamics.net>
References: <87632ql0pg.fsf@violet.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: Ivan Shmakov <oneingray@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35821 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0EODGk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 May 2010 23:06:40 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1OD7i2-0000ba-M3
	for linux-ext4@vger.kernel.org; Sat, 15 May 2010 05:06:38 +0200
Received: from 81.201.254.124 ([81.201.254.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 15 May 2010 05:06:38 +0200
Received: from oneingray by 81.201.254.124 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 15 May 2010 05:06:38 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>>>> "IS" =3D=3D Ivan Shmakov <ivan@main.uusia.org> writes:

 IS> GPT contains a supposed to be unique =E2=80=9CDisk GUID=E2=80=9D field=
, which
 IS> allows for the media bearing such a partition table to be
 IS> identified.

 IS> May I suggest adding support for GPT to libblkid?  An alpha-quality
 IS> patch is MIME'd.

	Ahem.  Wrong copy-paste late at night.  Should be better this
	time.

	For a test:

$ blkid -t TYPE=3Dgpt /dev/sd?=20
/dev/sdb: UUID=3D"CE050C6F-E7BE-AD46-8FEE-F02476EC767E" TYPE=3D"gpt"=20
/dev/sdd: UUID=3D"2A1210B5-535F-4A4A-84D0-34ABC6E57FFB" TYPE=3D"gpt"=20
/dev/sde: UUID=3D"7B0FA8C6-26DD-1840-BBF5-46AD26CA551C" TYPE=3D"gpt"=20
/dev/sdf: UUID=3D"04DF9DE5-CFDA-514D-99B7-CC61061FCE3C" TYPE=3D"gpt"=20
$=20

	Please note that the CRC-32 value contained in the GPT is not
	checked.

	The UUID could be printed in lower case instead.

=2D-=20
FSF associate member #7257

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6b75732..8500320 100644
=2D-- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1383,6 +1383,33 @@ static int probe_btrfs(struct blkid_probe *probe,
 	set_uuid(probe->dev, bs->fsid, 0);
 	return 0;
 }
+
+static int probe_gpt (struct blkid_probe *probe,
+                      struct blkid_magic *id,
+                      unsigned char *buf)
+{
+	struct gpt_header *gh
+		=3D (struct gpt_header *)(buf + 0x200);
+
+	/* FIXME: check gh->header_crc32 */
+
+	{
+		const __u8 *u =3D gh->disk_guid;
+		char uuid_str[33];
+
+		sprintf (uuid_str,
+			 ("%02X%02X%02X%02X"
+			  "-%02X%02X-%02X%02X-%02X%02X"
+			  "-%02X%02X%02X%02X%02X%02X"),
+			 u[0], u[1], u[2], u[3],
+			 u[4], u[5], u[6], u[7], u[8], u[9],
+			 u[10], u[11], u[12], u[13], u[14], u[15]);
+		blkid_set_tag (probe->dev, "UUID", uuid_str, 0);
+	}
+
+	return 0;
+}
+
 /*
  * Various filesystem magics that we can check for.  Note that kboff and
  * sboff are in kilobytes and bytes respectively.  All magics are in
@@ -1482,6 +1509,7 @@ static struct blkid_magic type_array[] =3D {
   { "lvm2pv",	 1,  0x018,  8, "LVM2 001",		probe_lvm2 },
   { "lvm2pv",	 1,  0x218,  8, "LVM2 001",		probe_lvm2 },
   { "btrfs",	 64,  0x40,  8, "_BHRfS_M",		probe_btrfs },
+  { "gpt",       0,  0x200,  8, "EFI PART",             probe_gpt },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
=20
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37fc9c0..4d39b84 100644
=2D-- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -725,6 +725,28 @@ struct btrfs_super_block {
 	__u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 } __attribute__ ((__packed__));
=20
+struct gpt_header {
+	/* references:
+	 *   * linux/include/linux/efi.h;
+	 *   * Wikipedia entry.
+	 */
+	__u64 signature;
+	__u32 revision;
+	__u32 header_size;
+	__u32 header_crc32;
+	__u32 reserved1;
+	__u64 my_lba;
+	__u64 alternate_lba;
+	__u64 first_usable_lba;
+	__u64 last_usable_lba;
+	__u8 disk_guid[16];
+	__u64 partition_entry_lba;
+	__u32 num_partition_entries;
+	__u32 sizeof_partition_entry;
+	__u32 partition_entry_array_crc32;
+	__u8 reserved2[512 - 92];
+} __attribute__ ((__packed__));
+
 /*
  * Byte swap functions
  */

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvuD7EACgkQ+MvqjYjLOAwswgCZAVUwXaGd0we2Ul2NsHlt2MMc
RmIAnio+pvfCP3zmkzjufrZ7ZMrSoLFA
=v738
-----END PGP SIGNATURE-----
--==-=-=--

