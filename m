From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to use new "native 4k sector sized" HDD with ext4
Date: Tue, 30 Oct 2012 10:22:45 -0400
Message-ID: <20121030142245.GB5972@thunk.org>
References: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, sandeen@redhat.com,
	Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58440 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab2J3OWx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 10:22:53 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 06:27:52PM +0530, Ashish Sangwan wrote:
> 
> In mkfs.xfs there is option "-s", using which, one can set the sector size.
> What is the use case of this option?
> 
> Also, such option is not present for ext4. So, apart from aligining the
>  partition on multiple of 8 sector numbers do we have to do something else
>  for using 4k sectors?

The equivalent option for ext4 is -b (which we call the block size).
It defaults to 4k for all but the very smallest file systems, where
space efficiency (especially if you are storing a large number of
small files on say, a 1.44 megabyte floppy) becomes more important.
For file system smaller than 512mb, we use the smallest possible block
size supported by ext2/3/4, which is 1k.  (This is configurable; see
/etc/mke2fs.conf; "small" file systems are ones smaller than 512mb,
while "floppy" file systems are ones smaller than 4mb.  You can change
the defaults in the configuration file, or you can specify explicit
settings via the command-line options as documented in the mke2fs man
page.

> Is there any way to make sure that ext4 is indeed using 4k sectors?

You can use dumpe2fs to look at the file system parameters.  The
confusion here is caused by the fact that xfs uses sector size where
ext 2/3/4 follows the BSD Fast File System convention of using the
terminology of "block size".

XFS supports using the minimum sector size of 512 bytes by default
since it means that if you are store large number of small files
(i.e., only one or two 512 byte sectors), there is less wasted space.
However, since ext2 and ext3 used an indirect block mapping scheme,
there was a huge performance advantage in going with 4k blocks, and so
we use that as a default for larger file systems (at the time, 512
megabytes was considered "large" :-).  With ext4, we use an
extent-based mapping scheme, but disks have gotten bigger, and so the
internal fragmentation overhead of using 4k blocks is much less of an
issue.

(Internal fragmentation is the observation that assuming a random
distribution, you will waste on average half the block size for each
file --- that is, a 1 byte or 1k file will stil take 4k of storage,
while a 3k or 4095 byte file will also require 4k of storage.  So on
average, you waste 2k of space per file.  If your average file size is
on the order megabytes, this doesn't matter.  If your average file
size is on the order of a few kilobytes, this matters more.  With 2
and 3 terabyte drives available, it's not clear this matters at all.  :-)

Regards,

      	       	      		      	  	- Ted
