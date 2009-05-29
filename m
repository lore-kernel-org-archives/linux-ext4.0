From: Nix <nix@esperi.org.uk>
Subject: 2.6.30rc7, ext4: 'inodes that were part of a corrupted orphan list found'
Date: Fri, 29 May 2009 20:59:13 +0100
Message-ID: <87eiu71y0e.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760524AbZE2T7X@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is with a brand new machine, atop a hardware RAID-5 array (Areca
1210 battery-backed with four 1Tb disks), running a 32-bit kernel and
userspace (albeit on a recent Xeon). After a clean shutdown of an ext4
filesystem mounted with "defaults,usrquota,grpquota,nodev,relatime,
journal_async_commit,commit=30,user_xattr,acl" and mkfsed with '-t ext4 -G 64',
I got this at restart:

src: recovering journal
src: Journal transaction 1442 was corrupt, replay was aborted.
src contains a file system with errors, check forced.
Inodes that were part of a corrupted orphan linked list found.

src: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)

Yesterday, I did a bunch of GCC bootstraps on this drive, culminating in
removing the objdirs; e2fsck gave us saw a heap of complaints:

Entry 'cd5011e.ada' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585817.
Entry 'cd5014k.ada' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585820.
Entry 'cd30004.a' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585814.

(and so on for several thousand files, most of the files in the deleted
objdir).

>From the nature of some of the files deleted, it looks like it was at
least the most recent objdir rm which didn't fully happen (possibly this
was the corrupted journal transaction?)

The machine has ECCRAM and the array is on PCIe, so I think we can
consider bad RAM or a messed-up bus transaction to be low probabilities.


(An image of this FS in corrupt state has been preserved, but it's
100Gb...)
