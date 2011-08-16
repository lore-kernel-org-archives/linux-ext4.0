From: Jan Kara <jack@suse.cz>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Tue, 16 Aug 2011 16:21:08 +0200
Message-ID: <20110816142108.GF23416@quack.suse.cz>
References: <86aab94mfg.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1HPOVJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 10:21:09 -0400
Content-Disposition: inline
In-Reply-To: <86aab94mfg.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-08-11 18:37:23, Ivan Shmakov wrote:
> 	How do I get the Ext2+ filesystem size (in blocks)?
> 
> 	Currently, I do it like:
> 
> static uint_fast64_t
> e2fs_size (ext2_filsys e2)
> {
>   uint_fast32_t hi
>     = (uint_fast32_t)e2->super->s_blocks_count_hi;
>   uint_fast32_t lo
>     = (uint_fast32_t)e2->super->s_blocks_count;
> 
>   /* . */
>   return (((uint64_t)hi << 32) | lo);
> }
> 
> 	However, it seems that there's no documentation for both the
> 	ext2_filsys and struct ext2_super_block structure types, and
> 	their respective member fields.
> 
> 	Am I safe with the code above?
  Yes, this is correct.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
