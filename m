From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 2/5] fallocate() on s390
Date: Thu, 26 Apr 2007 23:37:50 +0530
Message-ID: <20070426180750.GB7209@amitarora.in.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: torvalds@osdl.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:47453 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031401AbXDZSIA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Apr 2007 14:08:00 -0400
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch implements support of fallocate system call on s390(x)
platform. A wrapper is added to address the issue which s390 ABI has
with "preferred" ordering of arguments in this system call (i.e. int,
int, loff_t, loff_t).

I will request s390 experts to please review this code and verify if
this patch is correct. Thanks!

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 arch/s390/kernel/compat_wrapper.S |   10 ++++++++++
 arch/s390/kernel/sys_s390.c       |   10 ++++++++++
 arch/s390/kernel/syscalls.S       |    1 +
 include/asm-s390/unistd.h         |    3 ++-
 4 files changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6.21/arch/s390/kernel/compat_wrapper.S
===================================================================
--- linux-2.6.21.orig/arch/s390/kernel/compat_wrapper.S
+++ linux-2.6.21/arch/s390/kernel/compat_wrapper.S
@@ -1682,3 +1682,13 @@ compat_sys_utimes_wrapper:
 	llgtr	%r2,%r2			# char *
 	llgtr	%r3,%r3			# struct compat_timeval *
 	jg	compat_sys_utimes
+
+	.globl	s390_fallocate_wrapper
+s390_fallocate_wrapper:
+	lgfr	%r2,%r2			# int
+	sllg	%r3,%r3,32		# get high word of 64bit loff_t
+	or	%r3,%r4			# get low word of 64bit loff_t
+	sllg	%r4,%r5,32		# get high word of 64bit loff_t
+	or	%r4,%r6			# get low word of 64bit loff_t
+	llgf	%r5,164(%r15)		# unsigned int
+	jg	s390_fallocate
Index: linux-2.6.21/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6.21.orig/arch/s390/kernel/sys_s390.c
+++ linux-2.6.21/arch/s390/kernel/sys_s390.c
@@ -268,6 +268,16 @@ s390_fadvise64_64(struct fadvise64_64_ar
 }
 
 /*
+ * This is a wrapper to call sys_fallocate(). Since s390 ABI has a problem
+ * with the int, int, loff_t, loff_t ordering of arguments, this wrapper
+ * is required.
+ */
+asmlinkage long s390_fallocate(int fd, loff_t offset, loff_t len, int mode)
+{
+	return sys_fallocate(fd, mode, offset, len);
+}
+
+/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
Index: linux-2.6.21/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.21.orig/arch/s390/kernel/syscalls.S
+++ linux-2.6.21/arch/s390/kernel/syscalls.S
@@ -322,3 +322,4 @@ NI_SYSCALL							/* 310 sys_move_pages *
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
 SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
+SYSCALL(s390_fallocate,s390_fallocate,s390_fallocate_wrapper)
Index: linux-2.6.21/include/asm-s390/unistd.h
===================================================================
--- linux-2.6.21.orig/include/asm-s390/unistd.h
+++ linux-2.6.21/include/asm-s390/unistd.h
@@ -251,8 +251,9 @@
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
 #define __NR_utimes		313
+#define __NR_fallocate		314
 
-#define NR_syscalls 314
+#define NR_syscalls 315
 
 /* 
  * There are some system calls that are not present on 64 bit, some
