From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 1/3] Add EXT4_IOC_MOVE_EXT ioctl and related	functions
Date: Mon, 15 Jun 2009 17:03:39 +0900
Message-ID: <4A36005B.6080101@rs.jp.nec.com>
References: <4A164EE8.1070903@rs.jp.nec.com> <20090613132148.GK24336@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35067 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOIDz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jun 2009 04:03:55 -0400
In-Reply-To: <20090613132148.GK24336@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thank you for your time to review my patch.

Theodore Tso wrote:
> On Fri, May 22, 2009 at 04:06:16PM +0900, Akira Fujita wrote:
>> ext4: online defrag -- Add EXT4_IOC_MOVE_EXT ioctl and related functions.
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> The EXT4_IOC_MOVE_EXT exchanges the blocks between orig_fd and donor_fd,
>> and then write the file data of orig_fd to donor_fd.
>> ext4_mext_move_extent() is the main fucntion of ext4 online defrag,
>> and this patch includes all functions related to ext4 online defrag.
> 
> Akira-san,
> 
> Thank you for all of the hard work and preserverance with the online
> defrag work!  This patch is much, *much* better; I've done a quick
> review, and I've only noted two things, which I've updated in the
> version I've now moved into the stable portion of the patch queue.
> One is that nothing actually uses orig_fd in the move_extent
> structure; so to avoid confusion, and I've renamed it to "reserved",
> and used explicit __u32 fields for the reserved and donor_fd fields.
> Also, I've renamed ext4_mext_move_extent() to ext4_move_extents();
> since it is the one published interface, I wanted it to have an
> easier-to-understand name.

Ok.  Certainly orig_fd of move_extent structure is not used
since fd of original file is passed via ioctl directly.
My recognition after the change is as follows:

struct move_extent {
	__u32 reserved;		/* reserved field */
	__u32 donor_fd;		/* donor file descriptor */
	__u64 orig_start;	/* logical start offset in block for orig */
	__u64 donor_start;	/* logical start offset in block for donor */
	__u64 len;		/* block length to be moved */
	__u64 moved_len;	/* moved block length */
};

int ext4_move_extent(struct file *o_filp, struct file *d_filp,
				__u64 start_orig, __u64 start_donor,
				__u64 len, __u64 *moved_len);

Little changes are needed for command to run ext4 online defrag,
so I will resend patch in a few days.


> As a side note, the static functions in fs/ext4/move_extent.c really
> don't need the ext4_mext prefix, since static functions don't have
> namespace issues that require a consistent naming scheme.  (Sometimes
> a shorter name can also be useful since it avoids needing to line wrap
> function calls with a long list of parameters.)

I will check all of the functions in move_extent.c
whether the function name can be shorter or not.

Regards,
Akira Fujita
