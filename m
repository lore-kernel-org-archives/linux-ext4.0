From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Possible regression in e2fsprogs-1.43.4  [RESOLVED]
Date: Sun, 25 Jun 2017 22:40:19 -0400
Message-ID: <20170626024019.hni2k6uwfb7sknaw@thunk.org>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
 <20170623195318.cfs4ftpmy5nhcccy@thunk.org>
 <20170623232935.13fa4688@leda>
 <048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
 <F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Christian Hesse <list@eworm.de>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        linux-ext4@vger.kernel.org
To: Felipe A Rodriguez <far@illumenos.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41858 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751525AbdFZCkc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Jun 2017 22:40:32 -0400
Content-Disposition: inline
In-Reply-To: <F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 25, 2017 at 08:16:39PM +0200, Felipe A Rodriguez wrote:
> 
> Sysllinux chain-loading is not a factor (GRUB 2.00 still fails to
> boot w/o it).  GRUB 2.02 does resolve the issue.  The command line
> for 2.02 required a “-p” switch which 2.00 does not.  This probably
> caused an uncaught and unnoticed failure during installation in my
> previous testing.

Again, Debian is using e2fsprogs 1.43.4 and uses ext4 as the default
file system, and GRUB 2.02 as the default boot system.  No one has
complained about failures in the instsall process, and I'm pretty sure
the Debian installer team has done their usual great job in testing
and QA.  So if there was an issue in the combination of ext4,
e2fsprogs 1.43.4 and Grub 2.02 in Debian Stretch (the latest Debian
Stable, version 8.0) they would have found it.

I am also *personally* using a root file system with 64-bit feature
enabled:

# dumpe2fs -h /dev/callcc/root | grep features
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum

and the system boots just fine on GRUB 2.02.  So it seems to work for
everyone who is using the Debian Installer to install a default setup
using the latest Debian Stable Release.  My personal setup involves
using the UEFI boot loader (grubx64.efi) installed as the default
bootloader.  (e.g., as /EFI/BOOTX64.EFI).

I'm also using a fairly complex setup, with both dm-crypt (LUKS) and
LVM, so the output of lsblk looks like this on my laptop


NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0  1.9T  0 disk
├─sda1                    8:1    0  480M  0 part  <--- EFI VFAT partition
└─sda2                    8:2    0  1.9T  0 part
  └─callcc_crypt        254:0    0  1.9T  0 crypt
      ├─callcc-root       254:1    0  326G  0 lvm   /
	...

It doesn't get any much more complex than this, and it Just Works.
About the only annoying thing is that I have to type my decryption
password twice.  Once to grub, so it can read the LUKS partition, then
find the root partition Logical Volume, and the read the kernel and
initramfs, and the after the kernel boots and initramfs is loaded, I
have to type the password to initramfs a second time so Linux can
unlock the LUKS partition and then mount the root partition.

So when you say that enabling the 64-bit file system feature causes a
regression by causing Grub to fail to be able to read the root file
system, I have to respectfully disagree.  I do it all the time when I
reboot my kernel, and it Works For Me...

						- Ted
