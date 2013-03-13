From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Date: Wed, 13 Mar 2013 12:10:16 -0700
Message-ID: <20130313191016.GA1793@jtriplet-mobl1>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130313190141.GF5604@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 13, 2013 at 03:01:41PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 13, 2013 at 11:59:13AM -0700, Josh Triplett wrote:
> > I frequently test kernel changes by booting them with kvm's -kernel
> > option, with -hda pointing to my host system's root filesystem, and
> > -snapshot to prevent writing to (and likely corrupting) that root
> > filesystem.  I tried this with a kernel built from git commit
> > 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b, with a stock x86-64 "make
> > defconfig", and got a kernel panic:
> 
> Can you send me the output of "dumpe2fs -h" on your host system's root
> file system?

Attached.

- Josh Triplett

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dumpe2fs.log"

dumpe2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          e23a62e0-8a4a-48d0-b781-e11ae069ab06
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              17711104
Block count:              70817792
Reserved block count:     708177
Free blocks:              50350508
Free inodes:              17149541
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1007
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Jul 10 22:09:47 2012
Last mount time:          Wed Mar 13 10:19:40 2013
Last write time:          Wed Mar 13 10:19:40 2013
Mount count:              6
Maximum mount count:      27
Last checked:             Mon Mar 11 21:27:56 2013
Check interval:           15552000 (6 months)
Next check after:         Sat Sep  7 21:27:56 2013
Lifetime writes:          776 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       12845162
Default directory hash:   half_md4
Directory Hash Seed:      22edf7ec-c22c-43aa-a7ea-c3349da9a00c
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x0023bba0
Journal start:            10041


--tThc/1wpZn/ma/RB--
