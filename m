From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: maintain badblocks list on the fly
Date: Sun, 5 Jan 2014 20:27:32 -0500
Message-ID: <20140106012732.GA21107@thunk.org>
References: <52C92DC9.7030806@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Oleksij Rempel <linux@rempel-privat.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46147 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaAFB1h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 20:27:37 -0500
Content-Disposition: inline
In-Reply-To: <52C92DC9.7030806@rempel-privat.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 05, 2014 at 11:02:49AM +0100, Oleksij Rempel wrote:
> 
> after some googling i didn't found answer to my question, so i set it
> directly here: do it makes sense and is it possible to maintain bad
> block list of ext4 on fly? I mean, if ext4 get error from, for example
> from ata subsystem, and it will mark block as bad or may be better as
> "probably bad"?

Figuring out what to do in case of an error is tricky.  Sometimes
errors are transient.  For example, losing a connection (perhaps
briefly) to a disk connected via fiber channel).

Also, with most hard drives, if you rewrite a block which has reported
a read error, the hard drive will usually remap the block to one of
the blocks in the spare pool.  So one strategy is when you get a read
error is not to avoid using the block forever, but to simply write all
zero's to the block, and then see if the block is now valid.  But now
combine this with the "some errors are transient" problem --- if you
do a forced rewrite, you might lose data that you could get back i you
try rereading the block later.  So it's rare file system author that
is willing to do an automated forced rewrite when getting a read
error.

For a write error, it's safer to try rewriting the block, but most of
the time the hard drive will have tried rewriting the block already,
unless it's due to a connection problem between the file system and
the storage device.  For example, suppose the file system is accessing
an iSCSI block device which where the transport layer between computer
and the storage device is a TCP connection...

So the problem with automated error recovery is that it's highly
dependent on the storage device (is it a RAID; a hard drive; an iSCSI
device, etc.) and the application / what are you storing.

For example, if the file system is on a direct connected HDD as the
back end for a cluster file system such as hadoopfs or the Google File
System, where the cluster file system is storing every chunk of its
file replicated on multiple file servers, and/or using some kind of
Reed Solomon encoding, when you detect a read error on data block, the
best thing to do might be to delete file (relying on the fact that the
next time you write to the bad block, the HDD will remap the block to
one of the blocks in the spare pool), and then informing the cluster
file system that it should do a Reed Solomon reconstruction or to
otherwise reshard that portion of the file.

At one point I toyed with trying to get something upstream where the
bad block notification would get sent via a netlink channel.  That way
userspace can do something appropriate, instead of trying to encode
what can potentially extremely complicated policy decisions into the
kernel.  I never had the time to get the design and interface clean
enough for upstream, though.

						- Ted
