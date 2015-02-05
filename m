From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] ext4: fix indirect punch hole corruption
Date: Thu, 5 Feb 2015 12:56:01 -0800
Message-ID: <20150205205601.GA5205@mew>
References: <cf81509853ecdbef7d738d8d39abe786f41193ec.1423169101.git.osandov@osandov.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Cc: Chris J Arges <chris.j.arges@canonical.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf81509853ecdbef7d738d8d39abe786f41193ec.1423169101.git.osandov@osandov.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 05, 2015 at 12:50:13PM -0800, Omar Sandoval wrote:
> Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
> mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
> mapping. However, the case where the punch happens within one level of
> indirection is incorrect. It assumes that the partial branches returned
> from ext4_find_shared will have the same depth, but this is not
> necessarily the case even when the offsets have the same depth. For
> example, if the last block occurs at the beginning of an indirect group
> (i.e., it has an offset of 0 at the end of the offsets array), then
> ext4_find_shared will return a shallower chain. So, let's handle the
> mismatch and clean up that case. Tested with generic/270, which no
> longer leads to an inconsistent filesystem like before.
> 
Ah, forgot to mention that this applies to v3.19-rc7. Additionally,
I've attached a script which reproduces the issue. You can run
xfs_io -c fiemap "$FILE" (after an umount/mount of the filesystem just
be safe) and see that before the fix, a bunch of blocks get swallowed:

/mnt/scratch/test:
        0: [0..31]: 1026..1057
        1: [32..127]: 930..1025
        2: [128..255]: 2114..2241
        3: [256..511]: 2306..2561
        4: [512..535]: 2818..2841
        5: [536..1559]: hole

... but after the fix, the hole is in the right place:

/mnt/scratch/test:
        0: [0..31]: 1026..1057
        1: [32..127]: 930..1025
        2: [128..255]: 2114..2241
        3: [256..511]: 2306..2561
        4: [512..791]: 2818..3097
        5: [792..1047]: hole
        6: [1048..1559]: 4122..4633

(These examples are from a 1k-block ext3 filesystem with
CONFIG_EXT4_USE_FOR_EXT23=y).

-- 
Omar

--J/dobhs11T7y2rNN
Content-Type: application/x-sh
Content-Disposition: attachment; filename="ext4punch.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0Aset -e=0A=0Aif [ $# -ne 2 ]; then=0A	echo "Usage: $0 FILE BL=
OCK_SIZE" >&2=0A	exit 1=0Afi=0A=0AFILE=3D"$1"=0ABLOCK_SIZE=3D"$2"=0A=0ANDIR=
=3D12=0AADDRS=3D$(($BLOCK_SIZE / 4))=0A=0A# Fill up the direct blocks and i=
ndirect block, plus two indirect blocks in the=0A# first doubly-indirect bl=
ock.=0Add if=3D/dev/zero of=3D"$FILE" bs=3D"$BLOCK_SIZE" count=3D$(($NDIR +=
 3 * $ADDRS))=0A=0A# Punch a hole from the middle of the first indirect blo=
ck in the=0A# doubly-indirect block to the beginning of the second indirect=
 block.=0Afallocate -p -o $(($BLOCK_SIZE * ($NDIR + $ADDRS + $ADDRS / 2))) =
-l $((BLOCK_SIZE * ($ADDRS / 2))) "$FILE"=0A
--J/dobhs11T7y2rNN--
