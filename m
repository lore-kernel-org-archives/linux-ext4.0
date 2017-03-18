From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Sat, 18 Mar 2017 12:29:53 -0400
Message-ID: <20170318162953.ubn3lvglxqq6ux2e@thunk.org>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <CE3A3FB1-8DE6-476A-8386-94D590B17A23@dilger.ca>
 <E3BFD2D7-CCEF-4A10-A4E6-ED634C56436F@gmail.com>
 <07B442BA-D335-4079-8691-0AB1FAD7368F@dilger.ca>
 <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53536 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdCRQuw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 18 Mar 2017 12:50:52 -0400
Content-Disposition: inline
In-Reply-To: <18FAA61C-DE3C-42C7-A8A4-BB2CDD3C5D24@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 18, 2017 at 11:16:26AM +0300, Alexey Lyashkov wrote:
> Andreas,
> 
> it not about a feature flag. It’s about a situation in whole.
> Yes, we may increase a directory size, but it open a number a large problems.

> 1) readdir. It tries to read all entries in memory before send to
> the user. currently it may eats 20*10^6 * 256 so several gigs, so
> increasing it size may produce a problems for a system.

That's not true.  We normally only read in one block a time.  If there
is a hash collision, then we may need to insert into the rbtree in a
subsequent block's worth of dentries to make sure we have all of the
directory entries corresponding to a particular hash value.  I think
you misunderstood the code.

> 2) inode allocation. Current code tries to allocate an inode as near as possible to the directory inode, but one GD may hold 32k entries only, so increase a directory size will use up 1k GD for now and more than it, after it. It increase a seek time with file allocation. It was i mean when say - «dramatically decrease a file creation rate».

But there are also only 32k blocks in a group descriptor, and we try
to keep the blocks allocated close to the inode.  So if you are using
a huge directory, and you are using a storage device with a
significant seek penalty, then yes, no matter what as the directory
grows, the time to iterate over all of the files does grow.  But there
is more to life than microbenchmarks which creates huge numbers of zero
length files!  If we assume that the files are going to need to
contain _data_, and the data blocks should be close to the inodes,
then there are going to be some performance impacts no matter what.

> 3) current limit with 4G inodes - currently 32-128 directories may eats a full inode number space. From it perspective large dir don’t need to be used.

I can imagine a new feature flag which defines the use a 64-bit inode
number, but that's more for people who are creating a file system that
takes advantage of 64-bit block numbers, and they are intending on
using all of that space to store small (< 4k or < 8k) files.

And it's also true that there are huge advantges to using a
multi-level directory hierarchy --- e.g.:

.git/objects/03/08e42105258d4e53ffeb81ffb2a4b2480bb8b8

or even

.git/objects/03/08/e42105258d4e53ffeb81ffb2a4b2480bb8b8

instead of:

.git/objects/0308e42105258d4e53ffeb81ffb2a4b2480bb8b8

but that's an application level question.  If for some reason some
silly application programmer wants to have a single gargantuan
directory, if the patches to support it are fairly simple, even if
someone is going to give us patches to do something more general,
burning an extra feature flag doesn't seem like the most terrible
thing in the world.

As for the other optimizations --- things like allowing parallel
directory modifications, or being able to shrink empty directory
blocks or shorten the tree are all improvements we can make without
impacting the on-disk format.  So they aren't an argument for halting
the submission of the new on-disk format, no?

    	       	      	  	  	  - Ted
