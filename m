From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: Remove useless test and initialisation in name to hash computation
Date: Wed, 26 Jul 2017 21:56:18 +0200
Message-ID: <5978F3E2.50906@partition-saving.com>
References: <59779083.7000501@partition-saving.com> <20170726114228.v3uow2jpklazxton@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:11620 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbdGZTwV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Jul 2017 15:52:21 -0400
In-Reply-To: <20170726114228.v3uow2jpklazxton@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner wrote:
> On Tue, Jul 25, 2017 at 08:40:03PM +0200, Damien Guibouret wrote:
> 
>>Hello,
>>
>>I think there is a minor improvment that could be performed on name to hash
>>computation in hash.c. Before first byte modulo 4 the computed value is
>>reinitialised, but it is already correctly initialised before loop and after
>>having processed last byte modulo 4. So the test and initialisation seems
>>useless.
>>
>>For the kernel, this lead to following change (sorry I do not have a git
>>version of it, so it is a simple diff):
>>---------------------------------------------------------------
>>--- fs/ext4/hash.c.orig 2017-07-24 20:41:53.000000000 +0200
>>+++ fs/ext4/hash.c      2017-07-24 20:42:23.000000000 +0200
>>@@ -79,8 +79,6 @@ static void str2hashbuf_signed(const cha
>>        if (len > num*4)
>>                len = num * 4;
>>        for (i = 0; i < len; i++) {
>>-               if ((i % 4) == 0)
>>-                       val = pad;
>>                val = ((int) scp[i]) + (val << 8);
>>                if ((i % 4) == 3) {
>>                        *buf++ = val;
>>@@ -107,8 +105,6 @@ static void str2hashbuf_unsigned(const c
>>        if (len > num*4)
>>                len = num * 4;
>>        for (i = 0; i < len; i++) {
>>-               if ((i % 4) == 0)
>>-                       val = pad;
>>                val = ((int) ucp[i]) + (val << 8);
>>                if ((i % 4) == 3) {
>>                        *buf++ = val;
>>---------------------------------------------------------------
>>
>>For e2fsprogs, the 2 functions are combined in one, so there is only one change:
>>---------------------------------------------------------------
>>diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
>>index c4ac94e..4ba3f35 100644
>>--- a/lib/ext2fs/dirhash.c
>>+++ b/lib/ext2fs/dirhash.c
>>@@ -154,8 +154,6 @@ static void str2hashbuf(const char *msg, int len, __u32
>>*buf, int num,
>>     if (len > num*4)
>>         len = num * 4;
>>     for (i=0; i < len; i++) {
>>-        if ((i % 4) == 0)
>>-            val = pad;
>>         if (unsigned_flag)
>>             c = (int) ucp[i];
>>         else
>>---------------------------------------------------------------
> 
> 
> Hi Damien,
> 
> the change looks ok to me, have you done any testing to quantify the
> improvement, or validate the change ?
> 
>>From my limited testing the improvement seems to be around 11% for me
> which would be nice to have. Also my test on 466k strings looks ok
> as well.
> 
> Are you willing to send out properly formated patch for kernel and
> e2fsprogs ?
> 
> Thanks!
> -Lukas
> 
> 
>>Regards,
>>
>>Damien
> 
> 
Hello,

I just called old and new versions of functions with two different inputs (one 
multiple of 4 and one not) and check results were equals, nothing more. So not 
very formal, just a quick check but that allows covering all the code of these 
functions. For timing measurement I did nothing.
I will see to prepare a more official patch this week-end.

Regards,

Damien
