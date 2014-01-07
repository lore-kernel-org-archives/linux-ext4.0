From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 17:27:39 -0500
Message-ID: <20140107222739.GA22610@thunk.org>
References: <20140107025855.GA9229@birch.djwong.org>
 <20140107124831.GD16640@quack.suse.cz>
 <20140107154935.GA17609@infradead.org>
 <20140107170430.GA2822@thunk.org>
 <20140107194356.GC9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46713 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbaAGW2E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 17:28:04 -0500
Content-Disposition: inline
In-Reply-To: <20140107194356.GC9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 11:43:56AM -0800, Darrick J. Wong wrote:
> I had thought of indexed inode flags as an alternative to the xattr/string
> parsing thing.  Feature flags make their first appearance as part of a per-FS
> flag-space and are migrated to the common flag-space when there is demand.
> It would also avoid the need for each fs to create its own flag ioctl.
> 
> On the other hand, someone suggested I try remaking IOC_[GS]ETFLAG as an xattr,
> so off I went. :)
> 
> #define FS_IOC_FLAGS_COMMON	0
> #define FS_IOC_FLAGS_COMMON2	1
> #define FS_IOC_FLAGS_EXT4	0xEF53
> 
> struct inode_flag_ioctl {
> 	u32 flag;
> 	u32 value;	/* or u64? */
> };
> #define FS_IOC_GETFLAGS2 _IOR('f', 12, struct inode_flag_ioctl);
> #define FS_IOC_SETFLAGS2 _IOW('f', 13, struct inode_flag_ioctl);

Is having this structure and demultiplexing based on
inode_flag_ioctl.flag really worth it?

I'd just simply introduce two new ioctl's for generic flags:
FS_IOC_COMMON_[GS]ETFLAGS, and then two new ioctl's for each file
system: FS_IOC_EXT4_[GS]ETFLAGS, FS_IOC_BTRFS_[GS]ETFLAGS, etc.

Is this uglier or pretier than using strings?  Eh.... six of one, half
dozen of the other.  I think it's mostly a matter of personal taste.

      	     	       	     	  	 - Ted
