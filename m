From: Andreas Philipp <andreas.philipp@uni-graz.at>
Subject: Re: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Fri, 12 Jun 2009 09:47:57 +0200
Message-ID: <200906120947.58071.andreas.philipp@uni-graz.at>
References: <4A164EC9.3070405@rs.jp.nec.com> <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from HERAKLES.KFUNIGRAZ.AC.AT ([143.50.13.36]:6242 "EHLO
	herakles.kfunigraz.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZFLH63 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jun 2009 03:58:29 -0400
In-Reply-To: <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Maybe my question is stupid, but I'll post it anyway. Where can I get the 
patches for online defrag?

Thanks,
Andreas

-- 
Andreas Philipp
Institute for Mathematics and Scientific Computing
University of Graz
Heinrichstrasse 36
8010 Graz
Austria

phone: ++43 316 380 5155
e-mail: andreas.philipp@uni-graz.at
web site: http://www.uni-graz.at/~philippa/ 

On Friday 12 June 2009 01:03:32 Greg Freemyer wrote:
> Ted / Akira,
>
> What's the status of this.  I certainly like the ABI much better now
> than on the previous try.
>
> I don't know the ext4 code internally so I can't speak to the
> implementation quality, but I know this has been floating around for a
> long time and seems to just be getting better and better.
>
> Any chance of it being merged soon?
>
> Thanks
> Greg
>
> 2009/5/22 Akira Fujita <a-fujita@rs.jp.nec.com>:
> > Hi,
> >
> > There are the updated patches for ext4 online defrag.
> > I have addressed the comments that I had got about defrag V1
> > (http://marc.info/?l=linux-ext4&m=123329594919001&w=3).
> > Changes of this version are as follows:
> >
> > - Change function name from ext4_defrag_xxx to ext4_mext_xxx
> >  and also change the source file name from defrag.c to move_extent.c.
> > - Disallow swapfile defrag.
> > - Support uninitialized extent defrag.
> > - Disallow data write out for uninitalized extent.
> > - Call fget() and fput() instead of fget_light() and fput_light()
> >  for module compile.
> > - Acquire mutex and semaphore of orig and donor inodes by i_ino order.
> > - Localized semaphore acquisition/release.
> > - Add ext4_mext_inode_double_lock/unlock() for i_mutex lock/unlock,
> >  since inode_double_lock/unlock() have been removed.
> > - Replace random printk() with ext4_debug().
> > - Some cleanups.
> >
> > Ext4 online defrag uses EXT4_IOC_MOVE_EXT ioctl and move_extent
> > structure.
> >
> > #define EXT4_IOC_MOVE_EXT               _IOWR('f', 15, struct
> > move_extent)
> >
> > struct move_extent {
> >        int orig_fd;            /* original file descriptor */
> >        int donor_fd;           /* donor file descriptor */
> >        __u64 orig_start;       /* logical start offset in block for orig
> > */ __u64 donor_start;      /* logical start offset in block for donor */
> > __u64 len;              /* block length to be moved */
> >        __u64 moved_len;        /* moved block length */
> > };
> >
> >
> > Ext4 online defrag is done in the following steps:
> > (U:User space K:Kernel space)
> >
> > 1:U  Create donor inode and then call unlink() to it.
> >
> > 2:U  Allocate contiguous blocks to donor inode with fallocate().
> >
> > 3:U  Call the FS_IOC_FIEMAP ioctl to get the extents information of donor
> > inode. And check the extents of donor inode are less than the defrag
> > target inode's.
> >
> > 4:U  Call the EXT4_IOC_MOVE_EXT ioctl extent unit.
> >
> > 5:K  In kernel space, the EXT4_IOC_MOVE_EXT ioctl calls
> > ext4_mext_move_extent() to exchange the blocks between orig_fd and
> > donor_fd.
> >     Then write the file data of orig_fd to donor_fd.
> >
> > 6:U  Close donor inode, then it will be deleted.
> >
> > Note: More tests may be needed without journal,
> >      so I recommend that e4defrag is run on ext4 with journal.
> >
> > Summary of patch series:
> > * The patch can be applied to the ext4 patch queue (2.6.30-rc6).
> >
> > [PATCH 1/3] Add EXT4_IOC_DEFRAG ioctl and defrag functions
> > - Add EXT4_IOC_DEFRAG ioctl and related functions.
> > - For each page, exchange the extents between original inode
> >  and donor inode, and then write the file data of
> >  the original inode to donor inode.
> >
> > [PATCH 2/3] Ext4 online defrag command
> > - Usage is as follows:
> >  - Defrag for a single file.
> >    # e4defrag file, directory, device
> >  - Check the file fragments on ext4.
> >    # e4defrag -c file, directory, device
> >
> > [PATCH 3/3] Manpage of e4defrag
> > -  Ext4 online defrag command manpage
> >    # nroff -man e4defrag.8
> >
> > Best regards,
> > Akira Fujita
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

