From: Clemens Gruber <clemens.gruber@pqgruber.com>
Subject: Re: Fast ext4 cleanup to avoid data loss after power failure
Date: Fri, 03 Oct 2014 17:39:47 +0200
Message-ID: <542EC343.7090905@pqgruber.com>
References: <542EA00B.4040401@pqgruber.com> <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.pqgruber.com ([178.189.19.235]:34968 "EHLO
	mail.pqgruber.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaJCPlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2014 11:41:40 -0400
In-Reply-To: <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/03/2014 04:08 PM, Luk=E1=9A Czerner wrote:
> What exactly is the problem you're trying to solve ? Does it concern
> specific application ?

It's a software to control and configure dispensing equipment in a bar.
The problem is that power is lost frequently and the only warning is th=
e
mentioned GPIO about 1.5 to 2 seconds in advance, then the caps are dra=
ined.
This happens very often and I have to prevent it from damaging the
filesystem.

I did not mention it before, because I was not sure if it is relevant,
but I am running Linux 3.17-rc7 on the board.

> So what you expect to happen if the power failure happens in the
> middle of the write to the eMMC ?

With the 1.5 second delay, I'd like to stop the application, before tha=
t
happens.

> I'd avoid the need to deal with this at all. File system
> (journal) itself will protect you from metadata corruption (file
> system corruption). But the application has to protect it's own
> important files for data consistency (data=3Djournal will not help
> you, nor commit=3D1).
>=20
> The usual and simple way for the application to deal with this is to
> use temporary file, fsync the changes to make sure that everything
> hit the disk and then atomically rename the file to replace the
> original. That way your file will always by in consistent state. It
> will either have the new content, or the old one, not mix of both.

Thank you, this approach sounds good! I will change the application
accordingly.
So the only necessary step to do when the GPIO triggers, is to quit the
applications writing to the eMMC. If I use that write, fsync, rename
strategy, I guess I could even SIGKILL them.

And you would keep the default values for the commit and data flag,
because fsync flushes the buffers for data and metadata anyway?

=46orcing fsck for the next boot, when I detect that a power-failure is
imminent, is also not necessary, right?

>=20
>>
>> Maybe a read-only rootfs and a separate small data partition?
>=20
> Well, if you do not need to write to the rootfs why you need to deal
> with data corruption ?

At the moment, my root filesystem is writable. I would need to change a
lot, so I'd rather find a solution to keep it writable and avoid
corruption / ensure durability.

Regards,
Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
