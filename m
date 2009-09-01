From: "George Spelvin" <linux@horizon.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: 31 Aug 2009 20:56:29 -0400
Message-ID: <20090901005629.3932.qmail@science.horizon.com>
References: <alpine.DEB.2.00.0908310844230.6822@asgard.lang.hm>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@horizon.com
To: david@lang.hm, pavel@ucw.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:28981 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752581AbZIAA43 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 20:56:29 -0400
In-Reply-To: <alpine.DEB.2.00.0908310844230.6822@asgard.lang.hm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From david@lang.hm Mon Aug 31 15:46:19 2009
Date: Mon, 31 Aug 2009 08:45:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: George Spelvin <linux@horizon.com>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
In-Reply-To: <20090831105645.GD1353@ucw.cz>
References: <20090831005426.13607.qmail@science.horizon.com> <20090831105645.GD1353@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

>>> That's one thing I really like about ZFS: its policy of "don't trust
>>> the disks."  If nothing else, simply telling you "your disks f*ed up,
>>> and I caught them doing it", instead of the usual mysterious corruption
>>> detected three months later, is tremendoudly useful information.
>>
>> The more I learn about storage, the more I like idea of zfs. Given the
>> subtle issues between filesystem and raid layer, integrating them just
>> makes sense.
> 
> Note that all that zfs does is tell you that you already lost data (and 
> then only if the checksumming algorithm would be invalid on a blank block 
> being returned), it doesn't protect your data.

Obviously, there are limits, but it does provide useful protection:
- You know where the missing data is.
- The error isn't amplified by believing corrupted metadata
- I seem to recall that ZFS does replicate metadata.
- Corrupted replicas can be "scrubbed" and rewritten from uncorrupted ones.
- If you have some storage redundancy, it can try different mirrors
  to get the data back.

In particular, on a RAID-5 system, ZFS tries dropping out each data disk
in turn to see if the correct data can be reconstructed from the others
+ parity.

One of ZFS's big performance problems is that currently it only checksums
the entire RAID stripe, so it always has to read every drive, and doesn't
get RAID's IOPS advantage.  But that's fairly straightforward to fix.
(It's something of a problem for RAID-5 in general, because reads want
larger chunk sizes to increase the chance that a single read can be
satisfied by one disk, while writes want small chunks so that you can
do whole-stripe writes.)

The fact that the ZFS decelopers observed drives writing the data to the
wrong location emphasizes the importance of keeping the checksum with
the pointer.  An embedded checksum, no matter how good, can't tell you if
the data is stale; you need a way to distinguish versions in the pointer.
