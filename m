From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Persistant Ext4 error
Date: Sun, 26 Sep 2010 14:56:45 -0400
Message-ID: <20100926185645.GO19690@thunk.org>
References: <20100926125116.GA30683@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33330 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab0IZS4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Sep 2010 14:56:49 -0400
Content-Disposition: inline
In-Reply-To: <20100926125116.GA30683@sucs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 26, 2010 at 01:51:17PM +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> I've been seeing regular errors when using Ext4 on an EeePC 900 with a
> recent 2.6.36 kernel since a few weeks ago.
> 
> [  304.096022] EXT4-fs (sdb2): error count: 5
> [  304.096034] EXT4-fs (sdb2): initial error at 1284296437: ext4_lookup:1052: inode 141510
> [  304.096042] EXT4-fs (sdb2): last error at 1284300370: htree_dirblock_to_tree:586: inode 129800: block 532439
> 

This isn't actually an file system error, per se.  It's an error
summary.  It's a fine distinction, but if you want to write scripts
that automatically scan /var/log/messages looking for file systems
errors, they should look for strings such as "EXT4-fs error (sdb2): ".
Warning messages will have strings that begin "EXT4-fs warning (sdb2): ".
Strings that begin "EXT4-fs (sdb2)" are strictly for information only.

Basically, it warns that since the last time the error count
information has been cleared, the ext4 file system kernel code has
found 5 file system inconsistencies.  The first was found on September
12 (You can translate this by running the command "date
--date=@1284296437") by the ext4 function ext4_lookup, on line 1052 of
fs/ext4/namei.c, and the inode that had the problem was inode 14510.
The most recent error took place an roughly hour later on September
12th (run the command "date --date=@1284300370 to get the exact time),
and was another directory corruption error, this time in the function
htree_dirblock_to_tree().

This information will be printed every 24 hours, and the idea is that
when people call Red Hat's Global Support Services, or IBM's Support
Line, even if the original file system error report is no longer
visible in the log file (because it's been rotated out of the way) it
becomes possible to know that the file system has had inconsistencies
that haven't been fixed yet.

(It's also useful if you are running a data center for a cloud service
provider, and you don't want to panic/reboot the machine just because
of a single file system error on one of your disks.  After all, the
machine might have multiple disks attached to it, and there might be
other jobs that are running just fine using the other disks, and you
don't want to interrupt them.  At the same time you want to make sure
that your automated machine management systems are dealing correctly
with the fact that one of the file systems has reported one or more
faults.)

> The error seems to persist no matter how much I fsck the partition
> (e2fsck comes from e2fsprogs 1.41.11-1ubuntu2). The distro I am using is
> Ubuntu 10.04.

So the problem is that you've upgraded to a not-yet-released kernel,
and the code to clear out the information in the superblock that is
used to print out this information is in a not-yet-released version of
e2fsprogs.  :-)

The code to clear the superblock fields will be in e2fsprogs 1.41.13,
which should be released Real Soon Now (as in, this week).  If you
don't get around to installing that version of e2fsprogs, you can also
just ignore those messages.  If you know you've run fsck and the file
system is clean, it's nothing to worry about.

Best regards,

					- Ted
