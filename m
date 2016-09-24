From: Nix <nix@esperi.org.uk>
Subject: Trouble mounting metadata_csum ext4 filesystems with v4.7.x after c9274d891869880648c4ee9365df3ecc7ba2e285: not enough inode bytes checksummed?
Date: Sat, 24 Sep 2016 21:20:34 +0100
Message-ID: <877fa1yrql.fsf@esperi.org.uk>
References: <87zin42crs.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: daeho.jeong@samsung.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:42334 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964852AbcIXVZF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Sep 2016 17:25:05 -0400
In-Reply-To: <87zin42crs.fsf@esperi.org.uk> (nix@esperi.org.uk's message of
        "Mon, 19 Sep 2016 15:19:03 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Resent with a few more people Cc:ed in and email addresses corrected,
 since I made the mistake of using the addresses on the original
 commits, which are in some cases no longer valid or simply the wrong
 list entirely.]

So I ran into spurious metadata corruption warnings in v4.7.2 due to the
problem fixed by c9274d8. I applied an early version of the fix,
rebooted, and oh dear root filesystem mount failure with invalid
checksum errors.

The problem persists in v4.7.4, as seen here in qemu emulation on a raw
image dd'ed directly from the thing that won't boot, with a couple of
printk()s:

# mount /dev/vda /new-root/
[    8.124692] EXT4-fs (vda): couldn't mount as ext3 due to feature incompatibilities
[    8.126977] EXT4-fs (vda): couldn't mount as ext2 due to feature incompatibilities
[    9.017980] Inode size 256 > good old size 128; fits in inode: 0
[    8.134897] inode 8: provided: 5c50l; calculated: 36e1i
[    8.135098] EXT4-fs error (device vda): ext4_iget:4479: inode #8: comm mount: checksum invalid
[    8.138992] EXT4-fs (vda): no journal found
[    8.165744] UDF-fs: warning (device vda): udf_fill_super: No partition found (2)
mount: mounting /dev/vda on /new-root/ failed: Invalid argument

I added a bit of printking to show the failure of the journal inode
checksum to pass muster. e2fsck (from e2fsprogs 1.43.1-14) is quite
happy with this filesystem. Reverting c9274d8 makes everything happy
again (well, it does bring the original bug back, which is a rather
serious one, but other than that...):

[    9.823032] EXT4-fs (vda): couldn't mount as ext3 due to feature incompatibilities
[    9.824647] EXT4-fs (vda): couldn't mount as ext2 due to feature incompatibilities
[    9.832593] inode 8: provided: 5c50l; calculated: 5c50i
[    9.839253] inode 2: provided: d6ea92e9l; calculated: d6ea92e9i
[    9.846947] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts: (null)

So c9274d8 is clearly messing up the calculation of the checksum.

The problem becomes more evident if we add more printk()s to the old
code, so we can see what region is being checksummed:

# mount /dev/vda /new-root
[    6.827297] inode 8: unadjusted csum of 256 bytes with seed a5df92a7: 449a5c50
[    6.827596] adjusted csum: 5c50
[    6.835993] inode 2: unadjusted csum of 256 bytes with seed 759c6c33: d6ea92e9
[    6.836173] adjusted csum: d6ea92e9
[    6.844801] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts:

and the new:

[   11.098013] inode 8: csum of first 124 bytes with seed a5df92a7: f375b663
[   11.098205] inode 8: added csum of 2 dummy_csum bytes with seed a5df92a7: 20cfebcb
[   11.098420] inode 8: added csum of 2 bytes from offset 126 -- 128 to existing: d79e7432
[   11.098646] inode 8: > GOOD_OLD_INODE_SIZE; added csum of 2 bytes from 128 -- 130 to existing: d10936e1
[   11.098890] 8: adjusted csum: 36e1
[   11.099133] EXT4-fs error (device vda): ext4_iget:4483: inode #8: comm mount: checksum invalid

We are not checksumming enough bytes! We used to checksum the entire
256-byte inode: now, we checksum only 130 bytes of it, which isn't even
enough to cover the 28-byte extra_isize on this filesystem and is more
or less guaranteed to give the wrong answer. I'd fix the problem, but I
frankly can't see how the new code is meant to be equivalent to the old
code in any sense -- most particularly what the stuff around dummy_csum
is meant to do -- so I thought it better to let the people who wrote it
fix it :)

tune2fs output for this filesystem, particularly the extra_isize and
inode size fields are likely relevant:

tune2fs 1.43.1 (08-Jun-2016)
Filesystem volume name:   root
Last mounted on:          /
Filesystem UUID:          6c0f7fa7-d6c2-4054-bff3-3a878460bdc7
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536
Block count:              262144
Reserved block count:     13107
Free blocks:              227009
Free inodes:              59499
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      63
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stripe width:        16
Flex block group size:    64
Filesystem created:       Tue May 26 21:28:46 2009
Last mount time:          Sun Sep 18 23:34:41 2016
Last write time:          Mon Sep 19 13:51:59 2016
Mount count:              0
Maximum mount count:      36
Last checked:             Mon Sep 19 13:51:59 2016
Check interval:           15552000 (6 months)
Next check after:         Sat Mar 18 12:51:59 2017
Lifetime writes:          16 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      f1da2da0-057e-4ba0-a021-3d56db5b24ab
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x92acf115

This is an old, upgraded fs from before the days of checksums, but even
so I'm surprised that with a 256-byte inode and no xattrs in use,
EXT4_FITS_IN_INODE is false. Maybe the extra_isize isn't big enough?

An lzipped e2image of the problematic filesystem is available from
<http://www.esperi.org.uk/~nix/temporary/csum-corruption.img.lz>:
I have verified that the problem recurs with this image.

I can also replicate the problem in literally seconds if you need more
debugging output.


... The mystery is why this isn't going wrong anywhere else: I have
metadata_csum working on every fs on a bunch of other ext4-using
systems, and indeed on every filesystem on this machine as well, as long
as c9274d8 is not applied. Many of them are similarly upgraded pre-csum
fses with the same inode size and extra_isize, but they work...
