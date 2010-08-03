From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: persistent preallocation
Date: Tue, 03 Aug 2010 11:25:57 -0500
Message-ID: <4C584315.6060701@redhat.com>
References: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se> <87aap4aqrf.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?Qm8gQnJhbnTDqW4=?= <bosse@acc.umu.se>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127Ab0HCQ0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 12:26:07 -0400
In-Reply-To: <87aap4aqrf.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2010 06:18 AM, Dmitry Monakhov wrote:
> Bo Brant=C3=A9n <bosse@acc.umu.se> writes:
>=20
>> Hello,
>>
>> I have a question on the implementation of persistent preallocation,
>> the reason to not return the disk block is because it can contain ol=
d
>> data but I wonder if an implementation has to return zeros instead o=
r
> Please look at fallocate(2) syscall.
>> if it could return any garbage as long as it is not _that_ garbage?
> Off course it is not a garbage, it is old user's data which may be
> very very useful (old passwords, cookies, and etc)for person who has
> time to analyze it :)

I think the question was, could the implementation return 0xFF rather
than what is actually on disk (and rather than 0's) when reading a
preallocated block.

You could certainly write it that way, but I don't know why you would
want to...

IOW it wouldn't be posix_fallocate() or fallocate(), it'd be
junk_preallocate() or something.

-Eric

>>
>> Bo Branten
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
