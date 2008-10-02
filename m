From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Thu, 02 Oct 2008 01:10:59 -0700
Message-ID: <20081002081059.GO3160@webber.adilger.int>
References: <48DDE025.2090207@rs.jp.nec.com>
 <20081001004053.GD3160@webber.adilger.int>
 <20081001184545.GA2096@infradead.org> <20081001212011.GG10080@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Christoph Hellwig <hch@infradead.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20081001212011.GG10080@mit.edu>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 01, 2008  17:20 -0400, Theodore Ts'o wrote:
> On Wed, Oct 01, 2008 at 02:45:45PM -0400, Christoph Hellwig wrote:
> > On Tue, Sep 30, 2008 at 05:40:54PM -0700, Andreas Dilger wrote:
> > > Instead of implementing an EXT4_IOC_FIEMAP_INO ioctl, what we had implemented
> > > is an EXT4_IOC_WRAPPER, which takes as arguments the inode number and the
> > > ioctl command + original ioctl data.  This allows inode ioctls to be called
> > > against the filesystem root for arbitrary inodes, and doesn't require new
> > > implementation for each ioctl:
> > 
> > Or just provide more generic open by handle functionality.  Shouldn't be
> > too much of a problem to do it in the VFS by reusing the exportfs code.
> > 
> 
> A while back I had implemented an "open by inode" patch for a friend
> who needed it for their startup.  I never posted it because (a) even
> though it was only optionally enabled via a mount option, if you allow
> non-root users to access it, it blows a whole through traditional unix
> permissions semantics (i.e., a mode 700 directory no longer protects
> files underneath that directory), and (b) I was sure that Al Viro
> would consider the hacks that I needed to make it work to be far too
> ugly to live.   :-)

We've been using that patch for a long time now in Lustre, but will soon
be replacing it with code that calls fh_to_dentry() and just craft fake
fh to have the filesystem open the inode.  That avoids all kinds of hacks
in place internally.

Definitely the __iopen__ directory should only be allowed for root...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

