From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/2] ext4: fix journal ref count in move_extent_par_page
Date: Mon, 03 Aug 2009 17:30:07 +0900
Message-ID: <4A76A00F.30506@rs.jp.nec.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51113 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZHCIbA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 04:31:00 -0400
In-Reply-To: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,

Peng Tao wrote:
> move_extent_par_page calls a_ops->write_begin() to increase journal handler's
> reference count. However, if either mext_replace_branches() or ext4_get_block
> fails, the increased reference count isn't decreased. This will cause later
> umounting of the fs forever hangs. The patch addresses the issue by calling
> ext4_journal_stop() if page is not NULL (which means a_ops->write_end() isn't
> invoked).

In case mext_replaced_branches() or ext4_get_block failed,
ext4_journal_stop() is called at out2 label(*)
and then journal reference counter is decreased.
Therefore I think this fix is not necessary.

static int
move_extent_par_page(struct file *o_filp, struct inode *donor_inode,
                  pgoff_t orig_page_offset, int data_offset_in_page,
                  int block_len_in_page, int uninit)
<snip>

out:
        if (unlikely(page)) {
                if (PageLocked(page))
                        unlock_page(page);
                page_cache_release(page);
        }
out2:
*       ext4_journal_stop(handle);

        return ret < 0 ? ret : 0;
}

Regards,
Akira Fujita
