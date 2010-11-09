From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] Self healing extent map OR opportunistic de-fragmentation
Date: Tue, 9 Nov 2010 11:35:07 +0200
Message-ID: <AANLkTi=n5HtRQY2VR9Kz7tyZQ7=PW77Ar8gj40F1aXB_@mail.gmail.com>
References: <AANLkTinsZRSU46J0JXm2A=u=d-JpQfdYnk0oHf3NC9O_@mail.gmail.com>
	<25081AB5-124D-4E29-AB89-94A05F0106D1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51145 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab0KIJfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 04:35:08 -0500
Received: by gwj21 with SMTP id 21so4068932gwj.19
        for <linux-ext4@vger.kernel.org>; Tue, 09 Nov 2010 01:35:08 -0800 (PST)
In-Reply-To: <25081AB5-124D-4E29-AB89-94A05F0106D1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 9, 2010 at 10:58 AM, Andreas Dilger
<adilger.kernel@dilger.ca> wrote:
> On 2010-11-08, at 21:14, Amir Goldstein wrote:
>> I would like to propose a simple idea how to automatically de-fragme=
nt a file.
>
> [snip]
>
>> The use case for this, besides healing fragmentation caused by
>> snapshots move-on-rewrite, is an highly fragmented ext2/3 fs, which =
was mounted as ext4.
>> ext2/3 old files are slowly being deleted while new (still fragmente=
d) extent mapped files are being created.
>> This viscous cycle cannot end before there is enough contiguous free
>> space for writing new files, which may never happen.
>
> This will only happen in case the free space is _very_ low. =A0Normal=
ly, in a situation like this, mballoc will allocate the
> largest contiguous chunks of free space, reducing the fragmentation a=
s new files are written, and allocations to
> highly-fragmented block groups will be avoided until the chunks in th=
ose groups have grown larger.
>
>> Online de-fragmentation will not help in this case either.
>> With opportunistic de-fragmentation, if the extent mapped files are
>> being re-written, the health of the file system will constantly impr=
ove over time.
>> BTW, Is this use case relevant for upgraded google chunk servers?
>
> While this is true in theory, the problem is that in most cases files=
 are not overwritten in place.
> Commonly, when files are "rewritten" they are truncated and new block=
s allocated, or a new file is written and renamed in place of the old f=
ile.
> Only in rare cases, like databases, are files rewritten in-place.
>

Oh, I know that. Which is why it is a bit annoying to invest a lot of
effort to solve the fragmentation caused by snapshot move-on-rewrite.
In those rare use cases, the file may end up like a swiss cheese after
a while. However, I realized that the access pattern of those
applications
in not all that random. A rewrite to offset X has a high likelihood to
repeat more than once (update to DB record or write of metadata block
in virtual disk).
I figured I could use the opportunity of the subsequent rewrites to
restore the file blocks to their original location, without paying a
performance trade-off.

The question is, are there other use cases out there that can benefit
from opportunistic de-fragmentation?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
