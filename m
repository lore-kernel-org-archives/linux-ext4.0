From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Thu, 16 Aug 2012 13:21:12 -0700
Message-ID: <CANP3RGdMfM0tZbaJS9dFetRhXoGtyS0Nx4hZER_Qv0a061X_dQ@mail.gmail.com>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Theodore Ts'o" <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65208 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362Ab2HPUVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 16:21:13 -0400
Received: by qaas11 with SMTP id s11so960278qaa.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 13:21:13 -0700 (PDT)
In-Reply-To: <20120816152513.GA31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This would probably be much more readable code if the 'i=3D0' init was
before path=3Dkzalloc.

On Thu, Aug 16, 2012 at 8:25 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 16, 2012 at 07:10:51PM +0800, Fengguang Wu wrote:
>>
>> Here is the dmesg. BTW, it seems 3.5.0 don't have this issue.
>
> Fengguang,
>
> It sounds like you have a (at least fairly) reliable reproduction for
> this problem?  Is it something you can share?  It would be good to ge=
t
> this into our test suites, since it was _not_ something that was
> caught by xfstests, apparently.
>
> Can you see if this patch addresses it?  (The first two patch hunks
> are the same debugging additions I had posted before.)
>
> It looks like the responsible commit is 968dee7722: "ext4: fix hole
> punch failure when depth is greater than 0".  I had thought this patc=
h
> was low risk if you weren't using the new punch ioctl, but it turns
> out it did make a critical change in the non-punch (i.e., truncate)
> code path, which is what the addition of "i =3D 0;" in the patch belo=
w
> addresses.
>
> Regards,
>
>                                           - Ted
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 769151d..fa829dc 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2432,6 +2432,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inod=
e *inode,
>
>         /* the header must be checked already in ext4_ext_remove_spac=
e() */
>         ext_debug("truncate since %u in leaf to %u\n", start, end);
> +       if (!path[depth].p_hdr && !path[depth].p_bh) {
> +               EXT4_ERROR_INODE(inode, "depth %d", depth);
> +               BUG_ON(1);
> +       }
>         if (!path[depth].p_hdr)
>                 path[depth].p_hdr =3D ext_block_hdr(path[depth].p_bh)=
;
>         eh =3D path[depth].p_hdr;
> @@ -2730,6 +2734,10 @@ cont:
>                 /* this is index block */
>                 if (!path[i].p_hdr) {
>                         ext_debug("initialize header\n");
> +                       if (!path[i].p_hdr && !path[i].p_bh) {
> +                               EXT4_ERROR_INODE(inode, "i=3D%d", i);
> +                               BUG_ON(1);
> +                       }
>                         path[i].p_hdr =3D ext_block_hdr(path[i].p_bh)=
;
>                 }
>
> @@ -2828,6 +2836,7 @@ out:
>         kfree(path);
>         if (err =3D=3D -EAGAIN) {
>                 path =3D NULL;
> +               i =3D 0;
>                 goto again;
>         }
>         ext4_journal_stop(handle);



--=20
Maciej A. =C5=BBenczykowski
Kernel Networking Developer @ Google
1600 Amphitheatre Parkway, Mountain View, CA 94043
tel: +1 (650) 253-0062
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
