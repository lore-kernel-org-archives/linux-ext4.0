From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: no buffers in ext4_writepage?
Date: Tue, 15 Jun 2010 11:41:32 -0500
Message-ID: <4C17AD3C.6080502@redhat.com>
References: <20100615162957.GA14500@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0FORes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 13:34:48 -0400
In-Reply-To: <20100615162957.GA14500@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> ext4_writepage currently has a and else case after the
> page_has_buffers() check where it does I/O if there are no buffers
> attached.  But given how ext4 uses a write_begin method that always
> creates buffer, the normal set_page_dirty which creates buffers
> and a ->page_mkwrite that creates buffers I just can't see how that case
> can happen at all.


It was all added from:

commit f0e6c98593eb8a77edb7dd0edb22bb9f9368c567
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Jul 11 19:27:31 2008 -0400

    ext4: Handle page without buffers in ext4_*_writepage()
    
    It can happen that buffers are removed from the page before it gets
    marked dirty and then is passed to writepage().  In writepage() we just
    initialize the buffers and check whether they are mapped and non
    delay. If they are mapped and non delay we write the page. Otherwise we
    mark them dirty.  With this change we don't do block allocation at all
    in ext4_*_write_page.
    
    writepage() can get called under many condition and with a locking order
    of journal_start -> lock_page, we should not try to allocate blocks in
    writepage() which get called after taking page lock.  writepage() can
    get called via shrink_page_list even with a journal handle which was
    created for doing inode update.  For example when doing
    ext4_da_write_begin we create a journal handle with credit 1 expecting a
    i_disksize update for the inode. But ext4_da_write_begin can cause
    shrink_page_list via _grab_page_cache. So having a valid handle via
    ext4_journal_current_handle is not a guarantee that we can use the
    handle for block allocation in writepage, since we shouldn't be using
    credits that had been reserved for other updates.  That it could result
    in we running out of credits when we update inodes.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


FWIW...

-Eric
