From: Karsten Hopp <karsten@redhat.com>
Subject: Patch to support LUKS UUIDs in libblkid
Date: Tue, 05 Jun 2007 13:23:10 +0200
Message-ID: <4665479E.2060707@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020105000003030409000105"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205AbXFELXM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 07:23:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l55BNBfA011481
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 07:23:11 -0400
Received: from pobox.stuttgart.redhat.com (pobox.stuttgart.redhat.com [172.16.2.10])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l55BNAH3031905
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 07:23:11 -0400
Received: from hagen.stuttgart.redhat.com (hagen.stuttgart.redhat.com [10.32.5.40])
	by pobox.stuttgart.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id l55BNA13023680
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 13:23:10 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------020105000003030409000105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've already posted this at the e2fsprogs sourceforge site, but our e2fsprogs maintainer
suggested that I should post it here as well for a review:


Attached is a patch to add cryptsetup-luks UUID detection in libblkid.so
This is required when we want to use UUIDs instead of hardcoded device names for
encrypted partitions.


Regards

        Karsten Hopp


--
  Karsten Hopp        | Mail: karsten@redhat.de
  Red Hat Deutschland | Tel: +49-711-96437-0
  Hauptstaetterstr.58 | Fax: +49-711-613590
  D-70178 Stuttgart   | http://www.redhat.de

--------------020105000003030409000105
Content-Type: text/x-patch;
 name="e2fsprogs-1.39-luks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e2fsprogs-1.39-luks.patch"

e2fsprogs-1.39-luks.patch
Problem:        libblkid doesn't detect/report UUIDs of cryptsetup-luks partitions
Solution:       Add probe for luks UUID
Signed-off-by:  Karsten Hopp <karsten@redhat.com>

--- e2fsprogs-1.39/lib/blkid/ChangeLog.luksuuid	2007-05-22 20:51:54.000000000 +0200
+++ e2fsprogs-1.39/lib/blkid/ChangeLog	2007-05-22 20:55:08.000000000 +0200
@@ -0,0 +1,4 @@
+2007-05-22  Karsten Hopp  <karsten@redhat.com> 
+
+	* probe.c (probe_luks): Add support for cryptsetup-luks partitions
+
--- e2fsprogs-1.39/lib/blkid/probe.c.luksuuid	2007-05-22 14:48:12.000000000 +0200
+++ e2fsprogs-1.39/lib/blkid/probe.c	2007-05-22 20:49:17.000000000 +0200
@@ -468,6 +468,27 @@ static int probe_jfs(struct blkid_probe 
 	return 0;
 }
 
+/* check it manually as using LUKS_read_phdr from libcryptsetup
+ * prints too many warnings if it isn't a luks partition and would add a
+ * dependency on the lib */
+static int probe_luks(struct blkid_probe *probe,
+		       struct blkid_magic *id __BLKID_ATTR((unused)), 
+		       unsigned char *buf)
+{
+	const char *luks_magic = id->bim_magic;
+	unsigned char *p_buf = buf;
+	unsigned char uuid[40];
+	if(strncmp(buf, luks_magic, strlen(luks_magic)) == 0)   /* ID matches, continue */
+	{
+	/* 168 is the offset to the 40 character uuid: http://luks.endorphin.org/LUKS-on-disk-format.pdf */
+		p_buf += 168;
+		strncpy(uuid, p_buf, 40);
+		blkid_set_tag(probe->dev, "UUID", uuid, sizeof(uuid));
+		blkid_set_tag(probe->dev, "SEC_TYPE", "crypt_LUKS", sizeof("crypt_LUKS"));
+	}
+	return 0;
+}
+
 static int probe_romfs(struct blkid_probe *probe,
 		       struct blkid_magic *id __BLKID_ATTR((unused)), 
 		       unsigned char *buf)
@@ -775,6 +796,7 @@ static struct blkid_magic type_array[] =
   { "ocfs2",	 2,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 4,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 8,	 0,  6,	"OCFSV2",		probe_ocfs2 },
+  { "crypt_LUKS",		 0,	 0,	 6,	"LUKS\xba\xbe",			probe_luks },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 

--------------020105000003030409000105--
