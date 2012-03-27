From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2: clear BG_BLOCK_UNINIT in any group containing
 metadata
Date: Tue, 27 Mar 2012 15:40:32 -0700
Message-ID: <20120327224032.GE11236@thunk.org>
References: <4F46835F.5080009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48414 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2C0Wkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 18:40:39 -0400
Content-Disposition: inline
In-Reply-To: <4F46835F.5080009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 23, 2012 at 12:20:15PM -0600, Eric Sandeen wrote:
> Running a test like the m_uninit test runs:
> 
> # mke2fs -F -o Linux -O uninit_bg testfs 131072
> 
> results in groups which have blocks allocated for metadata, but
> which still have the BLOCK_UNINIT flag set:
> 
> Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
>   Checksum 0x17c2, unused inodes 2048
>   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
>   Inode table at 16387-16642 (+2)

Sorry for the delay in getting back to you.  The general rule here is
what triggers BLOCK_UNINIT getting cleared is when we allocate
metadata blocks for *another* block group in that block group.  When
we initialize an uninitialized block group, it's easy enough to set
the bits for the block group's allocation bitmaps and inode tables.

However, we *don't* want to have to scan all of the block groups to
see if they have metadata blocks appearing in a particular block
group, so that's the reason for this rule.

So in the above dumpe2fs output, since we aren't using flex_bg, the
only metadata blocks which are in a bg is the bg's own metadata
blocks, and so that's why it's OK for BLOCK_UNINIT to be set.  This
isn't a bug.

					- Ted
