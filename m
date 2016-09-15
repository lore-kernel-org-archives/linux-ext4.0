From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND PATCH]ext4: bugfix for mmaped pages in
 mpage_release_unused_pages()
Date: Thu, 15 Sep 2016 11:34:08 -0400
Message-ID: <20160915153408.qvhtcymmvkfdlvfj@thunk.org>
References: <OF1131FC37.F6A9396B-ON48258026.002F1164-48258026.00306F86@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: wang.guang55@zte.com.cn
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55688 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcIOPeq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 11:34:46 -0400
Content-Disposition: inline
In-Reply-To: <OF1131FC37.F6A9396B-ON48258026.002F1164-48258026.00306F86@zte.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 06, 2016 at 04:49:17PM +0800, wang.guang55@zte.com.cn wrote:
> ext4: bugfix for mmaped pages  in mpage_release_unused_pages()
> 
> Pages clear buffers after ext4 delayed block allocation failed,
> However, it does not clean its pte_dirty flag.
> if the pages unmap ,in cording to the pte_dirty ,
> unmap_page_range may try to call __set_page_dirty,
> 
> which may lead to the bugon at 
> mpage_prepare_extent_to_map:head = page_buffers(page);.
> 
> This patch just call clear_page_dirty_for_io to clean pte_dirty 
> at mpage_release_unused_pages for pages mmaped. 
> 
>  
> Steps to reproduce the bug:
> （1） mmap a file in ext4
> addr = (char *)mmap(NULL, 4096, 
>         PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>  memset(addr, 'i', 4096);
> （2） return EIO at 
> ext4_writepages->mpage_map_and_submit_extent->mpage_map_one_extent 
> Cause the log:
>                 ext4_msg(sb, KERN_CRIT,
>                         "Delayed block allocation failed for "
>                         "inode %lu at logical offset %llu with"
>                         " max blocks %u with error %d",
>                         inode->i_ino,
>                         (unsigned long long)map->m_lblk,
>                         (unsigned)map->m_len, -err);
> 
> (3）Unmap the addr cause warning at 
> __set_page_dirty:WARN_ON_ONCE(warn && !PageUptodate(page));
> (4) wait for a minute,then bugon happen.
> 
> Signed-off-by: wangguang <wangguang03@zte.com>

Thanks, applied.   Apologies for the delay.

						- Ted
