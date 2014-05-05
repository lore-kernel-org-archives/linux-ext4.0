From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 16:51:25 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain> <20140505140401.GD22287@thunk.org> <20140505142808.GF22287@thunk.org>
 <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain> <20140505144423.GG22287@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-507638579-1399301491=:2223"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kzak@redhat.com,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140505144423.GG22287@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-507638579-1399301491=:2223
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon, 5 May 2014 10:44:23 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kzak@redhat.com,
>     linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
>     ext2/3/4 file systems
> 
> On Mon, May 05, 2014 at 04:38:37PM +0200, Lukáš Czerner wrote:
> > > % ./misc/mke2fs -t ext4 /dev/sdc3
> > > mke2fs 1.42.9 (4-Feb-2014)
> > > /dev/sdc3 contains a ext4 file system
> > > 	last mounted on /SOX-backups on Mon May  5 08:59:53 2014
> > > Proceed anyway? (y,n) 
> > > 
> > > ... where this becomes a last-ditch saving through against the
> > > accidental wiping of the enterprise's Sarbanes-Oxley records.  :-)
> > > 
> > 
> > Yep, it's really useful. I just was not sure what is this all about since
> > there was not description and I was missing context from the other patches.
> > 
> > But this makes me think that it would be very useful if blkid could
> > gather this information for other file system if possible :). This
> > might be very useful if we can get some overlap with other file
> > system with the information provided in superblock.
> 
> Unfortunately, as far as I know, none of the other file systems
> currently save the location where the file system was last mounted.
> And to be honest, the way we do it in ext4 is a horrible hack (get out
> your barf bags!):
> 
> static int ext4_file_open(struct inode * inode, struct file * filp)
> {
> 	struct super_block *sb = inode->i_sb;
> 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> 	struct vfsmount *mnt = filp->f_path.mnt;
> 	struct path path;
> 	char buf[64], *cp;
> 
> 	if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
> 		     !(sb->s_flags & MS_RDONLY))) {
> 		sbi->s_mount_flags |= EXT4_MF_MNTDIR_SAMPLED;
> 		/*
> 		 * Sample where the filesystem has been mounted and
> 		 * store it in the superblock for sysadmin convenience
> 		 * when trying to sort through large numbers of block
> 		 * devices or filesystem images.
> 		 */
> 		memset(buf, 0, sizeof(buf));
> 		path.mnt = mnt;
> 		path.dentry = mnt->mnt_root;
> 		cp = d_path(&path, buf, sizeof(buf));
> 		...
> 
> What we would need to do is file a feature request in the other file
> systems to save this information, and then add proper support for to
> pass this information from the VFS layer into the struct
> super_operations's mount function, which would be the proper, sane way
> to provide this functionality.
> 
> 						- Ted

Which would be reasonable if there was a consumer of such
information and it seemed to be useful. So I wonder what other
people think about that.

Karel, you had some suggestions about how to utilize that aside from
the mkfs...

-Lukas
--8323328-507638579-1399301491=:2223--
