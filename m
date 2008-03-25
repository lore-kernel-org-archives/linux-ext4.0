From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs-next] Fix extent flag validity tests in pass1
 on big endian boxes.
Date: Mon, 24 Mar 2008 19:56:23 -0500
Message-ID: <47E84DB7.7030100@redhat.com>
References: <47E82796.9050807@redhat.com> <20080325003250.GM2691@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbYCYA40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 20:56:26 -0400
In-Reply-To: <20080325003250.GM2691@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Mar 24, 2008  17:13 -0500, Eric Sandeen wrote:
>> Extent data is shared with the i_block[] space in the inode,
>> but it is always swapped on access, not when the inode is read.
>>
>> In e2fsck/pass1.c we must be careful when checking validity
>> of the extents flag on the inode.  If the flag was set when
>> the inode was read & swapped, then the extents data itself
>> (in ->i_block[]) was NOT swapped, so testing for a valid
>> extent header requires some swapping first.  Then, if we
>> ultimately set the extents flag, all of i_block[] must be
>> re/un-swapped.
> 
> This seems pretty awkward for any other users of the library.  Having the
> i_block[] array NOT be swabbed if it is an extent file means that every
> place in the code which is accessing this array also needs to do the
> swabbing itself.  This would break the abstraction that the in-memory
> inode is in host-endian order, and also forces every application to
> understand the difference between extent- and non-extent-mapped inodes,
> and the on-disk byte order.  Ugh.

Well, I tend to agree, but I thought that's how it was implemented
throughout the library... as well as in the kernel?

        if (unlikely(le16_to_cpu(eh->eh_depth) != depth)) {
                error_msg = "unexpected eh_depth";
                goto corrupted;
        }

...

static inline unsigned short ext_depth(struct inode *inode)
{
        return le16_to_cpu(ext_inode_hdr(inode)->eh_depth);
}

etc... or am I missing something silly...

-Eric

> IMHO, it would be better to swab the i_block[] array in
> ext2fs_swap_inode_full() if the EXTENTS_FL is set, and in the rare
> case of e2fsck needing to clear that flag then it should un-swap (if
> needed), clear the flag, and re-swap (if needed).  This will very rarely
> happen, I think.  Note that the Lustre extents patches did NOT do the
> swap+clear_swap operation when clearing the extents flags because we
> don't have any big-endian server systems (our PPC testing is limited to
> userspace "make check"), though I think that is the right thing to do.
> 
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

