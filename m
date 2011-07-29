From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [patch 1/1] ext4: use proper little-endian bitops
Date: Fri, 29 Jul 2011 15:13:21 +0300
Message-ID: <CAOQ4uxgi6wAbXhxaPCc7oaDZcccvDOeXy9vY2F4WX7Ncc4570Q@mail.gmail.com>
References: <201107282055.p6SKtKp5008047@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1107291109460.4293@dhcp-27-109.brq.redhat.com>
	<CAC5umyjxG3k2L3mozmd-Dfb08mMt1ZEZdrsAdhAjbZTkEy_OoQ@mail.gmail.com>
	<alpine.LFD.2.00.1107291341540.4293@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, Lukas Czerner <lczerner@redhat.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39248 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1G2MNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 08:13:23 -0400
Received: by wwe5 with SMTP id 5so3474275wwe.1
        for <linux-ext4@vger.kernel.org>; Fri, 29 Jul 2011 05:13:22 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1107291341540.4293@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 29, 2011 at 2:51 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Fri, 29 Jul 2011, Akinobu Mita wrote:
>
>> 2011/7/29 Lukas Czerner <lczerner@redhat.com>:
>>
>> >> diff -puN fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops fs/=
ext4/ext4.h
>> >> --- a/fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops
>> >> +++ a/fs/ext4/ext4.h
>> >> @@ -931,12 +931,13 @@ struct ext4_inode_info {
>> >> =A0#define test_opt2(sb, opt) =A0 =A0 =A0 =A0 =A0 (EXT4_SB(sb)->s=
_mount_opt2 & \
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_MOUNT2_##opt)
>> >>
>> >> -#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __test_and_=
set_bit_le
>> >> +#define ext4_test_and_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__t=
est_and_set_bit_le
>> >> +#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __set_bit_l=
e
>> >> =A0#define ext4_set_bit_atomic =A0 =A0 =A0 =A0 =A0ext2_set_bit_at=
omic
>> > We can remove this since it is not used anywhere and it is just a =
macro
>> > for test_and_set_bit_le() anyway.
>>
>> Amir Goldstein requested not to remove it because ext4 snapshot patc=
hes is
>> using ext4_set_bit_atomic(), although I really don't know about the =
status of
>> mainline inclusion.
>
> It is not anywhere near inclusion. Moreover it is using
> __test_and_set_bit_le, but the name does not really imply *test*.
> So please, just remove it and when Amir is going to
> need it someday he might add proper define with the proper name using
> the proper set, or test_and_set functions.
>

Yongqiang,

Please refresh my memory.
Are we still using those macros?
Didn't we say will need to switch to using mballoc's ext4_set_bits() in=
stead?
I think you modified the calls in some of the execution paths and not
all of them
(i.e. not in MOW), which is probably a bug.

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
