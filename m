From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
 during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 11:37:58 -0500
Message-ID: <49F730E6.2070904@redhat.com>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker> <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbZD1QiF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 12:38:05 -0400
In-Reply-To: <20090428124821.GJ22104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Apr 28, 2009 at 03:01:45PM +0530, Aneesh Kumar K.V wrote:
>> Looking at the source again i guess setting just b_dev is not enough.
>> unmap_underlying_metadata looks at the mapping block number, which we
>> don't have in case on unwritten buffer_head. How about the below patch ?
>> It involve vfs changes. But i guess it is correct with respect to the
>> meaning of BH_New (Disk mapping was newly created by get_block). I guess
>> BH_New implies BH_Mapped.
> 
> Argh.  So we have multiple problems going on here.  One is the
> original problem, namely that of a partial write into an preallocated
> block can leave garbage behind in that unitialized block.
> 
> The other problem seems to be in the case of a delayed allocation
> write, where we return a buffer_head which is marked new, and this
> causes block_prepare_write() to call unmap_underlying_metadata(dev, 0).
> 
> In theory this could cause problems if we try installing a new
> bootloader in the filesystem's boot block while there's a delayed
> writes happening in the background, since we could end up discarding
> the write to the boot sector.  We've lived with this for quite a wihle
> though.
> 
> My concern with making the fs/buffer.c changes is that we need to make
> sure it doesn't break any of the other filesystems, so that's going to
> make it hard to try to slip this with 2.6.30-rc4 nearly upon us.
> (Silly question; why doesn't XFS get caught by this?) 

I'm not sure offhand.  All xfs does is this in the get_block path:

         * With sub-block writes into unwritten extents we also need to mark
         * the buffer as new so that the unwritten parts of the buffer gets
         * correctly zeroed.
         */
        if (create &&
            ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
             (offset >= i_size_read(inode)) ||
             (iomap.iomap_flags & (IOMAP_NEW|IOMAP_UNWRITTEN))))
                set_buffer_new(bh_result);

so it returns with BH_New as well.

> So the question is do we try to fix both bugs with one patch, and very
> likely have to wait until 2.6.31 before the patch is incorporated?  Or
> do we fix the second bug using an ext4-only fix, with the knowledge
> that post 2.6.30, we'll need undo most of it and fix it properly with
> a change that involves fs/buffer.c?

I have the sense that this might need a bit more digging around, and I
finally got stuff out of the way to do so :)

-Eric

