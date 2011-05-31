From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Tue, 31 May 2011 12:45:15 +0900
Message-ID: <BANLkTin64T9-QEdE6DC6VoB=7d6m0qFcuQ@mail.gmail.com>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
	<09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
	<20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
	<BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
	<7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36687 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1EaDpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 23:45:16 -0400
In-Reply-To: <7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/5/31 Andreas Dilger <adilger@dilger.ca>:

> Looking more closely at these operations, ext4_set_bit_atomic() is no=
t used anywhere in the code and could be removed.
>
> There is only one place where ext4_clear_bit_atomic() is used (ext4_a=
dd_groupblocks()), and this is likely incorrect. =A0None of the other e=
xt4 code is using ext4_set_bit_atomic(), and all of the ext2_clear_bit_=
atomic() macros are silently ignoring the "lock" argument, so these cha=
nges are done without ext4_group_lock() being held for that group. =A0I=
 suspect this is never a problem in normal usage because ext4_add_group=
blocks() is only used during filesystem resizing, which is rare, and do=
ubly rare for any allocations to be made in the same group concurrently=
=2E
>
> This one usage of ext4_clear_bit_atomic() should just be moved inside=
 the ext4_lock_group() a few lines down and then use ext4_clear_bit() f=
or consistency, and ext4_clear_bit_atomic() can be removed entirely.
>
> A further cleanup would be to change this whole function to use mb_cl=
ear_bits(), which is not only faster because it operates on many bits a=
t once, but also doesn't require that the buddy bitmap be marked invali=
d ("NEED_INIT") after these changes are made, but that is work for a se=
parate patch.

Looks like this is already done by the commit
e73a347b7723757bb5fb5c502814dc205a7f496d ("ext4: implement
ext4_add_groupblocks() by freeing blocks")

So we can remove ext4_{set,clear}_bit_atomic now.

> I would also encourage you to finish off this patch series by pushing=
 up the generic ext2_{set,clear}_bit_atomic() to the few places that ar=
e currently using ext2_{set,clear}_bit_atomic() directly (looks like on=
ly fs/nilfs2/alloc.h and include/linux/ext3.h) and then removing them f=
rom the arch headers.

The difficulty of doing this is that there are two different
implementations of ext2_{set,clear}_bit_atomic (spin lock version and
test_and_{set,clear}_bit_le version).  If we can switch to one of which
on all architectures, the change is easy.  But I don't have less messy =
idea
to keep current behavior on all architectures.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
