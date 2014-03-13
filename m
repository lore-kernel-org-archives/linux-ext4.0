From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Thu, 13 Mar 2014 08:55:35 -0400
Message-ID: <20140313125535.GB11752@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140313003635.GA4263@dastard>
 <20140313011629.GA2796@thunk.org>
 <20140313031440.GA13367@thunk.org>
 <20140313060444.GH6851@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40956 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaCMOHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 10:07:44 -0400
Content-Disposition: inline
In-Reply-To: <20140313060444.GH6851@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 05:04:44PM +1100, Dave Chinner wrote:
> XFS most definitely considered sync_filesystem(sb) to be a data
> integrity operation. xfs_fs_sync_fs() calls this:
> 
> 	xfs_log_force(mp, XFS_LOG_SYNC);
> 
> Which will issue a blocking journal commit which will uses
> REQ_FLUSH|REQ_FUA for the journal writes. Hence if there was
> anything dirty in the filesystem that sync_filesystem wrote to disk,
> it will issue a cache flush just like ext4 does.

Sorry, I didn't quite do my experimets right, apparetly.

So I did the following test:

dd if=/etc/motd of=/mnt/test conv=notrunc ; mount -o remount /mnt ; mount -o remount /mnt ; mount -o remount /mnt

This is what XFS does:

252,2    0        1     0.000000000 15453  Q   W 88 + 8 [kworker/u16:1]
252,2    0        2     0.000230348 15453  C   W 88 + 8 [0]
252,2    7        1     0.000334892 15544  Q FWFSM 5243112 + 8 [mount]
252,2    0        3     0.251131828     0  C WFSM 5243112 + 8 [0]
252,2    0        4     0.251495890 15087  Q  WM 96 + 16 [xfsaild/dm-2]
252,2    0        5     0.251729470     0  C  WM 96 + 16 [0]
252,2    4        1     0.263317936 11070  Q FWFSM 5243120 + 8 [kworker/4:2]
252,2    0        6     0.273394400     0  C WFSM 5243120 + 8 [0]
252,2    0        7     0.273678692 15087  Q  WM 0 + 8 [xfsaild/dm-2]
252,2    0        8     0.273902550     0  C  WM 0 + 8 [0]
252,2    0        9     0.295673237     0  C WFSM 5243128 + 8 [0]
252,2    0       10     0.296035803 15087  Q  WM 0 + 8 [xfsaild/dm-2]
252,2    0       11     0.296266732     0  C  WM 0 + 8 [0]
252,2    7        2     0.286271844 24012  Q FWFSM 5243128 + 8 [kworker/7:0]

... and this is what ext4 does:

252,4    7        8    10.973326622 15512  Q  WM 78 + 2 [mount]
252,4    7        9    10.973576941 15512  Q FWS [mount]
252,4    2        1    10.973141488 15271  Q   W 108 + 2 [kworker/u16:3]
252,4    0       24    10.973390538     0  C   W 108 + 2 [0]
252,4    0       25    10.973548736     0  C  WM 78 + 2 [0]
252,4    7       10    11.244052462 15513  Q FWS [mount]
252,4    0       26    11.231292967     0  C FWS 0 [0]
252,4    0       27    11.231452643 15512  Q  WS 2 + 2 [mount]
252,4    0       28    11.231686794     0  C  WS 2 + 2 [0]
252,4    7       11    11.266337812 15514  Q FWS [mount]
252,4    0       29    11.253022650     0  C FWS 0 [0]
252,4    0       30    11.253135113 15513  Q  WS 2 + 2 [mount]
252,4    0       31    11.253376707     0  C  WS 2 + 2 [0]
252,4    0       32    11.266640135     0  C FWS 0 [0]
252,4    0       33    11.266727461 15514  Q  WS 2 + 2 [mount]
252,4    0       34    11.266954710     0  C  WS 2 + 2 [0]

> > 1)  Nowhere in the remount system call is it stated that it has
> >     ***any*** data integrity implications.   If you are making the rw->ro
> >     transition, sure, you'll need to flush out any pending changes.  But there
> >     doesn't seem to be any justification for requiring this this if the
> >     remount is a no-op.   So I think changing the remount code path as I
> >     suggested is a valid option.
> 
> What the man page says doesn't change the fact we need to audit all
> the existing filesystems before such a change is made.

Fair enough, I'll do what Christoph suggested and move the
sync_filesystems() call into all of the existing file systems.

		   	     	    - Ted
