From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 01 Mar 2010 18:37:39 -0600
Message-ID: <4B8C5DD3.4060804@redhat.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B8C56F8.70503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0CBAhq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 19:37:46 -0500
In-Reply-To: <4B8C56F8.70503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Justin Piszcz wrote:
>> Hello,
>>
>> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
>> I see about half the performance as XFS for sequential writes.
>>
>> I have checked the doc and tried several options, a few of which are shown
>> below (I have also tried the commit/journal_async/etc options but none
>> of them get the write speeds anywhere near XFS)?
>>
>> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
>> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
>>
>> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
>> volume.
>>
>> How do I 'speed' up ext4?  Is it possible?
>>
> 
> FWIW I'm seeing similar things on fast storage (Fusion IO),
> though this is under 2.6.31.  500MB/s+ for xfs, 300 for ext4.
> 
> Overwriting an existing file is no faster.   I don't think this
> driver is blktraceable but I'll try a newer driver that should be I think.

FWIW, blktrace (I'm still on 2.6.31) is enlightening:

Total (xfs):
 Reads Queued:           4,       16KiB	 Writes Queued:     122,567,   10,485MiB
 Read Dispatches:        4,       16KiB	 Write Dispatches:   83,219,   10,485MiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        4,       16KiB	 Writes Completed:   83,219,   10,485MiB
 Read Merges:            0,        0KiB	 Write Merges:       39,348,  314,804KiB
 IO unplugs:           344        	 Timer unplugs:         338

Total (ext4):
 Reads Queued:          14,       56KiB	 Writes Queued:       2,621K,   10,486MiB
 Read Dispatches:       14,       56KiB	 Write Dispatches:  107,944,   10,486MiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:       14,       56KiB	 Writes Completed:  107,944,   10,486MiB
 Read Merges:            0,        0KiB	 Write Merges:        2,513K,   10,054MiB
 IO unplugs:         2,461        	 Timer unplugs:       2,020


See "Writes Queued"  See also submit_bio() calls in xfs.

ext4 doing things a block at a time is certainly giving the elevator a workout...
I'd tend to chalk it up to that at first glance.

-Eric
