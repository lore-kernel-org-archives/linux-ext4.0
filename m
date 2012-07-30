From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: add error handling when discard cmd is fail in FITRIM
Date: Mon, 30 Jul 2012 19:21:13 +0530
Message-ID: <CAOiN93=SYN9jywq62M=Xh4LOLJ=E-UfHygYJ5uW_ANJ+Fw6qtQ@mail.gmail.com>
References: <1343561514-8380-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1207301323550.23560@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57826 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2G3NvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jul 2012 09:51:15 -0400
In-Reply-To: <alpine.LFD.2.00.1207301323550.23560@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 30, 2012 at 5:01 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> On Sun, 29 Jul 2012, Namjae Jeon wrote:
>
>> Date: Sun, 29 Jul 2012 07:31:54 -0400
>> From: Namjae Jeon <linkinjeon@gmail.com>
>> To: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com,
>>     linux-ext4@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>=
,
>>     Amit Sahrawat <amit.sahrawat83@gmail.com>
>> Subject: [PATCH] ext4: add error handling when discard cmd is fail i=
n FITRIM
>>
>> Although free extents is proper not trimmed(mmc driver return error =
code
>> while sending trim command), currently FITRIM ioctl return success.
>> Add exception routine to inform user error code.
>>
>> #> ./fitrim_test
>> end_request: I/O error, dev mmcblk0, sector 27232
>> EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857:
>> Discard command returned error -5
>> #>
>
> Well, by this change you're actually reverting commit
>
> d9f34504e6952e909a6932c5b2d1857716606380
>          ext4: ignore errors when issuing discards
>
> which effectively reverts a30eec2a8.
>
> Now I think that the way it is now is actually better than your
> proposal for the reasons mentioned in the commit
> d9f34504e6952e909a6932c5b2d1857716606380. However I think that the

How about instead of propagating the error to user and breaking out of
the discard, just print a warning message like:
ext4_warning(sb, "error %d while trimming group block from %d to
%d\n",ret, start, next);

> discard errors should be logged nevertheless but not at the file
> system level, but rather on block layer level if it is not done
> already.
>
> Thanks!
> -Lukas
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
