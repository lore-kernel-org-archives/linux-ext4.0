From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [patch 1/1] ext4: use proper little-endian bitops
Date: Fri, 29 Jul 2011 19:55:12 +0900
Message-ID: <CAC5umyjxG3k2L3mozmd-Dfb08mMt1ZEZdrsAdhAjbZTkEy_OoQ@mail.gmail.com>
References: <201107282055.p6SKtKp5008047@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1107291109460.4293@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>, amir73il@gmail.com,
	xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61418 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab1G2KzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 06:55:13 -0400
Received: by vws1 with SMTP id 1so2849652vws.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Jul 2011 03:55:12 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1107291109460.4293@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/7/29 Lukas Czerner <lczerner@redhat.com>:

>> diff -puN fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops fs/ext=
4/ext4.h
>> --- a/fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops
>> +++ a/fs/ext4/ext4.h
>> @@ -931,12 +931,13 @@ struct ext4_inode_info {
>> =A0#define test_opt2(sb, opt) =A0 =A0 =A0 =A0 =A0 (EXT4_SB(sb)->s_mo=
unt_opt2 & \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0EXT4_MOUNT2_##opt)
>>
>> -#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __test_and_set=
_bit_le
>> +#define ext4_test_and_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__test=
_and_set_bit_le
>> +#define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __set_bit_le
>> =A0#define ext4_set_bit_atomic =A0 =A0 =A0 =A0 =A0ext2_set_bit_atomi=
c
> We can remove this since it is not used anywhere and it is just a mac=
ro
> for test_and_set_bit_le() anyway.

Amir Goldstein requested not to remove it because ext4 snapshot patches=
 is
using ext4_set_bit_atomic(), although I really don't know about the sta=
tus of
mainline inclusion.

> Other than that it looks good. You can add my
>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
