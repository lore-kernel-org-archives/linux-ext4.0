From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fast ext4 cleanup to avoid data loss after power failure
Date: Fri, 03 Oct 2014 10:44:05 -0500
Message-ID: <542EC445.5030503@redhat.com>
References: <542EA00B.4040401@pqgruber.com> <alpine.LFD.2.00.1410031550090.2333@localhost.localdomain> <542EC343.7090905@pqgruber.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Clemens Gruber <clemens.gruber@pqgruber.com>,
	=?windows-1252?Q?Luk=E1?= =?windows-1252?Q?=9A_Czerner?=
	<lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbaJCPoE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Oct 2014 11:44:04 -0400
In-Reply-To: <542EC343.7090905@pqgruber.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/3/14 10:39 AM, Clemens Gruber wrote:
> On 10/03/2014 04:08 PM, Luk=E1=9A Czerner wrote:
>> What exactly is the problem you're trying to solve ? Does it concern
>> specific application ?
>=20
> It's a software to control and configure dispensing equipment in a ba=
r.
> The problem is that power is lost frequently and the only warning is =
the
> mentioned GPIO about 1.5 to 2 seconds in advance, then the caps are d=
rained.
> This happens very often and I have to prevent it from damaging the
> filesystem.
>=20
> I did not mention it before, because I was not sure if it is relevant=
,
> but I am running Linux 3.17-rc7 on the board.
>=20
>> So what you expect to happen if the power failure happens in the
>> middle of the write to the eMMC ?
>=20
> With the 1.5 second delay, I'd like to stop the application, before t=
hat
> happens.
>=20
>> I'd avoid the need to deal with this at all. File system
>> (journal) itself will protect you from metadata corruption (file
>> system corruption). But the application has to protect it's own
>> important files for data consistency (data=3Djournal will not help
>> you, nor commit=3D1).
>>
>> The usual and simple way for the application to deal with this is to
>> use temporary file, fsync the changes to make sure that everything
>> hit the disk and then atomically rename the file to replace the
>> original. That way your file will always by in consistent state. It
>> will either have the new content, or the old one, not mix of both.
>=20
> Thank you, this approach sounds good! I will change the application
> accordingly.
> So the only necessary step to do when the GPIO triggers, is to quit t=
he
> applications writing to the eMMC. If I use that write, fsync, rename
> strategy, I guess I could even SIGKILL them.

http://lwn.net/Articles/457667/

is a good overview of data persistence best practices, FWIW.

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
