From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Tue, 26 Mar 2013 13:52:51 +0800
Message-ID: <20130326055251.GA17165@gmail.com>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33279 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3CZFhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2013 01:37:11 -0400
Received: by mail-pa0-f44.google.com with SMTP id bi5so1421722pad.17
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 22:37:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130320144523.GF12865@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for the late reply.

On Wed, Mar 20, 2013 at 10:45:23AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > 
> > As an aside, is there any reason to have "dioread_nolock" as an option
> > at this point?  If it works now, would you ever *not* want it?
> > 
> > (granted it doesn't work with some journaling options etc, but that
> > behavior could be automatic, w/o the need for special mount options).
> 
> The primary restriction is that diread_nolock doesn't work when fs
> block size != page size.  If your proposal is that we automatically
> enable diread_nolock when we can use it safely, that's definitely
> something to consider for the next merge window.

Yes, I also think we can automatically enable dioread_nolock because it
brings us some benefits.

BTW, I think there is an minor improvement for dio overwrite codepath
with indirect-based file.  We don't need to take i_mutex in this
condition just as we have done for extent-based file.  If a user mounts
a ext2/3 file system with a ext4 kernel modules, he/she could get a
lower latency.  But it seems that it would break dio semantic in ext2/3.
Currently in ext2/3 if we issue a overwrite dio and then issue a read
dio.  We will always read the latest data because we wait on i_mutex
lock.  But after parallelizing overwite dio, this semantic might breaks.
I re-read this doc but it seems that it doesn't describe this case.  Do
we need to keep this semantic?

> 
> My long range plan/hope is that we eventually be able to use the
> extent status tree so that we do allocating writes, we first (a)
> allocate the blocks, and mark them as in use as far as the mballoc
> data structures are concerned, but we do _not_ mark them as in use in
> the on-disk allocation bitmaps, then (b) we write the data blocks, and
> then triggered by the block I/O completion, (c) in a single journal
> trnasaction, we update the allocation bitmaps, update the inode's
> extent tree, and update the inode's i_size field.
> 
> This is different from the dioread_nolock approach in that we're not
> initially inserting the blocks in the extent tree as uninitialized,
> and then convert the extent tree entries from uninit to init after the
> I/O completion.

Yes, this approach is better.  I am happy to work on this.

Regards,
                                                - Zheng
