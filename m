From: Jan Kara <jack@suse.cz>
Subject: Re: Transactions in JBD2 proc
Date: Mon, 29 Oct 2012 19:24:09 +0100
Message-ID: <20121029182409.GH18767@quack.suse.cz>
References: <4B9BD6EF1B194041BF688A9AAE347E37064B168BA039@mercury-stu.bhcc.dom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: John R Nelson <jrnelson@bhcc.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab2J2SYL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 14:24:11 -0400
Content-Disposition: inline
In-Reply-To: <4B9BD6EF1B194041BF688A9AAE347E37064B168BA039@mercury-stu.bhcc.dom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-10-12 13:20:43, John R Nelson wrote:
> hi,
> does the 3640 indicate that there have have 3640 journal writes to this
> ext4 parition since my computer has been up?
  Well, it depends on what you call "journal write". There were 3640
trasactions to your ext4 partition. Each transaction can contain more
"logical" operations like file creation, file write, rename, ... Each
transaction also consists of more blocks. In your case there were 7 blocks
per transaction on average - which is rather small but I expect that's
because the filesystem is mostly idle.
	
								Honza
> 
> 3640 transaction, each up to 8192 blocks
> average: 
>   0ms waiting for transaction
>   2032ms running transaction
>   0ms transaction was being locked
>   0ms flushing data (in ordered mode)
>   52ms logging transaction
>   71647us average transaction commit time
>   316 handles per transaction
>   7 blocks per transaction
>   8 logged blocks per transaction
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
