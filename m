From: "Sachin P. Sant" <sachinp@in.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Tue, 24 Feb 2009 12:08:37 +0530
Message-ID: <49A395ED.5030607@in.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <20090223021320.11019d64.akpm@linux-foundation.org> <18850.31567.212454.514549@cargo.ozlabs.ibm.com> <20090223155116.GB5764@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@ucw.cz>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43238 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZBXGir (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 01:38:47 -0500
In-Reply-To: <20090223155116.GB5764@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Hmm, OK. But then I'm not sure how that can happen. Obviously, memcpy
> somehow got beyond end of the page referenced by bh->b_data. So it means
> that le16_to_cpu(entry->e_value_offs) + size > page_size. But
> ext3_xattr_find_entry() calls ext3_xattr_check_entry() which in
> particular checks whether e_value_offs + e_value_size isn't greater than
> bh->b_size. So I see no way how memcpy can get beyond end of the page.
>   Sachin, is the problem reproducible? If yes, can you send us contents
>   
Yes, i am able to recreate this problem easily. As i had mentioned if the
earlier kernel is booted with selinux enabled and then 2.6.29-rc6 is booted
i get this crash. But if i specify selinux=0 at command line, 2.6.29-rc6 boots
without any problem.

> of the page just before the faulting address (i.e., for current fault it
> would be 0xc00000003f370000-0xc00000003f37ffff). As far as I can
> remember powerpc monitor could dump it.
>   
Here is the page dump. This time it crashed while accessing address
0xc00000002d670000.

 Unable to handle kernel paging request for data at address 0xc0000
0002d670000
Faulting instruction address: 0xc000000000039574
cpu 0x1: Vector: 300 (Data Access) at [c00000004288b0b0]
    pc: c000000000039574: .memcpy+0x74/0x244
    lr: c0000000001b497c: .ext3_xattr_get+0x288/0x2f4
    sp: c00000004288b330
   msr: 8000000000009032

1:mon> d 0xc00000002d660000
............................... <SNIP> ...............................

c00000002d66efd0 0000000000000000 0000000000000000  |................|
c00000002d66efe0 0000000000000000 0000000000000000  |................|
c00000002d66eff0 0000000000000000 0000000000000000  |................|
c00000002d66f000 000002ea00040000 01000000e200d20a  |................|
c00000002d66f010 0000000000000000 0000000000000000  |................|
c00000002d66f020 0706e40f00000000 1b000000e200d20a  |................|
c00000002d66f030 73656c696e757800 0000000000000000  |selinux.........|
c00000002d66f040 0000000000000000 0000000000000000  |................|
c00000002d66f050 0000000000000000 0000000000000000  |................|
c00000002d66f060 0000000000000000 0000000000000000  |................|

............................... <SNIP> ...............................

c00000002d66ff60 0000000000000000 0000000000000000  |................|
c00000002d66ff70 0000000000000000 0000000000000000  |................|
c00000002d66ff80 0000000000000000 0000000000000000  |................|
c00000002d66ff90 0000000000000000 0000000000000000  |................|
c00000002d66ffa0 0000000000000000 0000000000000000  |................|
c00000002d66ffb0 0000000000000000 0000000000000000  |................|
c00000002d66ffc0 0000000000000000 0000000000000000  |................|
c00000002d66ffd0 0000000000000000 0000000000000000  |................|
c00000002d66ffe0 0000000073797374 656d5f753a6f626a  |....system_u:obj|
c00000002d66fff0 6563745f723a7573 725f743a73300000  |ect_r:usr_t:s0..|
c00000002d670000 **************** ****************  |                |
1:mon> r
R00 = 000000000000e40f   R16 = 000000000000005d
R01 = c00000004288b330   R17 = 0000000000000000
R02 = c0000000009f59b8   R18 = 00000000fffbfe9e
R03 = c000000044aa34a0   R19 = 0000000010042638
R04 = c00000002d66fff4   R20 = 0000000010041610
R05 = 0000000000000003   R21 = 00000000000000ff
R06 = 0000000000000000   R22 = 0000000000000006
R07 = 0000000000000001   R23 = c0000000007d27c1
R08 = 723a7573725f743a   R24 = c00000002c0cd758
R09 = 3a6f626a6563745f   R25 = c000000044aa3488
R10 = c00000000017b43c   R26 = c00000002c0cd6f0
R11 = c00000002d66f020   R27 = c00000002c0cd860
R12 = d0000000023c14b0   R28 = c00000002c0b0840
R13 = c000000000a93680   R29 = 000000000000001b
R14 = 00000000000041ed   R30 = c0000000009880b0
R15 = 0000000010040000   R31 = ffffffffffffffde
pc  = c000000000039574 .memcpy+0x74/0x244
lr  = c0000000001b497c .ext3_xattr_get+0x288/0x2f4
msr = 8000000000009032   cr  = 4400044b
ctr = 0000000000000000   xer = 0000000020000001   trap =  300
dar = c00000002d670000   dsisr = 40000000
1:mon> zr

>   BTW, I suppose you use 4KB blocksize on the filesystem, right?
>   
Yes.

dumpe2fs /dev/sda3 | grep -i "block size" 
dumpe2fs 1.39 (29-May-2006)
Block size:               4096

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

