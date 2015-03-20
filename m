From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: fs corruption recovery
Date: Fri, 20 Mar 2015 11:45:02 -0700
Message-ID: <20150320184501.GN11031@birch.djwong.org>
References: <550A1EBF.2030902@linux.vnet.ibm.com>
 <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca>
 <20150320014708.GA3425@thunk.org>
 <550BB465.6040601@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jane@us.ibm.com" <jane@us.ibm.com>,
	"marcel.dufour@ca.ibm.com" <marcel.dufour@ca.ibm.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48089 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbCTSpM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Mar 2015 14:45:12 -0400
Content-Disposition: inline
In-Reply-To: <550BB465.6040601@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 19, 2015 at 10:47:17PM -0700, Allison Henderson wrote:
> On 03/19/2015 06:47 PM, Theodore Ts'o wrote:
> >On Wed, Mar 18, 2015 at 06:59:52PM -0600, Andreas Dilger wrote:
> >>I think that running a 17TB filesystem on ext3 is a recipe for disaster.  They should use ext4 for anything larger than 16TB.
> >
> >It's not *possible* to have a 17TB file system with ext3.  Something
> >must be very wrong there.  16TB is the maximum you can have before you
> >end up overflowing a 32-bit block number.  Unless this is a PowerPC
> >with a 16K block size or some such?
> >
> >If e2fsck is segfaulting, then I would certainly try getting the
> >latest version of e2fsprogs, just in case the problem isn't just that
> >it's running out of memory.  Also if recovering customer data is the
> >most important thing, the first thing they should do is a make image
> >copy of the file system, since it's possible that incorrect use of
> >e2fsck, or an old/buggy version of e2fsck could make things work.

...make things *worse*.

> >
> >In particular, if they are seeing errors with multply claimed inodes,
> >it's likely that part of the inode table was written to the wrong
> >place, and sometimes a skilled human being can get more data than
> >simply using e2fsck -y and praying.  At the end of the day the
> >question is how much is the customer data work and how much effort is
> >the customer / IBM willing to invest in trying to get every last bit
> >of data back?
> >
> >						- Ted
> >
> 
> Hi all,
> 
> Sorry for the delay, our email servers went down for a bit after I
> sent the email.  I will work with Marcel to find the block size,
> page size and arch.  It is my understanding they they have a

Just guessing PPC, in which case you'll really want an e2fsck released after
the giant heaps of bugfixes I've sent over the last year.  There were a lot
of bugs that only show up on bigendian systems, which probably don't get
much testing nowadays.

Even if it's a 17179869184 byte ext3 FS on x86, you're probably still better
off with a less buggy e2fsck.  There are a number of fixes to prevent the
crosslinked file fixer and the directory fixer from doing insane things to
the FS.

> contract with this customer to maintain this data, so there is
> pressure to recover it. Unfortunately the product mirrored the fs
> corruption to the back up device before the corruption was
> discovered.  I've been told that I was the only person they could
> find left that had some background with ext3/4, so I have an inkling

Yep. ;)

> that the "skilled human being" might end up being me, even though
> its been a while since I've worked with it. :-) Maybe I could poke
> into the inode table and see what I can figure out. We will be sure
> to make image backups though.  Thx a bunch for the feed back, we
> really appreciate the help!  I will keep folks updated when I have
> more info.  Thx!

If you have LVM or other volume management, please take a snapshot and fsck the
snapshot first, so you can capture a log of what happens without blasting away
at existing data.

--D

> 
> Allison Henderson
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
