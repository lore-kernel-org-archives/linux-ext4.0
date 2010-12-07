From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len
 functions
Date: Tue, 7 Dec 2010 13:33:08 -0800
Message-ID: <20101207133308.eb2144da.akpm@linux-foundation.org>
References: <4CFE7347.8030807@redhat.com>
	<4CFE7409.9090609@redhat.com>
	<20101207130708.71c894e9.akpm@linux-foundation.org>
	<4CFEA5AF.2000702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab0LGVdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 16:33:23 -0500
In-Reply-To: <4CFEA5AF.2000702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 07 Dec 2010 15:22:55 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> On 12/7/10 3:07 PM, Andrew Morton wrote:
> > On Tue, 07 Dec 2010 11:51:05 -0600
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >> The addition of 64k block capability in the rec_len_from_disk
> >> and rec_len_to_disk functions added a bit of math overhead which
> >> slows down file create workloads needlessly when the architecture
> >> cannot even support 64k blocks, thanks to page size limits.
> >>
> >> The directory entry checking can also be optimized a bit
> >> by sprinkling in some unlikely() conditions to move the
> >> error handling out of line.
> >>
> >> bonnie++ sequential file creates on a 512MB ramdisk speeds up
> >> from about 2200/s to about 2500/s, about a 14% improvement.
> >>
> > 
> > hrm, that's an improbably-large sounding improvement from eliminating
> > just a few test-n-branches from a pretty heavyweight operation.
> 
> And yet ...
> 
> Yeah, I dunno.  Part of it is that ext2_add_link does a linear
> search, so when you do rec_len_from_disk 50,000 times on a dir,
> that little bit adds up quite badly I suppose.

oh yeah, that would do it.

> Retesting at a bunch of different number-of-files in bonnie
> (with a small sample size so probably a little noise)
> 
> 	|files per sec|
> files	stock	patched	delta
> 10,000	12300	14700	+19%
> 20,000	 6300	 7600	+20%
> 30,000	 4200	 5000	+20%
> 40,000	 3150	 3700	+17%
> 50,000	 2500	 3000	+20%
> 
> (again all on a 512MB ramdisk)
> 
> *shrug* I'll believe my lyin' eyes, I guess. :)
> 

I bet other tweaks in there would yield similar goodliness.

