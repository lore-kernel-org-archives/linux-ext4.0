From: Andreas Dilger <adilger@sun.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Tue, 01 Sep 2009 10:18:28 -0600
Message-ID: <20090901161828.GN4197@webber.adilger.int>
References: <alpine.DEB.2.00.0908310844230.6822@asgard.lang.hm>
 <20090901005629.3932.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: david@lang.hm, pavel@ucw.cz, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755085AbZIAQSc@vger.kernel.org>
Content-disposition: inline
In-reply-to: <20090901005629.3932.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 31, 2009  20:56 -0400, George Spelvin wrote:
> >> The more I learn about storage, the more I like idea of zfs. Given the
> >> subtle issues between filesystem and raid layer, integrating them just
> >> makes sense.
> > 
> > Note that all that zfs does is tell you that you already lost data (and 
> > then only if the checksumming algorithm would be invalid on a blank block 
> > being returned), it doesn't protect your data.
> 
> Obviously, there are limits, but it does provide useful protection:
> - You know where the missing data is.
> - The error isn't amplified by believing corrupted metadata
> - I seem to recall that ZFS does replicate metadata.

ZFS definitely does replicate data.  At the lowest level it has RAID-1,
and RAID-Z/Z2, which are pretty close to RAID-5/6 respectively, but with
the important difference that every write is a full-stripe-width write,
so that it is not possible for RAID-Z/Z2 to cause corruption due to a
partially-written RAID parity stripe.

In addition, for internal metadata blocks there are 1 or 2 duplicate
copies written to different devices, so that in case of a fatal device
corruption (e.g. double failure of a RAID-Z device) the metadata tree
is still intact.

> - Corrupted replicas can be "scrubbed" and rewritten from uncorrupted ones.
> - If you have some storage redundancy, it can try different mirrors
>   to get the data back.
> 
> In particular, on a RAID-5 system, ZFS tries dropping out each data disk
> in turn to see if the correct data can be reconstructed from the others
> + parity.

What else is interesting is that in the case of 1-4-bit errors the
default checksum function can also be used as ECC to recover the correct
data even if there is no replicated copy of the data.

> One of ZFS's big performance problems is that currently it only checksums
> the entire RAID stripe, so it always has to read every drive, and doesn't
> get RAID's IOPS advantage.

Or this is a drawback of the Linux software RAID because it doesn't detect
the case when the parity is bad before there is a second drive failure and
the bad parity is used to reconstruct the data block incorrectly (which
will also go undetected because there is no checksum).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
