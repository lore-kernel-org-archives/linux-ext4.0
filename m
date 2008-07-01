From: Theodore Tso <tytso@mit.edu>
Subject: Re: Segmentation Faults with both 062608 snapshots
Date: Mon, 30 Jun 2008 22:32:53 -0400
Message-ID: <20080701023252.GA28143@mit.edu>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net> <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net> <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40637 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752966AbYGACdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2008 22:33:05 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 26, 2008 at 10:12:27PM +0000, Gary Hawco wrote:
> More on my segmentation problems. Just looking at the end of each kernel
> message, they always end with:
> EIP [XXXXX]  jbd2_journal_data_metadata-XXX

Hmm... any chance you can take a picture of the crash message with a
digital camera and post the jpg?  (I'm assuming you haven't been able
to capture the OOPS stack trace in /var/log/kern.log or
/var/log/messages or some such.)

> This occurs when I try to copy data from my main partition to a backup
> partition or make a tarball.

I am currently using the ext4 patch queue comit id #555132eb from
2008-06-30 13:04:35 -0400, and I can't reproduce it.  I just tried
backing up by isync mail directory to a tar.gz file and then restored
it, with no problems.  Both the source and backup partition are ext4
filesystems with flex_bg, meta_bg, and uninit_bg, located on separate
LVM logical volumes on my laptop.[1]

[1]  http://thunk.org/tytso/blog/2008/06/30/ext4-is-now-the-primary-filesystem-on-my-laptop/

The partition is mounted using mount options:

    noatime,errors=remount-ro,barrier=1,data=ordered

according to /proc/mounts.

The big difference between your mount options and mine is that I dont
have journal_async_commit as a mount option.  Which would be largely
moot for me since LVM doesn't support barrier operations. :-(  :-(  :-(

You seem to be able to reproduce the problem at will.  Could you try
removing te journal_sync_commit option and see if it makes the problem
go away?  That would be very interesting if it were the case...

   	       	     	     		       - Ted
