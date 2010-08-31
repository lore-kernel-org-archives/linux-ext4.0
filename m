From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [RFC][PATCH] make file's timestamp more accurate
Date: Tue, 31 Aug 2010 17:42:50 +0900
Message-ID: <4C7CC08A.9010302__2378.83800077743$1283244244$gmane$org@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Jiri Olsa <jolsa@redhat.com>,
	John Stultz <johnstul@us.ibm.com>, "Ted Ts'o" <tytso@mit.edu>,
	Thomas Gleixner <
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0HaInj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Aug 2010 04:43:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

linux has supported nanosecond order file's timestamp since 2.5.48.
However current file timestamp is got by current_fs_time() and
is only updated once a tick. It can't say true nanosecond accuracy.
In addition, gettimeofday() before a file operation updating
{a,c,m}time would outstrip file's timestamp because of the difference
about time source between gettimeofday() and file's timestamp.
A certain kind of application would corrupted by this problem.

I attached a most simple patch fixing this problem here. However
it has several problems and I don't say it can be applied as is.
The most big two problems is the following:

 - It would cause performance regression, especially in
   not TSC capable system.
 - Is gettimeofday()'s monotonicity reliable on all systems?

The relative discussion:
http://lkml.org/lkml/2010/7/13/443

Does anybody have good idea? Should it be tunable, for example?

Thanks,
Satoru

Index: linux-2.6.36-rc3/kernel/time.c
===================================================================
--- linux-2.6.36-rc3.orig/kernel/time.c 2010-08-31 16:07:43.000000000 +0900
+++ linux-2.6.36-rc3/kernel/time.c      2010-08-31 16:08:11.000000000 +0900
@@ -227,7 +227,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex _
  */
 struct timespec current_fs_time(struct super_block *sb)
 {
-       struct timespec now = current_kernel_time();
+       struct timespec now;
+       getnstimeofday(&now);
        return timespec_trunc(now, sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_fs_time);

