From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: avoid unnecessary transaction stalls during
 writeback
Date: Tue, 2 May 2017 10:18:06 -0400
Message-ID: <20170502141806.h2mkezveq5fztiju@thunk.org>
References: <20170430220101.trrgiaphp756kxw4@thunk.org>
 <20170430223053.20025-1-tytso@mit.edu>
 <20170502121044.GG13916@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39984 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdEBOSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 May 2017 10:18:09 -0400
Content-Disposition: inline
In-Reply-To: <20170502121044.GG13916@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 02, 2017 at 02:10:44PM +0200, Jan Kara wrote:
> 
> Yeah, thanks for finding the problem and fixing it up! The updated patch
> looks good. It is actually relatively easy to fix the original approach so
> that we don't have to allocate ioend unnecessarily (we just fetch the inode
> pointer on error through bio_vec->bv_page->mapping->host) but I'll do that
> separately on top of this change.

We'll need to be a little bit careful to make sure this works for the
encryption case (where we use a temporary scratch/bounce buffer), but
it should be possible to make that work (we just have to look at the
right struct page).

					- Ted
