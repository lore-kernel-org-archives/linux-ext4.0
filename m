From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Sat, 17 Sep 2011 21:52:16 -0400
Message-ID: <20110918015216.GF16246@thunk.org>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com>
 <20110914163901.GE3429@dhcp-172-31-195-159.cam.corp.google.com>
 <20110915202500.GD12086@tux1.beaverton.ibm.com>
 <ABCC5DB6-7EC7-4C1A-994A-509CC663F6FE@gmail.com>
 <20110916010430.GG12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56980 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab1IRBw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Sep 2011 21:52:28 -0400
Content-Disposition: inline
In-Reply-To: <20110916010430.GG12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 06:04:30PM -0700, Darrick J. Wong wrote:
> Though I guess I should ask: Is it required that e2fsprogs build on compilers
> that won't do variable-sized stack arrays?  I think that limits us to C99
> compilers that support the feature, but I'm not 100% sure when gcc added that.
> Or if we care about other things like ... Visual Studio? ;)

There are people who have ported libext2fs to Windows, so MSVC
compatibility is something I'd rather not give up.  The other issue
with VLA's is you have to be very careful about buffer overruns, for
the obvious reasons.

At least for e2fsprogs, we don't have to worried about locking, so at
least for read verification, in the case of reading the base 128 byte
inode it would be possible to just verify the whole inode while it is
in the disk buffer.  And on the write side, since we need to do the
read/modify/write cycle, at least in the normal case it's not clear to
me that we need to use dynamic allocation in as many places as we
might think, if we're a bit clever about things.

Even if we need to save and restore the checksum fields in the disk
buffer, and zero them out while we do the checksum, it's still faster
than needing to copy the whole inode, even if we avoid doing the
malloc by using VLA....

There will be a few cases where we need to malloc and grab the whole
inode (debugfs has one case already), but in most cases I suspect it
can be avoided.

Regards,

						- Ted
