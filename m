From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Fri, 7 Jan 2011 22:39:15 +0200
Message-ID: <AANLkTinCBARv6_SjBd5+zCjnTZXg9ggnt+YZyHP3BkQB@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
	<AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
	<4D1F6244.7050203@redhat.com>
	<AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
	<20110107052834.GF2857@thunk.org>
	<AANLkTi=tKCZHPSWj1CiA+o1dw9T_6df=9CXyXVA1Xsh4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49724 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AGUjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 15:39:15 -0500
Received: by qyk12 with SMTP id 12so20132535qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jan 2011 12:39:15 -0800 (PST)
In-Reply-To: <AANLkTi=tKCZHPSWj1CiA+o1dw9T_6df=9CXyXVA1Xsh4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 7, 2011 at 9:43 PM, Amir Goldstein <amir73il@gmail.com> wro=
te:
> On Fri, Jan 7, 2011 at 7:28 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> Also, the kernel patch seems to write the messages in 256-byte
>> records, whereas the e2fsck patch assumes the messages are packed
>> together in null-terminated packed lines....

I checked again. e2fsck patch DOES read messages in 256-byte records:
+static void e2fsck_print_message_buffer(e2fsck_t ctx)
=2E..
+#define MSGLEN 256
=2E..
+		fputs(buf+offset, stdout);
+		offset +=3D MSGLEN;

>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>
>
> I guess that is the reason I always see only the first message on fsc=
k :-)
> It was always enough information for me though...
> feel free to amend to e2fsck patch to match the kernel side.
>
> Thanks,
> Amir.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
