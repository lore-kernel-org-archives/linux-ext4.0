From: Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: xattr corruption issue on ext2fs generated filesystems
Date: Sat, 06 Feb 2016 11:23:46 +0000
Message-ID: <1454757826.27087.300.camel@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 5751f4a1.skybroadband.com ([87.81.244.161]:52331 "EHLO
	dan.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbcBFLfJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Feb 2016 06:35:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by dan.rpsys.net (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u16BNlWs017390
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2016 11:23:47 GMT
Received: from dan.rpsys.net ([127.0.0.1])
	by localhost (dan.rpsys.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id GQhqz_I2Hc4P for <linux-ext4@vger.kernel.org>;
	Sat,  6 Feb 2016 11:23:47 +0000 (GMT)
Received: from hex ([192.168.3.34])
	(authenticated bits=0)
	by dan.rpsys.net (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u16BNkt4017386
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2016 11:23:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm using the -d option of mke2fs to construct a filesystem, I'm seeing
that some xattrs are being corrupted. The filesystem builds with no
errors but when mounted by the kernel, I see errors like "security.ima:
No such attribute". The strace from such a failure is:

mmap(NULL, 26258, PROT_READ, MAP_SHARED, 3, 0) = 0x7fdb36a8c000
close(3)                    = 0
getrlimit(RLIMIT_NOFILE, {rlim_cur=1024, rlim_max=64*1024}) = 0
lstat("mnt/foobar", {st_mode=S_IFREG|0755, st_size=1, ...}) = 0
listxattr("mnt/foobar", NULL, 0) = 30
listxattr("mnt/foobar", "security.SMACK64\0security.ima\0", 256) = 30
getxattr("mnt/foobar", "security.SMACK64", 0x0, 0) = 1
getxattr("mnt/foobar", "security.SMACK64", "_", 256) = 1
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 13), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fdb36a8b000
write(1, "# file: mnt/foobar\n", 19# file: mnt/foobar) = 19
write(1, "security.SMACK64=\"_\"\n", 21security.SMACK64="_") = 21
getxattr("mnt/foobar", "security.ima", 0x0, 0) = -1 ENODATA (No data available)
write(2, "mnt/foobar: ", 12mnt/foobar: ) = 12
write(2, "security.ima: No such attribute\n", 32security.ima: No such attribute) = 32= 32

so the attribute is there but the kernel gives ENODATA when trying
to read it.

http://www.nongnu.org/ext2-doc/ext2.html#CONTRIB-EXTENDED-ATTRIBUTES co
ntains the small snippet that " The entry descriptors are sorted by
attribute name, so that two extended attribute blocks can be compared
efficiently. ". It doesn't specify what kind of sort.

Looking at ext2fs, there is some sorting code through the qsort call
using attr_compare() but it doesn't match what the kernel is doing in
 ext4_xattr_find_entry().

I put together this quick patch to test my theory that this causing the
problem:

Index: git/lib/ext2fs/ext_attr.c
===================================================================
--- git.orig/lib/ext2fs/ext_attr.c
+++ git/lib/ext2fs/ext_attr.c
@@ -258,6 +258,7 @@ static struct ea_name_index ea_names[] =
 static int attr_compare(const void *a, const void *b)
 {
 	const struct ext2_xattr *xa = a, *xb = b;
+	size_t len;
 
 	if (xa->name == NULL)
 		return +1;
@@ -267,7 +268,11 @@ static int attr_compare(const void *a, c
 		return -1;
 	else if (!strcmp(xb->name, "system.data"))
 		return +1;
-	return 0;
+	len = strlen(xa->name) - strlen(xb->name);
+	if (len)
+		return len;
+
+	return strcmp(xa->name, xb->name);
 }
 
 static const char *find_ea_prefix(int index)

This makes my filesystems work.

Is this a bug? I'm assuming ext2fs shouldn't generate filesystems the
kernel can't read? Is the above the correct fix?

Cheers,

Richard
