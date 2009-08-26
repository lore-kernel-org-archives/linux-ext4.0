From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 20:12:53 -0400
Message-ID: <4A947E05.8070406@redhat.com>
References: <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbZHZANm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 20:13:42 -0400
In-Reply-To: <20090826000657.GK4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 08:06 PM, Pavel Machek wrote:
> On Tue 2009-08-25 19:48:09, Ric Wheeler wrote:
>>
>>> ---
>>> There are storage devices that high highly undesirable properties
>>> when they are disconnected or suffer power failures while writes are
>>> in progress; such devices include flash devices and MD RAID 4/5/6
>>> arrays.  These devices have the property of potentially
>>> corrupting blocks being written at the time of the power failure, and
>>> worse yet, amplifying the region where blocks are corrupted such that
>>> additional sectors are also damaged during the power failure.
>>
>> I would strike the entire mention of MD devices since it is your
>> assertion, not a proven fact. You will cause more data loss from common
>
> That actually is a fact. That's how MD RAID 5 is designed. And btw
> those are originaly Ted's words.
>

Ted did not design MD RAID5.

>> events (single sector errors, complete drive failure) by steering people
>> away from more reliable storage configurations because of a really rare
>> edge case (power failure during split write to two raid members while
>> doing a RAID rebuild).
>
> I'm not sure what's rare about power failures. Unlike single sector
> errors, my machine actually has a button that produces exactly that
> event. Running degraded raid5 arrays for extended periods may be
> slightly unusual configuration, but I suspect people should just do
> that for testing. (And from the discussion, people seem to think that
> degraded raid5 is equivalent to raid0).

Power failures after a full drive failure with a split write during a rebuild?

>
>>> Otherwise, file systems placed on these devices can suffer silent data
>>> and file system corruption.  An forced use of fsck may detect metadata
>>> corruption resulting in file system corruption, but will not suffice
>>> to detect data corruption.
>>>
>>
>> This is very misleading. All storage "can" have silent data loss, you are
>> making a statement without specifics about frequency.
>
> substitute with "can (by design)"?

By Pavel's unproven casual observation?

>
> Now, if you can suggest useful version of that document meeting your
> criteria?
>
> 								Pavel

