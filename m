From: jim owens <jowens@hp.com>
Subject: Re: Data integrity built into the storage stack
Date: Tue, 01 Sep 2009 09:18:07 -0400
Message-ID: <4A9D1F0F.9050802@hp.com>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com> <yq1hbvntf62.fsf@sermon.lab.mkp.net> <20090901124403.GC1371@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21691 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZIANSH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 09:18:07 -0400
In-Reply-To: <20090901124403.GC1371@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Machek wrote:
> Hi!
> 
>> I do agree that we do have to be more prepared for collateral damage
>> scenarios.  As we discussed at LS we have 4KB drives coming out that can
>> invalidate previously acknowledged I/Os if it gets a subsequent write
>> failure on a sector.  And there's also the issue of fractured writes
> 
> Hmmm, future will be interesting.
> 
> 'ext3 expects disks to behave like disks from 1995' (alarming).

NO... stop saying "ext3".  All file systems expect that
what the disk tell us is the "sector size" (now know by
disk vendors as "block size") is "atomic".

The problem is not when they say 4096 bytes is my block.

The problem Martin is talking about is that since most
filesystems expect and work with legacy 512-byte-sectors,
the disk vendors report "512 is my block" and do the
merge themselves to their real 4096 byte physical sector.

This is not "bad drive vendor" either, it is the price
of progress while supporting legacy expectations.

jim
