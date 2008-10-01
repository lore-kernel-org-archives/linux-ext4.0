From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Wed, 1 Oct 2008 17:20:11 -0400
Message-ID: <20081001212011.GG10080@mit.edu>
References: <48DDE025.2090207@rs.jp.nec.com> <20081001004053.GD3160@webber.adilger.int> <20081001184545.GA2096@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51920 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705AbYJAVUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 17:20:18 -0400
Content-Disposition: inline
In-Reply-To: <20081001184545.GA2096@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 01, 2008 at 02:45:45PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 30, 2008 at 05:40:54PM -0700, Andreas Dilger wrote:
> > Instead of implementing an EXT4_IOC_FIEMAP_INO ioctl, what we had implemented
> > is an EXT4_IOC_WRAPPER, which takes as arguments the inode number and the
> > ioctl command + original ioctl data.  This allows inode ioctls to be called
> > against the filesystem root for arbitrary inodes, and doesn't require new
> > implementation for each ioctl:
> 
> Or just provide more generic open by handle functionality.  Shouldn't be
> too much of a problem to do it in the VFS by reusing the exportfs code.
> 

A while back I had implemented an "open by inode" patch for a friend
who needed it for their startup.  I never posted it because (a) even
though it was only optionally enabled via a mount option, if you allow
non-root users to access it, it blows a whole through traditional unix
permissions semantics (i.e., a mode 700 directory no longer protects
files underneath that directory), and (b) I was sure that Al Viro
would consider the hacks that I needed to make it work to be far too
ugly to live.   :-)

						- Ted
