From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Thu, 11 Jun 2009 19:03:32 -0400
Message-ID: <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
References: <4A164EC9.3070405@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4A164EC9.3070405@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted / Akira,

What's the status of this.  I certainly like the ABI much better now
than on the previous try.

I don't know the ext4 code internally so I can't speak to the
implementation quality, but I know this has been floating around for a
long time and seems to just be getting better and better.

Any chance of it being merged soon?

Thanks
Greg

2009/5/22 Akira Fujita <a-fujita@rs.jp.nec.com>:
> Hi,
>
> There are the updated patches for ext4 online defrag.
> I have addressed the comments that I had got about defrag V1
> (http://marc.info/?l=3Dlinux-ext4&m=3D123329594919001&w=3D3).
> Changes of this version are as follows:
>
> - Change function name from ext4_defrag_xxx to ext4_mext_xxx
> =A0and also change the source file name from defrag.c to move_extent.=
c.
> - Disallow swapfile defrag.
> - Support uninitialized extent defrag.
> - Disallow data write out for uninitalized extent.
> - Call fget() and fput() instead of fget_light() and fput_light()
> =A0for module compile.
> - Acquire mutex and semaphore of orig and donor inodes by i_ino order=
=2E
> - Localized semaphore acquisition/release.
> - Add ext4_mext_inode_double_lock/unlock() for i_mutex lock/unlock,
> =A0since inode_double_lock/unlock() have been removed.
> - Replace random printk() with ext4_debug().
> - Some cleanups.
>
> Ext4 online defrag uses EXT4_IOC_MOVE_EXT ioctl and move_extent struc=
ture.
>
> #define EXT4_IOC_MOVE_EXT =A0 =A0 =A0 =A0 =A0 =A0 =A0 _IOWR('f', 15, =
struct move_extent)
>
> struct move_extent {
> =A0 =A0 =A0 =A0int orig_fd; =A0 =A0 =A0 =A0 =A0 =A0/* original file d=
escriptor */
> =A0 =A0 =A0 =A0int donor_fd; =A0 =A0 =A0 =A0 =A0 /* donor file descri=
ptor */
> =A0 =A0 =A0 =A0__u64 orig_start; =A0 =A0 =A0 /* logical start offset =
in block for orig */
> =A0 =A0 =A0 =A0__u64 donor_start; =A0 =A0 =A0/* logical start offset =
in block for donor */
> =A0 =A0 =A0 =A0__u64 len; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* block length =
to be moved */
> =A0 =A0 =A0 =A0__u64 moved_len; =A0 =A0 =A0 =A0/* moved block length =
*/
> };
>
>
> Ext4 online defrag is done in the following steps:
> (U:User space K:Kernel space)
>
> 1:U =A0Create donor inode and then call unlink() to it.
>
> 2:U =A0Allocate contiguous blocks to donor inode with fallocate().
>
> 3:U =A0Call the FS_IOC_FIEMAP ioctl to get the extents information of=
 donor inode.
> =A0 =A0 And check the extents of donor inode are less than the defrag=
 target inode's.
>
> 4:U =A0Call the EXT4_IOC_MOVE_EXT ioctl extent unit.
>
> 5:K =A0In kernel space, the EXT4_IOC_MOVE_EXT ioctl calls ext4_mext_m=
ove_extent()
> =A0 =A0 to exchange the blocks between orig_fd and donor_fd.
> =A0 =A0 Then write the file data of orig_fd to donor_fd.
>
> 6:U =A0Close donor inode, then it will be deleted.
>
> Note: More tests may be needed without journal,
> =A0 =A0 =A0so I recommend that e4defrag is run on ext4 with journal.
>
> Summary of patch series:
> * The patch can be applied to the ext4 patch queue (2.6.30-rc6).
>
> [PATCH 1/3] Add EXT4_IOC_DEFRAG ioctl and defrag functions
> - Add EXT4_IOC_DEFRAG ioctl and related functions.
> - For each page, exchange the extents between original inode
> =A0and donor inode, and then write the file data of
> =A0the original inode to donor inode.
>
> [PATCH 2/3] Ext4 online defrag command
> - Usage is as follows:
> =A0- Defrag for a single file.
> =A0 =A0# e4defrag file, directory, device
> =A0- Check the file fragments on ext4.
> =A0 =A0# e4defrag -c file, directory, device
>
> [PATCH 3/3] Manpage of e4defrag
> - =A0Ext4 online defrag command manpage
> =A0 =A0# nroff -man e4defrag.8
>
> Best regards,
> Akira Fujita
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
