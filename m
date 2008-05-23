From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 23 May 2008 14:33:56 -0400
Message-ID: <48370E14.2070309__43343.833278823$1211567759$gmane$org@gmail.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com> <20080519144654.GC15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, lin
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbYEWSes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 May 2008 14:34:48 -0400
In-Reply-To: <20080519144654.GC15035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Just a couple of comments about barriers that might be worth throwing in 
the mix.

 From what I have seen, running with barriers is almost always a win 
over running with write cache disabled for medium to large files (large 
files with a S-ATA drive go about twice as fast in my testing).

For very small files, running with the barrier or disabling the write 
cache are a lot closer in performance.

When we are looking for ways to batch, it is also critical to keep in 
mind the latency of the storage. The current ext3 transaction batching 
code makes running multi-threaded workloads on high speed media (like 
non-volatile disk arrays) run much slower.   (Josef had some patches 
which helped fix this in a similar way that XFS deals with this.)

One other note is that moving to a FLASH based device will not make the 
issue of barriers go away since (most? all?) FLASH parts you are likely 
to see have their own write cache which is used to buffer up writes in 
order to make the erase cycle less painful. That means that we have a 
fairly large *volatile* write cache which needs to be flushed/controlled 
just like we do with S-ATA/SCSI/etc ;-)

ric

