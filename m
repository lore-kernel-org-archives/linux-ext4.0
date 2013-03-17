From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Sat, 16 Mar 2013 23:06:48 -0400
Message-ID: <20130317030648.GA14225@thunk.org>
References: <20130315222818.GA16100@wallace>
 <20130316150923.GA18589@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53846 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab3CQDGw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Mar 2013 23:06:52 -0400
Content-Disposition: inline
In-Reply-To: <20130316150923.GA18589@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 16, 2013 at 11:09:23PM +0800, Zheng Liu wrote:
> 
> I see what's going on.  First of all it isn't a bug. :-)  Please let me
> describe why it happens.
> 
> In this commit (4f42f80a8f), it tries to fix a bug that we never zero
> out an unwritten extent.  So after applied it, when an unwritten extent
> is converted, it could be zeroed out.  In xfstests #285 subtest 08 it
> preallocates an unwritten extent which is 4MB.  Then it writes some data
> at offset 10 * blocksize, which the length is one blocksize, and calles
> sync_file_range(2) to flush it.

Specifically, we are now honoring the default setting which sets the
max_zeroout_kb value to be 32.  With a 4k block file system, if we
were to zeroout the extent, we would have to zero out 40k, which is
greater than 32k, so resulting file after pwrite(fd, 4096, 40960)
looks like this:

% filefrag -v /u1/foo08 
Filesystem type is: ef53
File size of /u1/foo08 is 4194304 (1024 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       9:    1852416..   1852425:     10:             unwritten
   1:       10..      10:    1852426..   1852426:      1:            
   2:       11..    1023:    1852427..   1853439:   1013:             unwritten,eof
/u1/foo08: 1 extent found

With a 1k block file system, we only need to zero out 10k, which is
less than 32k, and so after pwrite(fd, 1024, 10240), the file looks
like this:

% filefrag -v /mnt/foo08
Filesystem type is: ef53
File size of /mnt/foo08 is 4194304 (4096 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      10:      81921..     81931:     11:            
   1:       11..    4095:      81932..     86016:   4085:             unwritten,eof
/mnt/foo08: 1 extent found

If we run src/seek_sanity_test by hand, we can make it happy by
setting the following configuration option before we run it:

echo 0 > /sys/fs/ext4/<dev>/extent_max_zeroout_kb 

I'm not sure what's the best way to make xfstest #285 happy, though.

One way might be to change the test so that instead of writing the
data at offset bufsize*10, we change it so it writes the data at
offset bufsize*40, and change the expected values accordingly.  The
other would be to add some kind of ext4-specific hack to test #285
which manually sets the extent_max_zeroout_kb tuning parameter after
the file system is mounted.

I'm not sure which is more likely to be accepted by the xfstests
maintainers.  I suspect the former, but they may not like either
solution, in which case we might have to disable 285 for ext4 and
create an ext4-specific test.

	      		    	    	    - Ted
