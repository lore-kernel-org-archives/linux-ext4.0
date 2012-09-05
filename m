From: Jan Kara <jack@suse.cz>
Subject: Re: Why page w/o buffers can not be released?
Date: Wed, 5 Sep 2012 14:28:09 +0200
Message-ID: <20120905122809.GB18051@quack.suse.cz>
References: <871uig906i.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871uig906i.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 05-09-12 15:30:29, Dmitry Monakhov wrote:
> 
> ext3, ext4 and ocfs2 do not allow to release page w/o buffers.
> Can some one please explain me why?
> 
> ext4_releasepage(struct page *page, gfp_t wait)
> {
>         if (!page_has_buffers(page))
>                 return 0;
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^( zero means fail to release)
>         if (journal)
>            return jbd2_journal_try_to_free_buffers(journal, page, wait);
>         else
>                 return try_to_free_buffers(page);
> }
> 
> This is looks very strange because if page has not buffers then
> it has no fs-specific data associated with it. Am I right?
> IMHO code should looks like follows:
> xxx_releasepage() {
> 
>      if(PageWriteback(page))
>         return 0;
>      if (!page_has_buffers(page))
>         return 1;
>  
>     return do_fs_specific_stuff()
> }
  Yeah, I agree. Although this is mostly a harmless thing because all call
sites test for page_has_private(page) before calling try_to_release_page(page)
so !page_has_buffers(page) is impossible. But a cleanup (remove the test) would
be nice.

  Also PageWriteback() is checked in try_to_release_page() so filesystems
don't have to care...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
