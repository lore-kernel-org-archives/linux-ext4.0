From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix configure.in typo
Date: Tue, 20 Oct 2009 22:48:07 -0500
Message-ID: <4ADE8477.2070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZJUDsI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 23:48:08 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9L3mC70005697
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 23:48:13 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n9L3m8ad012733
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 23:48:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think vim <esc>wq turned into <esc>2wq or something; in any case
blkid_probe_get_topology2 is not the right thing to search for.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

(note; with this, once I try to build w/ a new libblkid, I still
get a mkfs build error ... it's still picking up the in-tree blkid
headers)


diff --git a/configure.in b/configure.in
index c278d83..cd2c246 100644
--- a/configure.in
+++ b/configure.in
@@ -809,7 +809,7 @@ if test -n "$BLKID_CMT"; then
   AC_SEARCH_LIBS([blkid_probe_all], [blkid])
 fi
 dnl
-AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate blkid_probe_get_topology2)
+AC_CHECK_FUNCS(chflags getrusage llseek lseek64 open64 fstat64 ftruncate64 getmntinfo strtoull strcasecmp srandom jrand48 fchown mallinfo fdatasync strnlen strptime strdup sysconf pathconf posix_memalign memalign valloc __secure_getenv prctl mmap utime setresuid setresgid usleep nanosleep getdtablesize getrlimit sync_file_range posix_fadvise fallocate blkid_probe_get_topology)
 dnl
 dnl Check to see if -lsocket is required (solaris) to make something
 dnl that uses socket() to compile; this is needed for the UUID library

