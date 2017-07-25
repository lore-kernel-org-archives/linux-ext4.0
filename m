From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Remove useless test and initialisation in name to hash computation
Date: Tue, 25 Jul 2017 20:40:03 +0200
Message-ID: <59779083.7000501@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:24968 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbdGYSgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Jul 2017 14:36:07 -0400
Received: from [192.168.103.118] (unknown [82.230.26.21])
        by smtp4-g21.free.fr (Postfix) with ESMTP id BF89219F58A
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jul 2017 20:36:05 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I think there is a minor improvment that could be performed on name to hash 
computation in hash.c. Before first byte modulo 4 the computed value is 
reinitialised, but it is already correctly initialised before loop and after 
having processed last byte modulo 4. So the test and initialisation seems useless.

For the kernel, this lead to following change (sorry I do not have a git version 
of it, so it is a simple diff):
---------------------------------------------------------------
--- fs/ext4/hash.c.orig 2017-07-24 20:41:53.000000000 +0200
+++ fs/ext4/hash.c      2017-07-24 20:42:23.000000000 +0200
@@ -79,8 +79,6 @@ static void str2hashbuf_signed(const cha
         if (len > num*4)
                 len = num * 4;
         for (i = 0; i < len; i++) {
-               if ((i % 4) == 0)
-                       val = pad;
                 val = ((int) scp[i]) + (val << 8);
                 if ((i % 4) == 3) {
                         *buf++ = val;
@@ -107,8 +105,6 @@ static void str2hashbuf_unsigned(const c
         if (len > num*4)
                 len = num * 4;
         for (i = 0; i < len; i++) {
-               if ((i % 4) == 0)
-                       val = pad;
                 val = ((int) ucp[i]) + (val << 8);
                 if ((i % 4) == 3) {
                         *buf++ = val;
---------------------------------------------------------------

For e2fsprogs, the 2 functions are combined in one, so there is only one change:
---------------------------------------------------------------
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index c4ac94e..4ba3f35 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -154,8 +154,6 @@ static void str2hashbuf(const char *msg, int len, __u32 
*buf, int num,
      if (len > num*4)
          len = num * 4;
      for (i=0; i < len; i++) {
-        if ((i % 4) == 0)
-            val = pad;
          if (unsigned_flag)
              c = (int) ucp[i];
          else
---------------------------------------------------------------

Regards,

Damien
