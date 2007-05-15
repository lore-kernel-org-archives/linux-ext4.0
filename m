From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/5][TAKE3] fallocate system call
Date: Tue, 15 May 2007 16:52:23 -0700
Message-ID: <1179273143.4819.15.camel@dyn9047017103.beaverton.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	 <20070329115126.GB7374@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58407 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbXEOXwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 19:52:38 -0400
In-Reply-To: <20070515193722.GA3487@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-16 at 01:07 +0530, Amit K. Arora wrote:

> ToDos:
> -----
> 1> Implementation on other architectures (other than i386, x86_64,
> ppc64 and s390(x)). David Chinner has already posted a patch for ia64.

Here is the 2.6.22-rc1 version of David's patch: add fallocate() on ia64

From: David Chinner <dgc@sgi.com>
Subject: [PATCH] ia64 fallocate syscall
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, 
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        suparna@in.ibm.com, cmm@us.ibm.com

ia64 fallocate syscall support.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 arch/ia64/kernel/entry.S  |    1 +
 include/asm-ia64/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc1/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6.22-rc1.orig/arch/ia64/kernel/entry.S	2007-05-12 18:45:56.000000000 -0700
+++ linux-2.6.22-rc1/arch/ia64/kernel/entry.S	2007-05-15 15:36:48.000000000 -0700
@@ -1585,5 +1585,6 @@
 	data8 sys_getcpu
 	data8 sys_epoll_pwait			// 1305
 	data8 sys_utimensat
+	data8 sys_fallocate
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
Index: linux-2.6.22-rc1/include/asm-ia64/unistd.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-ia64/unistd.h	2007-05-12 18:45:56.000000000 -0700
+++ linux-2.6.22-rc1/include/asm-ia64/unistd.h	2007-05-15 15:37:51.000000000 -0700
@@ -296,6 +296,7 @@
 #define __NR_getcpu			1304
 #define __NR_epoll_pwait		1305
 #define __NR_utimensat			1306
+#define __NR_fallocate			1307
 
 #ifdef __KERNEL__
 
