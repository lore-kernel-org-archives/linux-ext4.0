From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Date: Mon, 7 May 2007 15:53:10 +0200
Message-ID: <20070507135309.GA32476@janus>
References: <20070506222626.GA25632@janus> <20070506214014.8b7451ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934014AbXEGNxP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070506214014.8b7451ba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 06, 2007 at 09:40:14PM -0700, Andrew Morton wrote:
> On Mon, 7 May 2007 00:26:26 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:
> 
> > Steps to reproduce:
> > Create a 3G partition, say /dev/vol1/project
> > mke2fs -j -b 4096 /dev/vol1/project 22812
> > mount it
> > ext2online /dev/vol1/project said:
> > 
> > | ext2online v1.1.18 - 2001/03/18 for EXT2FS 0.5b
> > | ext2online: ext2_ioctl: No space left on device
> > | 
> > | ext2online: unable to resize /dev/mapper/vol1-project
> > 
> > kernel said:
> > 
> > | JBD: ext2online wants too many credits (721 > 256)

There's a threshold for the problem depending on the initial
size. This one fails:

	mke2fs -j -b 4096 /dev/<3GB-blockdev> 32768
	(mount + ext2online or resize2fs)
	kernel: JBD: resize2fs wants too many credits (1034 > 1024)

Add one block to the initial mke2fs (32768+1 == 32769) and the
problem is gone.

Without the -b 4096 there's another resize problem

	mke2fs -j /dev/loop1 2048
	mount /dev/loop1 /1
	resize2fs /dev/loop1

says:
	resize2fs 1.40-WIP (14-Nov-2006)
	Filesystem at /dev/loop1 is mounted on /1; on-line resizing required
	old desc_blocks = 1, new_desc_blocks = 12
	Performing an on-line resize of /dev/loop1 to 3072000 (1k) blocks.
	resize2fs: Invalid argument While trying to add group #256

and the kernel says:

May  7 15:36:08 lokka EXT3-fs warning (device loop1): verify_reserved_gdb: 
May  7 15:36:08 lokka reserved GDT 10 missing grp 1 (8202)
May  7 15:36:08 lokka  

After that, the filesystem has been resized to 2GB. I recall a 2G
(?) limit for ext3 resizing with 1k blocksize but trying the above with
4096 1k blocks seems to work. fsck says it's ok all the time.

-- 
Frank
