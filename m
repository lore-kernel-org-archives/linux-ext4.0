From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: delayed allocation support and mmap
Date: Wed, 17 Aug 2011 13:49:42 +0200
Message-ID: <20110817114942.GE9959@quack.suse.cz>
References: <CABxQaWsda6PJGLBgdMTGidV_ZcdZrdajJZXgbkRXij3U3_SZAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Ted Tso <tytso@mit.edu>
To: Surbhi Palande <ameyasurbhi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1HQLto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 07:49:44 -0400
Content-Disposition: inline
In-Reply-To: <CABxQaWsda6PJGLBgdMTGidV_ZcdZrdajJZXgbkRXij3U3_SZAA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Wed 17-08-11 14:02:09, Surbhi Palande wrote:
> Current ext4_page_mkwrite() implementation always allocates a block
> through  ext4_get_block_write() or ext4_get_block().
  Why do you think so? Look at:
        /* Delalloc case is easy... */
        if (test_opt(inode->i_sb, DELALLOC) &&
            !ext4_should_journal_data(inode) &&
            !ext4_nonda_switch(inode->i_sb)) {
                do {
                        ret = __block_page_mkwrite(vma, vmf,
                                                   ext4_da_get_block_prep);
                } while (ret == -ENOSPC &&
                       ext4_should_retry_alloc(inode->i_sb, &retries));
                goto out_ret;
        }

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
