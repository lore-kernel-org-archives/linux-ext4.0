From: Jan Kara <jack@suse.cz>
Subject: Re: kernel oops in jbd2_journal_get_descriptor_buffer
Date: Thu, 11 Oct 2012 11:59:32 +0200
Message-ID: <20121011095932.GA16624@quack.suse.cz>
References: <50768765.8040406@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Clement Gallin-Douathe <c-gallin-douathe@ti.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab2JKJ7f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 05:59:35 -0400
Content-Disposition: inline
In-Reply-To: <50768765.8040406@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 11-10-12 10:46:29, Clement Gallin-Douathe wrote:
> I am working on ARMv7 dual-core board with android (ICS + kernel 3.4.9).
> I am randomly facing a kernel oops in fs/jbd2/journal.c: In the
> function jbd2_journal_get_descriptor_buffer, memset is called
> without checking bh->b_data which is NULL in my case.
> 
> It seems to be a problem with the journal device block.
> It seems that the current memory zone is high memory zone, so the
> current buffer head referred to the used page is not correctly set
> (b_data is NULL).
> 
> I could not find why the buffer cache tries to allocate and use a
> block in high memory zone.
> Any ideas, or tips/tricks for debugging ?
  Well, the question is how a highmem page got to
jbd2_journal_get_descriptor_buffer(). In fs/block_dev.c:bdget() we do
mapping_set_gfp_mask(&inode->i_data, GFP_USER) where GFP_USER is
(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL). That means
!__GFP_HIGH in particular. So does the device ext4 is mounted on play
some tricks with mapping flags? If not, I'd instrument grow_dev_page() in
fs/buffer.c to check whether the returned page is not highmem... If yes,
look further into the allocator. If no, it could be a bug in page migration
code from mm/migrate.c.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
