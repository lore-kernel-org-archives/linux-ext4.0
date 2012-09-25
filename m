From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 03/10] vfs: add one new mount option '-o hottrack'
Date: Tue, 25 Sep 2012 19:28:19 +1000
Message-ID: <20120925092819.GC29154@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-4-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348404995-14372-4-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 23, 2012 at 08:56:28PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Introduce one new mount option '-o hottrack',
> and add its parsing support.
>   Its usage looks like:
>    mount -o hottrack
>    mount -o nouser,hottrack
>    mount -o nouser,hottrack,loop
>    mount -o hottrack,nouser

I think that this option parsing should be done by the filesystem,
even though the tracking functionality is in the VFS. That way ony
the filesystems that can use the tracking information will turn it
on, rather than being able to turn it on for everything regardless
of whether it is useful or not.

Along those lines, just using a normal superblock flag to indicate
it is active (e.g. MS_HOT_INODE_TRACKING in sb->s_flags) means you
don't need to allocate the sb->s_hot_info structure just to be able
to check whether we are tracking hot inodes or not.

This then means the hot inode tracking for the superblock can be
initialised by the filesystem as part of it's fill_super method,
along with the filesystem specific code that will use the hot
tracking information the VFS gathers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
