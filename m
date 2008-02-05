From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 9855] ext3 ACL corruption
Date: Mon, 04 Feb 2008 18:06:18 -0700
Message-ID: <20080205010617.GL23836@webber.adilger.int>
References: <1201771074.4480.2.camel@kulgan.wumi.org.au>
 <20080131100539.GQ23836@webber.adilger.int>
 <1201781664.4480.16.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	bugme-daemon@bugzilla.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42158 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbYBEBGY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 20:06:24 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1516LtL021217
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 17:06:22 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVQ00F01R2KSK00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 04 Feb 2008 17:06:21 -0800 (PST)
In-reply-to: <1201781664.4480.16.camel@kulgan.wumi.org.au>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 31, 2008  22:44 +1030, Kevin Shanahan wrote:
> On Thu, 2008-01-31 at 03:05 -0700, Andreas Dilger wrote:
> > ...  To get the interesting bits you need:
> > 
> > debugfs: stat <966665>   # prints decoded inode, "File ACL:" is a block number
> > debugfs: imap <966665>   # prints inode block number, offset
> > 
> > dd if=/dev/mapper/vg_main-lv_samba of=/tmp/inode.bin bs=4k count=1 skip={iblock}
> > dd if=/dev/mapper/vg_main-lv_samba of=/tmp/inode.bin bs=4k count=1 skip={ACLblk}
> 
> Ah, ok - learning fast. Lets see how I go this time:
> 
> # debugfs /dev/mapper/vg_main-lv_samba
> debugfs:  stat <3342652>
> 
> Inode: 3342652   Type: regular    Mode:  0770   Flags: 0x0   Generation: 3684645243
> User:     0   Group: 10140   Size: 18432
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 40
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x475be06e -- Sun Dec  9 23:02:46 2007
> atime: 0x475d4073 -- Tue Dec 11 00:04:43 2007
> mtime: 0x45d2686a -- Wed Feb 14 12:09:54 2007
> Size of extra inode fields: 4
> Extended attributes stored in inode body: 
>    = "01 00 00 00 01 00 07 00 04 00 05 00 08 00 05 00 d6 27 00 00 08 00 07 00 09 28 00 00 08 00 07 00 0a 28 00 00 10 00 07 00 20 00 00 00 " (44)
>   DOSATTRIB = "0x20" (4)
> BLOCKS:
> (0):6713397, (1):6713399, (2):6713395, (3):6713405, (4):6713396
> TOTAL: 5
> 
> debugfs:  imap <3342652>
> Inode 3342652 is part of block group 204
>       located at block 6684693, offset 0x0b00

The hexdump of this data (od -Ax -tx4 -a) shows the EA is in good shape:

000b80 00000004        ea020000        00480200        00000000
       eot nul nul nul nul nul stx   j nul stx   H nul nul nul nul nul

inode.i_extra_isize=0x0004
ext3_xattr_ibody_header.h_magic=0xea020000

[EA1 entry]
ext3_xattr_entry.e_name_len=0x00  (unused for POSIX_ACL_ACCESS)
ext3_xattr_entry.e_name_index=0x02 (EXT3_INDEX_POSIX_ACL_ACCESS)
ext3_xattr_entry.e_value_offs=0x0048 = 72
ext3_xattr_entry.e_value_block=0x00000000  (unused)



000b90 0000002c        00000000        00740109        00000000
         , nul nul nul nul nul nul nul  ht soh   t nul nul nul nul nul
[EA1 cont.]
ext3_xattr_entry.e_value_size=0x0000002c = 44
ext3_xattr_entry.e_hash=0x00000000  (currently unused)

[EA2 entry]
ext3_xattr_entry.e_name_len=0x09
ext3_xattr_entry.e_name_index=0x01 (EXT3_INDEX_USER)
ext3_xattr_entry.e_value_offs=0x0074 = 116
ext3_xattr_entry.e_value_block=0x00000000  (unused)

000ba0 00000004        00000000        41534f44        49525454
       eot nul nul nul nul nul nul nul   D   O   S   A   T   T   R   I
[EA2 cont.]
ext3_xattr_entry.e_value_size=0x0000002c = 44
ext3_xattr_entry.e_hash=0x00000000  (currently unused)
ext3_xattr_entry.e_name=DOSATTRIB

000bb0 00000042        00000000        00000000        00000000
         B nul nul nul nul nul nul nul nul nul nul nul nul nul nul nul
000bc0 00000000        00000000        00000000        00000000
       nul nul nul nul nul nul nul nul nul nul nul nul nul nul nul nul

000bd0 00000001        00070001        00050004        00050008
       soh nul nul nul soh nul bel nul eot nul enq nul  bs nul enq nul
[EA1 data]
ext3_acl_header.a_version=0x00000001
ext3_acl_entry_short[0].e_tag=0x0001
ext3_acl_entry_short[0].e_perm=0x0007
ext3_acl_entry_short[1].e_tag=0x0004
ext3_acl_entry_short[1].e_perm=0x0005
ext3_acl_entry_short[2].e_tag=0x0008
ext3_acl_entry_short[2].e_perm=0x0005

000be0 000027d6        00070008        00002809        00070008
         V   ' nul nul  bs nul bel nul  ht   ( nul nul  bs nul bel nul
[EA1 data cont]
ext3_acl_entry_short[2].e_id=0x27d6
ext3_acl_entry[3].e_tag=0x0008
ext3_acl_entry[3].e_perm=0x0007
ext3_acl_entry[3].e_id=0x00002809

ext3_acl_entry[5].e_tag=0x0008
ext3_acl_entry[5].e_perm=0x0007
ext3_acl_entry[5].e_id=0x0000280a

000bf0 0000280a        00070010        00000020        30327830
        nl   ( nul nul dle nul bel nul  sp nul nul nul   0   x   2   0
[EA1 data cont]
ext3_acl_entry[6].e_tag=0x0010
ext3_acl_entry[6].e_perm=0x0007
ext3_acl_entry[6].e_id=0x00000020

[EA2 data]
"0x20"

> I'm assuming that "File ACL: 0" means that there's no ACL block.

Right.

> e2fsck 1.40-WIP (14-Nov-2006)
> Pass 1: Checking inodes, blocks, and sizes
> (entry->e_value_offs + entry->e_value_size: 116, offs: 120)
> Extended attribute in inode 3342652 has a value offset (72) which is
> invalid
> Clear? no
> ...

Hmm, I wonder if e2fsck is calculating the wrong file offset or something?
The kernel appears to be taking the EA data offset from the end of
i_extra_isize and the ext3_xattr_ibody_header fields (so 0x88 + e_value_offs
from the start of the inode).

Conversely, debugfs isn't having any problem with this EA at all.

h, I think I see the problem, and this was fixed in newer e2fsck.
The EAs are stored "out of order" in the inode and older e2fsprogs
considered that an error.  That was fixed in the final 1.40 release:

	Remove check in e2fsck which requires EA's in inodes to be sorted;
	they don't need to be sorted, and e2fsck was previously wrongly
	clearing unsorted EA's stored in the inode structure.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
