From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add fixed tracepoints
Date: Mon, 23 May 2011 17:41:24 +0200
Message-ID: <20110523154124.GC4716@quack.suse.cz>
References: <1306162977-23061-1-git-send-email-lczerner@redhat.com>
 <1306162977-23061-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1EWPlc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 11:41:32 -0400
Content-Disposition: inline
In-Reply-To: <1306162977-23061-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> @@ -1577,6 +1589,7 @@ static int ext3_ordered_writepage(struct page *page,
>  	if (ext3_journal_current_handle())
>  		goto out_fail;
>  
> +	trace_ext3_ordered_writepage(inode, page);
>  	if (!page_has_buffers(page)) {
>  		create_empty_buffers(page, inode->i_sb->s_blocksize,
>  				(1 << BH_Dirty)|(1 << BH_Uptodate));
  Any reason why writepage() takes inode while all other page operations
take only the page pointer? I see ext4 does this as well but still we don't
have to be *that* compatible :). Otherwise the patch looks OK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
