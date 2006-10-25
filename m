From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 12:30:02 +1000
Message-ID: <200610250225.MAA23029@larry.melbourne.sgi.com>
References: <20061025011853.GQ8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Jeff Garzik'" <jeff@garzik.org>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:40104 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1422880AbWJYC0e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 22:26:34 -0400
To: "'David Chinner'" <dgc@sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>
In-Reply-To: <20061025011853.GQ8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 

On Wed, 25 Oct 2006 11:19 AM, David Chinner wrote:
> On Tue, Oct 24, 2006 at 11:26:26AM -0500, Dave Kleikamp wrote:
> > On Wed, 2006-10-25 at 02:01 +1000, David Chinner wrote:
> > > On Tue, Oct 24, 2006 at 09:51:41AM -0500, Dave Kleikamp wrote:
> > > The allocation interface needs to be be able to be  extended
> > > independently of the data mover interface. XFS already exposes
> > > allocation ioctls to userspace for preallocation and 
> we've got plans
> > > to extnd this further to allow userspace controlled allocation for
> > > smart defrag tools for XFS. Tying allocation to the data mover
> > > just makes the interface less flexible and harder to do anything
> > > smart with....
> > 
> > Okay.  It would be nice to standardize the interface so we 
> don't have
> > every filesystem introducing new ioctls.
> 
> Well, that will be an interesting challenge. I'm sure that there
> is a common subset that all filesystems can implement e.g. per
> file preallocation (something like XFS's allocate/reserve/free space
> ioctls) to provide kernel support for posix_fallocate(), etc.
> 
> However, we may end up exposing enough of XFS's current allocation
> semantics to do things like telling the filesystem to allocate in
> allocation group 6, near block number 0x32482 within the AG, falling
> back to searching for the nearest match to the size requirement,
> failing that look for something larger than the minimum size
> specified, and then fail if you can't find a match in that AG.
> 
> That makes little sense to any filesystem but XFS, which is really
> why I think that the smarter allocation interfaces are going to
> remain filesystem specific....

Could we have a more abstract method for asking the filesystem where the 
free blocks are and then using the same block addressing to tell the
fs where to allocate/move the file's data to?
