From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Mon, 23 Feb 2009 02:13:20 -0800
Message-ID: <20090223021320.11019d64.akpm@linux-foundation.org>
References: <49A2705D.9030008@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
	linuxppc-dev@ozlabs.org, Jan Kara <jack@ucw.cz>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZBWKNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 05:13:48 -0500
In-Reply-To: <49A2705D.9030008@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 Feb 2009 15:16:05 +0530 "Sachin P. Sant" <sachinp@in.ibm.com> wrote:

> 2.6.29-rc6 bootup on a powerpc box failed with
> 
> Unable to handle kernel paging request for data at address 0xc00000003f380000
> Faulting instruction address: 0xc000000000039574
> cpu 0x1: Vector: 300 (Data Access) at [c00000003baf3020]
>     pc: c000000000039574: .memcpy+0x74/0x244
>     lr: d00000000244916c: .ext3_xattr_get+0x288/0x2f4 [ext3]
>     sp: c00000003baf32a0
>    msr: 8000000000009032
>    dar: c00000003f380000
>  dsisr: 40000000
>   current = 0xc00000003e54b010
>   paca    = 0xc000000000a53680
>     pid   = 1840, comm = readahead
> enter ? for help
> [link register   ] d00000000244916c .ext3_xattr_get+0x288/0x2f4 [ext3]
> [c00000003baf32a0] d000000002449104 .ext3_xattr_get+0x220/0x2f4 [ext3]
> (unreliab
> le)
> [c00000003baf3390] d00000000244a6e8 .ext3_xattr_security_get+0x40/0x5c [ext3]
> [c00000003baf3400] c000000000148154 .generic_getxattr+0x74/0x9c
> [c00000003baf34a0] c000000000333400 .inode_doinit_with_dentry+0x1c4/0x678
> [c00000003baf3560] c00000000032c6b0 .security_d_instantiate+0x50/0x68
> [c00000003baf35e0] c00000000013c818 .d_instantiate+0x78/0x9c
> [c00000003baf3680] c00000000013ced0 .d_splice_alias+0xf0/0x120
> [c00000003baf3720] d00000000243e05c .ext3_lookup+0xec/0x134 [ext3]
> [c00000003baf37c0] c000000000131e74 .do_lookup+0x110/0x260
> [c00000003baf3880] c000000000134ed0 .__link_path_walk+0xa98/0x1010
> [c00000003baf3970] c0000000001354a0 .path_walk+0x58/0xc4
> [c00000003baf3a20] c000000000135720 .do_path_lookup+0x138/0x1e4
> [c00000003baf3ad0] c00000000013645c .path_lookup_open+0x6c/0xc8
> [c00000003baf3b70] c000000000136780 .do_filp_open+0xcc/0x874
> [c00000003baf3d10] c0000000001251e0 .do_sys_open+0x80/0x140
> [c00000003baf3dc0] c00000000016aaec .compat_sys_open+0x24/0x38
> [c00000003baf3e30] c00000000000855c syscall_exit+0x0/0x40
> --- Exception: c01 (System Call) at 000000000ff0ef18
> SP (ffc6f4b0) is in userspace
> 1:mon>
> 
> Following EXT3 related options were enabled in the config.
> 
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> 

hm, I wonder what could have caused that - we haven't altered
fs/ext3/xattr.c in ages.

What is the most recent kernel version you know of which didn't do
this?  Bear in mind that this crash might be triggered by the
current contents of the filesystem, so if possible, please test
some other kernel versions on that disk.

It looks like we died in ext3_xattr_block_get():

		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
		       size);

Perhaps entry->e_value_offs is no good.  I wonder if the filesystem is
corrupted and this snuck through the defenses.

I also wonder if there is enough info in that trace for a ppc person to
be able to determine whether the faulting address is in the source or
destination of the memcpy() (please)?

