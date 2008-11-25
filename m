From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RESEND][PATCH 2/3 BUG,RFC] ext3: release block-device-mapping
 buffer_heads which have the filesystem private data for avoiding	oom-killer
Date: Tue, 25 Nov 2008 13:09:12 +0900
Message-ID: <492B7A68.7060304@jp.fujitsu.com>
References: <20081120093450.c87b39ef.toshi.okajima@jp.fujitsu.com> <20081124055133.GB20928@mit.edu> <492B4E48.3080000@jp.fujitsu.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: toshi.okajima@jp.fujitsu.com, akpm@linux-foundation.org,
	viro@zeniv.linux.org.uk, sct@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45733 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYKYEJY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 23:09:24 -0500
In-Reply-To: <492B4E48.3080000@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
I have reconsidered your comments.

Toshiyuki Okajima wrote:
> Hi Ted,
> Thanks for your comments.
> 
>  > Hi Toshijuki,
<SNIP>
>  > Your patch series looks good, but I have one comment, for the ext3 and
>  > ext4 patches:
>  >
>  > > +    if (journal != NULL)
>  > > +        return journal_try_to_free_buffers(journal, page, wait);
>  > > +    else
>  > > +        return try_to_free_buffers(page);
>  >
>  > According to the documentation for journal_try_to_free_buffers():
>  >
>  >  * This function returns non-zero if we wish try_to_free_buffers()
>  >  * to be called. We do this if the page is releasable by 
> try_to_free_buffers().
>  >  * We also do it if the page has locked or dirty buffers and the 
> caller wants
>  >  * us to perform sync or async writeout.
> I forgot reading it.
I think this document is obsolete because a current version of
journal_try_to_free_buffers() also calls try_to_free_buffers().
So, this document needs to be changed.
Therefore I don't need to change my patch, OK?

[current version]
1727 int journal_try_to_free_buffers(journal_t *journal,
1728                                 struct page *page, gfp_t gfp_mask)
1729 {
1730         struct buffer_head *head;
1731         struct buffer_head *bh;
1732         int ret = 0;
1733
1734         J_ASSERT(PageLocked(page));
1735
1736         head = page_buffers(page);
1737         bh = head;
1738         do {
1739                 struct journal_head *jh;
1740
1741                 /*
1742                  * We take our own ref against the journal_head here to avoid
1743                  * having to add tons of locking around each instance of
1744                  * journal_remove_journal_head() and journal_put_journal_head().
1745                  */
1746                 jh = journal_grab_journal_head(bh);
1747                 if (!jh)
1748                         continue;
1749
1750                 jbd_lock_bh_state(bh);
1751                 __journal_try_to_free_buffer(journal, bh);
1752                 journal_put_journal_head(jh);
1753                 jbd_unlock_bh_state(bh);
1754                 if (buffer_jbd(bh))
1755                         goto busy;
1756         } while ((bh = bh->b_this_page) != head);
1757
1758         ret = try_to_free_buffers(page);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1759
1760         /*
1761          * There are a number of places where journal_try_to_free_buffers()
1762          * could race with journal_commit_transaction(), the later still
1763          * holds the reference to the buffers to free while processing them.
1764          * try_to_free_buffers() failed to free those buffers. Some of the
1765          * caller of releasepage() request page buffers to be dropped, otherwise
1766          * treat the fail-to-free as errors (such as generic_file_direct_IO())
1767          *
1768          * So, if the caller of try_to_release_page() wants the synchronous
1769          * behaviour(i.e make sure buffers are dropped upon return),
1770          * let's wait for the current transaction to finish flush of
1771          * dirty data buffers, then try to free those buffers again,
1772          * with the journal locked.
1773          */
1774         if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
1775                 journal_wait_for_transaction_sync_data(journal);
1776                 ret = try_to_free_buffers(page);
1777         }
1778
1779 busy:
1780         return ret;
1781 }

[old version(linux-2.4.36.8)]
   1731	int journal_try_to_free_buffers(journal_t *journal,
   1732					struct page *page, int gfp_mask)
   1733	{
...
   1759		struct buffer_head *bh;
   1760		struct buffer_head *tmp;
   1761		int locked_or_dirty = 0;
   1762		int call_ttfb = 1;
   1763	
   1764		J_ASSERT(PageLocked(page));
   1765	
   1766		bh = page->buffers;
   1767		tmp = bh;
   1768		spin_lock(&journal_datalist_lock);
   1769		do {
   1770			struct buffer_head *p = tmp;
   1771	
   1772			if (unlikely(!tmp)) {
   1773				debug_page(page);
   1774				BUG();
   1775			}
   1776				
   1777			tmp = tmp->b_this_page;
   1778			if (buffer_jbd(p))
   1779				if (!__journal_try_to_free_buffer(p, &locked_or_dirty))
   1780					call_ttfb = 0;
   1781		} while (tmp != bh);
   1782		spin_unlock(&journal_datalist_lock);
   1783	
   1784		if (!(gfp_mask & (__GFP_IO|__GFP_WAIT)))
   1785			goto out;
   1786		if (!locked_or_dirty)
   1787			goto out;
   1788		/*
   1789		 * The VM wants us to do writeout, or to block on IO, or both.
   1790		 * So we allow try_to_free_buffers to be called even if the page
   1791		 * still has journalled buffers.
   1792		 */
   1793		call_ttfb = 1;
   1794	out:
   1795		return call_ttfb;
   1796	}

Regards,
Toshiyuki Okajima

