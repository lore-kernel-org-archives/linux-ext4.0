From: Ted Ts'o <tytso@mit.edu>
Subject: Re: linux-ext4@vger.kernel.org --- ext4 going read-only/journal
 abort when raid controller resets itself
Date: Sat, 24 Dec 2011 12:03:17 -0500
Message-ID: <20111224170317.GA6068@thunk.org>
References: <4EF58ABF.8020404@van-ness.com>
 <4EF58BC6.9010302@van-ness.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sandon Van Ness <sandon@van-ness.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40080 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab1LXRDW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Dec 2011 12:03:22 -0500
Content-Disposition: inline
In-Reply-To: <4EF58BC6.9010302@van-ness.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/24/2011 12:18 AM, Sandon Van Ness wrote:
>Most of our machines are ext3 and have seen the card get reset on
>ext3 and it never went read-only like it always does in ext4 now.
>The I/O goes unresponsive for a few minutes as it detects I/O is
>unresponsive and then the controller is reset and the machine
>would recover (on ext3/jfs, and other fs's) on ext4 the journal is
>aborted and it goes into read-only:

Both ext3 and ext4 will go abort the journal and remount the file
system read/only if it detects an inconsistency in the metadata.  This
is the default behavior, and it is intended to protect the file system
from further damage leading to data loss.

So for example, if a RAID card hiccups and returns all zero's for a
block allocation bitmap, if ext3 or ext4 then tries to delete a file
and it discovers that when it tries to deallocate a block, that the
block bitmap already shows that the block is not in use, that's
considered a file system inconsistency.  At that point, the default
behavior is that the file system will be remounted read-only, to
prevent the corrupted information from being written back to the disk,
or if the corruption was already on the disk, to prevent things from
getting worse.

That's what this is all about:

>[606900.929121] EXT4-fs error (device sdb1): mb_free_blocks:1397:
>group 39137block 1282445473:freeing already freed block (bit 4257)

Now, why wasn't this happening before on ext3?  I can think of two
possible reasons.  One is that the layout of a freshly created ext4
file system is different from that of a freshly created ext3 file
system.  Specifically, the block allocation bitmaps for adjacent block
groups are laid out slightly differently.  That may have caused some
*other* data or metadata block to be corrupted, which wasn't noticed
by the file system.

The other possibility is that the older tune2fs had the default
behavior when file system errors are discovered changed to something
else.  For example, via the command "tune2fs -e continue /dev/sdXX".
This will put the file system in what I call, "Don't worry, be happy"
mode.  It's NOT safe, but if uptime is more import than data
consistency, that's your decision....

In any case, the real issue seems to be that you have a hardware
problem.  If your hardware raid card is aborting SCSI commands,
something is wrong, and you should fix this.  The fact that ext4 is
remounting the file system read-only is because it's trying to protect
you.  Complaining about that is like complaining about why the air
bags went off after your car suffers a head-on collision....

     	      	    	     	       - Ted
