From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext3: Add fixed tracepoints
Date: Mon, 23 May 2011 18:11:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105231804050.3903@dhcp-27-109.brq.redhat.com>
References: <1306162977-23061-1-git-send-email-lczerner@redhat.com> <1306162977-23061-2-git-send-email-lczerner@redhat.com> <20110523154124.GC4716@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab1EWQMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 12:12:00 -0400
In-Reply-To: <20110523154124.GC4716@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 May 2011, Jan Kara wrote:

> > @@ -1577,6 +1589,7 @@ static int ext3_ordered_writepage(struct page *page,
> >  	if (ext3_journal_current_handle())
> >  		goto out_fail;
> >  
> > +	trace_ext3_ordered_writepage(inode, page);
> >  	if (!page_has_buffers(page)) {
> >  		create_empty_buffers(page, inode->i_sb->s_blocksize,
> >  				(1 << BH_Dirty)|(1 << BH_Uptodate));
>   Any reason why writepage() takes inode while all other page operations
> take only the page pointer? I see ext4 does this as well but still we don't
> have to be *that* compatible :). Otherwise the patch looks OK.
> 
> 								Honza

Oh, I did not notice that. Thanks, I'll create just one EVENT_CLASS for
page operations.

Thanks!
-Lukas
