From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] can't recover ext4 on lvm from ext4_mb_generate_buddy:739:
 group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Fri, 6 Jan 2012 11:40:17 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it>
 <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it>
 <20120105181535.GB26382@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757Ab2AFQk0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jan 2012 11:40:26 -0500
In-Reply-To: <20120105181535.GB26382@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 5 Jan 2012, Ted Ts'o wrote:

> On Thu, Jan 05, 2012 at 05:14:28PM +0100, Sander Eikelenboom wrote:
> > 
> > OK spoke too soon, i have been able to trigger it again:
> > - copying files from LV to the same LV without the snapshot went OK
> > - copying from the RO snapshot of a LV to the same LV gave the error while copying the file again:
> 
> OK.  Originally, you said you did this:
> 
> 1) fsck -v -p -f the filesystem
> 2) mount the filesystem
> 3) Try to copy a file
> 4) filesystem will be mounted RO on error  (see below)
> 5) fsck again, journal will be recovered, no other errors
> 6) start at 1)
> 
> Was this with with a read-only snapshot always being in existence
> through all of these five steps?  When was the RO snapshot created?
> 
> If a RO snapshot has to be there in order for this to happen, then
> this is almost certainly a device-mapper regression.  (dm-devel folks,

The existence of a snapshot changes I/O completion times significantly, so 
it may be a race condition in ext4 that gets triggered which changed 
timings.

Mikulas

> this is a problem which apparently occurred when the user went from
> v3.1.5 to v3.2, so this looks likes 3.2 regression.)
> 
> 						- Ted
