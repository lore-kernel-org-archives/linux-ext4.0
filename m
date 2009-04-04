From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 corruption
Date: Sat, 4 Apr 2009 12:23:35 -0400
Message-ID: <20090404162335.GC9812@mit.edu>
References: <20090403221508.GA5436@kulgan> <49D69AD8.6070808@redhat.com> <20090404105226.GC5436@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60406 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZDDQXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 12:23:46 -0400
Content-Disposition: inline
In-Reply-To: <20090404105226.GC5436@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm, what kernel version are you running at this point?  Going through
your old e-mails I saw kernel log from 2.6.29-rc6; is that what you
are still running?

The symptoms seem to be the same as before --- something is writing
garbage into (apparently) a single 4k block, smashing part of your
inode table.  It always seems to be a relatively low-numbered block.
This time, affecting inode numbers in the range of 369-375.  

I don't remember if we've been through this procedure with you yet,
but if you haven't run fsck yet, find out the block number containing
the corrupted part of the inode table:

debugfs /dev/XXX
debugfs: imap <375>
Inode 375 is part of block group 0
      located at block 88, offset 0x0600

And then do extract out the named block number like so:

dd if=/dev/XXX of=block88.dump bs=4k skip=88 count=1

then send us the 4k dump file, and let's see if we can see where it
came from.  Maybe that will be a hint as to who or what wrote the
garbage to that location on disk.

				- Ted
