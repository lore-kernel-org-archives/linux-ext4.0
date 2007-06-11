From: Karsten Hopp <karsten@redhat.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Mon, 11 Jun 2007 13:51:24 +0200
Message-ID: <466D373C.6000502@redhat.com>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070301080601080808090700"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXFKLvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2007 07:51:35 -0400
In-Reply-To: <20070608153600.GA9726@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070301080601080808090700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Theodore Tso schrieb:
> In addition to the comments already posted:
> 
>> +/* check it manually as using LUKS_read_phdr from libcryptsetup
>> + * prints too many warnings if it isn't a luks partition and would add a
>> + * dependency on the lib */
>> +static int probe_luks(struct blkid_probe *probe,
>> +		       struct blkid_magic *id __BLKID_ATTR((unused)), 
>> +		       unsigned char *buf)
>> +{
>> +	const char *luks_magic = id->bim_magic;
>> +	unsigned char *p_buf = buf;
>> +	unsigned char uuid[40];
>> +	if(strncmp(buf, luks_magic, strlen(luks_magic)) == 0)   /* ID matches, continue */
> 
> There's no point in doing this check, since it's replicating a check
> already done in the generic code.  The probe function won't be called
> if the bim_magic didn't match the specified offset. 
> 
> 						- Ted

Thanks everyone for the replys.
I'll attach a new patch with the suggested fixes.

    Karsten

--
  Karsten Hopp        | Mail: karsten@redhat.de
  Red Hat Deutschland | Tel: +49-711-96437-0
  Hauptstaetterstr.58 | Fax: +49-711-613590
  D-70178 Stuttgart   | http://www.redhat.de

--------------070301080601080808090700
Content-Type: text/x-patch;
 name="e2fsprogs-1.39-luks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e2fsprogs-1.39-luks.patch"

e2fsprogs-1.39-luks.patch
Problem:        libblkid doesn't detect/report UUIDs of cryptsetup-luks partitions
Solution:       Add probe for luks UUID
Signed-off-by:  Karsten Hopp <karsten@redhat.com>

--- e2fsprogs-1.39/lib/blkid/ChangeLog.luksuuid	2007-06-11 13:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/blkid/ChangeLog	2007-06-11 13:40:14.000000000 +0200
@@ -0,0 +1,4 @@
+2007-05-22  Karsten Hopp  <karsten@redhat.com> 
+
+	* probe.c (probe_luks): Add support for cryptsetup-luks partitions
+
--- e2fsprogs-1.39/lib/blkid/probe.c.luksuuid	2007-06-11 13:40:14.000000000 +0200
+++ e2fsprogs-1.39/lib/blkid/probe.c	2007-06-11 13:46:28.000000000 +0200
@@ -468,6 +468,20 @@ static int probe_jfs(struct blkid_probe 
 	return 0;
 }
 
+static int probe_luks(struct blkid_probe *probe,
+		       struct blkid_magic *id __BLKID_ATTR((unused)), 
+		       unsigned char *buf)
+{
+	unsigned char *p_buf = buf;
+	unsigned char uuid[40];
+	/* 168 is the offset to the 40 character uuid: 
+	 * http://luks.endorphin.org/LUKS-on-disk-format.pdf */
+	p_buf += 168;
+	strncpy(uuid, p_buf, 40);
+	blkid_set_tag(probe->dev, "UUID", uuid, sizeof(uuid));
+	return 0;
+}
+
 static int probe_romfs(struct blkid_probe *probe,
 		       struct blkid_magic *id __BLKID_ATTR((unused)), 
 		       unsigned char *buf)
@@ -775,6 +789,7 @@ static struct blkid_magic type_array[] =
   { "ocfs2",	 2,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 4,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 8,	 0,  6,	"OCFSV2",		probe_ocfs2 },
+  { "crypt_LUKS",0,	 0,  6,	"LUKS\xba\xbe",		probe_luks },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 

--------------070301080601080808090700--
