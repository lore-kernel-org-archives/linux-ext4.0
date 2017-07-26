From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Remove useless test and initialisation in name to hash
 computation
Date: Wed, 26 Jul 2017 13:42:28 +0200
Message-ID: <20170726114228.v3uow2jpklazxton@rh_laptop>
References: <59779083.7000501@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbdGZLmb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Jul 2017 07:42:31 -0400
Content-Disposition: inline
In-Reply-To: <59779083.7000501@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 25, 2017 at 08:40:03PM +0200, Damien Guibouret wrote:
> Hello,
> 
> I think there is a minor improvment that could be performed on name to hash
> computation in hash.c. Before first byte modulo 4 the computed value is
> reinitialised, but it is already correctly initialised before loop and after
> having processed last byte modulo 4. So the test and initialisation seems
> useless.
> 
> For the kernel, this lead to following change (sorry I do not have a git
> version of it, so it is a simple diff):
> ---------------------------------------------------------------
> --- fs/ext4/hash.c.orig 2017-07-24 20:41:53.000000000 +0200
> +++ fs/ext4/hash.c      2017-07-24 20:42:23.000000000 +0200
> @@ -79,8 +79,6 @@ static void str2hashbuf_signed(const cha
>         if (len > num*4)
>                 len = num * 4;
>         for (i = 0; i < len; i++) {
> -               if ((i % 4) == 0)
> -                       val = pad;
>                 val = ((int) scp[i]) + (val << 8);
>                 if ((i % 4) == 3) {
>                         *buf++ = val;
> @@ -107,8 +105,6 @@ static void str2hashbuf_unsigned(const c
>         if (len > num*4)
>                 len = num * 4;
>         for (i = 0; i < len; i++) {
> -               if ((i % 4) == 0)
> -                       val = pad;
>                 val = ((int) ucp[i]) + (val << 8);
>                 if ((i % 4) == 3) {
>                         *buf++ = val;
> ---------------------------------------------------------------
> 
> For e2fsprogs, the 2 functions are combined in one, so there is only one change:
> ---------------------------------------------------------------
> diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
> index c4ac94e..4ba3f35 100644
> --- a/lib/ext2fs/dirhash.c
> +++ b/lib/ext2fs/dirhash.c
> @@ -154,8 +154,6 @@ static void str2hashbuf(const char *msg, int len, __u32
> *buf, int num,
>      if (len > num*4)
>          len = num * 4;
>      for (i=0; i < len; i++) {
> -        if ((i % 4) == 0)
> -            val = pad;
>          if (unsigned_flag)
>              c = (int) ucp[i];
>          else
> ---------------------------------------------------------------

Hi Damien,

the change looks ok to me, have you done any testing to quantify the
improvement, or validate the change ?

>From my limited testing the improvement seems to be around 11% for me
which would be nice to have. Also my test on 466k strings looks ok
as well.

Are you willing to send out properly formated patch for kernel and
e2fsprogs ?

Thanks!
-Lukas

> 
> Regards,
> 
> Damien
