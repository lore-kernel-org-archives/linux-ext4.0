From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fsync Performance
Date: Tue, 4 Aug 2015 21:59:42 -0400
Message-ID: <20150805015942.GA3432@thunk.org>
References: <CD10AD6FBDAE574A973D585BD95C239A4769527A@WAL-MBS02.global.avidww.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: David Muchene <david.muchene@avid.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41188 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbbHEB7p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2015 21:59:45 -0400
Content-Disposition: inline
In-Reply-To: <CD10AD6FBDAE574A973D585BD95C239A4769527A@WAL-MBS02.global.avidww.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2015 at 07:06:13PM +0000, David Muchene wrote:
> 
> I'm not sure if this is the place to ask this, if it isn't I
> apologize. We are occasionally seeing fsync take a very long time
> (sometimes upwards of 3s). We decided to run some fio tests and use
> systemtap to determine if the disks were the cause of the
> problem. One of the results from the tests is that there
> occasionally there is a significant difference between time spent
> doing io, and the total time to complete the fsync. Is there an
> explanation to this difference, or is the systemtap script bogus? If
> it is in fact the driver/disks that is taking a long time, does
> anyone have any suggestions as to how I'd debug that? I appreciate
> any help you can provide (even if it's pointing me to the relevant
> documents).

You haven't specified which functions you are including as meaning
"time spent doing I/O", but I suspect what you are seeing is the
difference between the time to send the data blocks to the disk, and
(a) time to complete the journal commit and (b) the time for the SSD
to confirm that the data and metadata blocks sent to the device have
been written to stable store (so they will survive a power failure)[1].

[1] Note that not all SSD's, especially if they are non-enterprise
SSD's, are rated to be safe against power failures.

You may be able to avoid the need to complete the journal commit if
all of the writes to the file are non-allocating writes (i.e., the
blocks were allocated and initialized by prewriting the blocks if the
blocks were allocated using fallocate), and you use fdatasync(2)
instead of fsync(2).  (If there is no need to update the file system
metadata blocks in order to guarantee that the blocks can be read
after a power failure, fdatasync will omit updating the inode
mtime/ctime fields to the device.)

						- Ted
