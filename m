From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: How can I do online resize from 14TB to 30TB?
Date: Tue, 9 Nov 2010 14:12:00 -0800
Message-ID: <AANLkTik7KFn1eU2o5sRm3CM1jmoWszKGzDXMpUyjQec6@mail.gmail.com>
References: <855286.34705.qm@web74212.mail.tp2.yahoo.com>
	<A09A0FD5-97DA-494A-B248-CFBC1AF7DBE4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42904 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0KIWMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 17:12:03 -0500
Received: by ywc21 with SMTP id 21so4757689ywc.19
        for <linux-ext4@vger.kernel.org>; Tue, 09 Nov 2010 14:12:01 -0800 (PST)
In-Reply-To: <A09A0FD5-97DA-494A-B248-CFBC1AF7DBE4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/11/9 Andreas Dilger <adilger.kernel@dilger.ca>:
> On 2010-11-09, at 03:06, =E5=AF=AC wrote:
>> I saw the mail "E2fsprogs master branch now has all 64-bit patch app=
lied" written by Ted. =C2=A0Ext4 with 64bit couldn't do online resize w=
hich is larger than 16TB, because "meta_bg" in kernel is not ready.
>>
>> However, it really took lots of time to do off-line resizing. =C2=A0=
Could I do online resize without meta_bg? =C2=A0Or what can I do for e2=
fsprogs to support online resize for larger than 16TB?
>
> For the current time there will be no support for resizing a filesyst=
em formatted < 16TB to one > 16TB.
>

On a related topic, currently 4KB-block ext4 filesystems with the
64bit flag set apparently can only expand online by a max increase of
8TB (16TB without 64bit), even if you specify a larger value with -E
resize=3DXXX.  Are there any plans to improve this?

Thanks,
-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
