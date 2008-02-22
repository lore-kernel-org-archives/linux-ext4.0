From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 13:25:55 -0500
Message-ID: <20080222182555.GS20118@mit.edu>
References: <47BDF6C9.8090009@redhat.com> <20080222131622.GK20118@mit.edu> <47BEE420.8030105@redhat.com> <20080222154404.GP20118@mit.edu> <47BEF575.40908@redhat.com> <20080222163331.GQ20118@mit.edu> <Pine.LNX.4.64.0802221305410.11313@lpc1.fields.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Philip Spencer <pspencer@fields.utoronto.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45682 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbYBVS1U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 13:27:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802221305410.11313@lpc1.fields.utoronto.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 01:10:40PM -0500, Philip Spencer wrote:
> You know what -- I went back and double-checked all the logs, and somehow
> or other I must have recorded a timestamp wrong as 3:19:21 instead of 
> 3:19:51.
>
> The segfault did in fact happen at 3:19:51 a.m. which is exactly the same 
> time as my backup script moved on to the next filesystem.
>
> So, it occurred during the unmount and lvremove of the snapshot volume.
> It is, then, entirely expected that the device-mapper routines would return 
> an error if the device no longer existed when the task was run.
>
> My apologies for mixing up the timestamps! And no bug in device-mapper, 
> just the one in e2fsprogs whch segfaulted in this circumstance instead of 
> dropping the device from its list. Having it fail outright, and not list 
> the device at all, is the correct behaviour for this situation -- just as 
> if the device had already been removed before the blkid routines were run.

OK, that's helpful, to know.  Thanks!!!

						- Ted
