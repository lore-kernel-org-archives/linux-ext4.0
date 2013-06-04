From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on delalloc
Date: Tue, 04 Jun 2013 09:26:28 -0500
Message-ID: <51ADF914.6070209@redhat.com>
References: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?5a6L5p+P57+w?= <solarispika@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab3FDO0a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 10:26:30 -0400
In-Reply-To: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/3/13 2:00 PM, =E5=AE=8B=E6=9F=8F=E7=BF=B0 wrote:
> Hi everybody,
>=20
> I am new to ext4 and doing research on Android with ext4 as file
> system. These days, I have a question on ext4's delayed allocation
> against ext4_sync_file.
> I have learned that delalloc won't guarantee file data's integrity on
> power failure, since those delayed allocated buffer heads won't be
> handled by jbd2.

I just want to address your first assertion regarding delalloc:

> In order to protect data, user programs need to fsync
> those files to be secured.

This is true with or without delayed allocation.

With delayed allocation, the blocks are chosen a the time of the IO.
Without delayed allocation, the blocks are chosen at the write syscall =
time.

But in both cases, data is only in memory after the write(), and is not
guaranteed to be on disk until an fsync or similar data integrity sysca=
ll.

http://lwn.net/Articles/457667/

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
