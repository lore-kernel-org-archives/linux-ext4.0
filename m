From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] mke2fs: do not initialize block bitmaps of groups having
 super block
Date: Thu, 10 Nov 2011 10:07:50 +0800
Message-ID: <CAGBYx2Yk=yw9vjZ-015ow3Jw-bchV=1WEXj6wPAKwNRF+PYTwQ@mail.gmail.com>
References: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com>
	<D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
	<D7569AD1-FA75-44A4-BA8E-D47E96E75696@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58527 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1KJCjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 21:39:03 -0500
Received: by qao25 with SMTP id 25so2138050qao.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 18:39:03 -0800 (PST)
In-Reply-To: <D7569AD1-FA75-44A4-BA8E-D47E96E75696@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 4:34 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Nov 9, 2011, at 11:23 AM, Andreas Dilger wrote:
>
>> On 2011-11-09, at 3:53 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wr=
ote:
>>
>>> Now mke2fs initializes block bitmaps of groups having super block, =
on
>>> the other hand ext4_init_block_bitmap in kernel can handle this cas=
e
>>> rightly. =A0So let mke2fs let block bitmaps of groups having super =
block
>>> be uninitialized.
>>
>> Is that true of older kernels, or only newer ones? =A0What about fil=
esystems with META_BG set?
>
> More to the point, what about file systems that don't have uninit_bg =
set?
mke2fs does not set BLOCK_UNINIT flag for file systems which do not
have uninit_bg set from the beginning.


>
> What's the reason for wanting to make this change?
The different handling to some groups let readers think that we have
to handle these groups this way, otherwise errors will happen.
Actually, no error will happen.   IMHO this can make both logic and
code much clearer.

Yongqiang.
>
> -- Ted
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
