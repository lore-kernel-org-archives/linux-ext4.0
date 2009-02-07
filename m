From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to recover a damaged ext4 file system?
Date: Sat, 07 Feb 2009 13:04:06 -0600
Message-ID: <498DDB26.3080102@redhat.com>
References: <20090105135347.GA3337@localdomain> <20090106120527.GT3932@webber.adilger.int> <20090106193404.GA18957@mit.edu> <20090207162725.GA27086@moongate.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Christian Ohm <chr.ohm@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZBGTEe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Feb 2009 14:04:34 -0500
In-Reply-To: <20090207162725.GA27086@moongate.localnet>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Ohm wrote:
> On Tuesday,  6 January 2009 at 14:34, Theodore Tso wrote:
>> It looks like both the primary and the backup block group descriptors
>> are bad.  I'm not sure how this happened; normally nothing touches the
>> backup block superblocks at all.  Stupid question --- are you sure the
>> partition table is sane; that's always the first thing to check.
> 
> I created a new partition on the second drive, and I hope I used exactly the
> same options. The result of fdisk -l is the following:
> 
> corrupted drive:
> 
> Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0xaaaaaaaa
> 
>    Device Boot      Start         End      Blocks   Id  System
>    /dev/sde1               1      121601   976760032   83  Linux
> 
> new partition on similar drive:
> 
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0xaaaaaaaa
> 
>    Device Boot      Start         End      Blocks   Id  System
>    /dev/sdb1               1      121601   976760001   83  Linux
> 
> The only difference is the number of blocks of the partition, I guess since the
> start and end are the same this should be equal as well.

that's counting "cylinders" - try "fdisk -u" to be able to display (or
specify) geometry in sectors, which is not a unit open to interpretation...

-Eric

