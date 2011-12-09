From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] ext4: allocate delalloc blocks before changing journal
 mode
Date: Fri, 09 Dec 2011 12:31:31 +0900
Message-ID: <4EE18113.9060503@jp.fujitsu.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45504 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1LID21 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 22:28:27 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 4B9FE3EE0AE
	for <linux-ext4@vger.kernel.org>; Fri,  9 Dec 2011 12:28:24 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 303AC45DF56
	for <linux-ext4@vger.kernel.org>; Fri,  9 Dec 2011 12:28:24 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 18DAB45DF55
	for <linux-ext4@vger.kernel.org>; Fri,  9 Dec 2011 12:28:24 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0A6C11DB802C
	for <linux-ext4@vger.kernel.org>; Fri,  9 Dec 2011 12:28:24 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B27D71DB803C
	for <linux-ext4@vger.kernel.org>; Fri,  9 Dec 2011 12:28:23 +0900 (JST)
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(2011/11/15 17:07), Yongqiang Yang wrote:
> delalloc blocks should be allocated before changing journal mode,
> otherwise they can not be allocated and even more truncate on
> delalloc blocks could triggre BUG by flushing delalloc buffers.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/inode.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index de05e86..384f8a7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4676,6 +4676,17 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  		return 0;
>  	if (is_journal_aborted(journal))
>  		return -EROFS;
> +	/* We have to allocate physical blocks for delalloc blocks
> +	 * before flushing journal. otherwise delalloc blocks can not
> +	 * be allocated any more. even more truncate on delalloc blocks
> +	 * could trigger BUG by flushing delalloc blocks in journal.
> +	 * There is no delalloc block in non-journal data mode.
> +	 */
> +	if (val && test_opt(inode->i_sb, DELALLOC)) {
> +		err = ext4_alloc_da_blocks(inode);
> +		if (err < 0)
> +			return err;
> +	}
>  
>  	jbd2_journal_lock_updates(journal);
>  	jbd2_journal_flush(journal);

Though I tested your patch by my reproducer that caused a panic which you 
pointed out, a panic did not happen. 
-------------------------------------------------------------------------------
#!/bin/sh

echo "a" > /tmp/a # file under an ext4 filesystem
chattr +j /tmp/a
echo "a" >> /tmp/a
chattr -j /tmp/a
-------------------------------------------------------------------------------

So, this patch looks good to me.

Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

