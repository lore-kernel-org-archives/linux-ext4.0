From: David Muchene <david.muchene@avid.com>
Subject: Fsync Performance
Date: Wed, 5 Aug 2015 14:37:38 +0000
Message-ID: <CD10AD6FBDAE574A973D585BD95C239A476955B1@WAL-MBS02.global.avidww.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:19998 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbbHEOjg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Aug 2015 10:39:36 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,
Thanks for responding. The time I'm calling "time spend doing I/O" is the difference between when  blk_dequeue_request is called and when blk_account_io_completion for the same bio is called. I thought this time accounted "the time for the SSD to confirm that the data and metadata blocks sent to the device have been written to stable store". We've tried using fdatasync and it didn't seem to make a difference. Perhaps there are mount options we don't understand?

Thanks,
David Muchene


-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu]
Sent: Tuesday, August 04, 2015 10:00 PM
To: David Muchene
Cc: linux-ext4@vger.kernel.org
Subject: Re: Fsync Performance

On Tue, Aug 04, 2015 at 07:06:13PM +0000, David Muchene wrote:
> 
> I'm not sure if this is the place to ask this, if it isn't I 
> apologize. We are occasionally seeing fsync take a very long time 
> (sometimes upwards of 3s). We decided to run some fio tests and use 
> systemtap to determine if the disks were the cause of the problem. One 
> of the results from the tests is that there occasionally there is a 
> significant difference between time spent doing io, and the total time 
> to complete the fsync. Is there an explanation to this difference, or 
> is the systemtap script bogus? If it is in fact the driver/disks that 
> is taking a long time, does anyone have any suggestions as to how I'd 
> debug that? I appreciate any help you can provide (even if it's 
> pointing me to the relevant documents).

You haven't specified which functions you are including as meaning "time spent doing I/O", but I suspect what you are seeing is the difference between the time to send the data blocks to the disk, and
(a) time to complete the journal commit and (b) the time for the SSD to confirm that the data and metadata blocks sent to the device have been written to stable store (so they will survive a power failure)[1].

[1] Note that not all SSD's, especially if they are non-enterprise SSD's, are rated to be safe against power failures.

You may be able to avoid the need to complete the journal commit if all of the writes to the file are non-allocating writes (i.e., the blocks were allocated and initialized by prewriting the blocks if the blocks were allocated using fallocate), and you use fdatasync(2) instead of fsync(2).  (If there is no need to update the file system metadata blocks in order to guarantee that the blocks can be read after a power failure, fdatasync will omit updating the inode mtime/ctime fields to the device.)

						- Ted
