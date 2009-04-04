From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 corruption
Date: Sun, 5 Apr 2009 07:09:15 +0930
Message-ID: <20090404213915.GD5436@kulgan>
References: <20090403221508.GA5436@kulgan> <49D69AD8.6070808@redhat.com> <20090404105226.GC5436@kulgan> <20090404162335.GC9812@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rqzD5py0kzyFAOWN"
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:40759 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZDDVjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 17:39:24 -0400
Content-Disposition: inline
In-Reply-To: <20090404162335.GC9812@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 04, 2009 at 12:23:35PM -0400, Theodore Tso wrote:
> Hmm, what kernel version are you running at this point?  Going through
> your old e-mails I saw kernel log from 2.6.29-rc6; is that what you
> are still running?

Yeah, still 2.6.29-rc6. I was going to take an image of the block
device (logical volume), but it's going to take a bit too long and
probably not that useful anyway. I'll update to 2.6.29.1 today.

> The symptoms seem to be the same as before --- something is writing
> garbage into (apparently) a single 4k block, smashing part of your
> inode table.  It always seems to be a relatively low-numbered block.
> This time, affecting inode numbers in the range of 369-375.  
> 
> I don't remember if we've been through this procedure with you yet,
> but if you haven't run fsck yet, find out the block number containing
> the corrupted part of the inode table:
> 
> debugfs /dev/XXX
> debugfs: imap <375>
> Inode 375 is part of block group 0
>       located at block 88, offset 0x0600
> 
> And then do extract out the named block number like so:
> 
> dd if=/dev/XXX of=block88.dump bs=4k skip=88 count=1
> 
> then send us the 4k dump file, and let's see if we can see where it
> came from.  Maybe that will be a hint as to who or what wrote the
> garbage to that location on disk.

debugfs 1.41.3 (12-Oct-2008)
debugfs:  imap <375>
Inode 375 is part of block group 0
      located at block 312, offset 0x0600

Okay, same block as inode 372 which I sent to the list earlier.
 http://marc.info/?l=linux-ext4&m=123879692007843&w=2

Cheers,
Kevin.

--rqzD5py0kzyFAOWN
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="block-312.dump"
Content-Transfer-Encoding: base64

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

--rqzD5py0kzyFAOWN--
