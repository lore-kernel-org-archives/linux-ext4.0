From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 0/12]ext4: online defrag (ver 0.95)
Date: Wed, 1 Oct 2008 14:45:45 -0400
Message-ID: <20081001184545.GA2096@infradead.org>
References: <48DDE025.2090207@rs.jp.nec.com> <20081001004053.GD3160@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081001004053.GD3160@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 30, 2008 at 05:40:54PM -0700, Andreas Dilger wrote:
> Instead of implementing an EXT4_IOC_FIEMAP_INO ioctl, what we had implemented
> is an EXT4_IOC_WRAPPER, which takes as arguments the inode number and the
> ioctl command + original ioctl data.  This allows inode ioctls to be called
> against the filesystem root for arbitrary inodes, and doesn't require new
> implementation for each ioctl:

Or just provide more generic open by handle functionality.  Shouldn't be
too much of a problem to do it in the VFS by reusing the exportfs code.

