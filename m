From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Avoid rec_len overflow with 64KB block size
Date: Thu, 20 Sep 2007 12:18:49 -0600
Message-ID: <20070920181849.GE32520@schatzie.adilger.int>
References: <20070920143214.GC1986@atrey.karlin.mff.cuni.cz> <20070920161722.GE1986@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:52091 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbXITSSY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 14:18:24 -0400
Content-Disposition: inline
In-Reply-To: <20070920161722.GE1986@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 20, 2007  18:17 +0200, Jan Kara wrote:
> >   when converting ext4 directories to pagecache I just came over
> > Takashi's patch preventing overflowing of rec_len. Looking over the
> > patch - can't we do it more elegantly by using say 0xffff instead of 64K
> > and perform conversion (using some helper) at the moment we read / store
> > rec_len? That would be IMHO more transparent than current approach (at
> > least it took me some time to understand what's going on with the
> > current patch when I was looking at the code)...
>
>   Attached is a patch that does this for ext4. If you like this
> approach, I can cook up a similar patch for ext2 / ext3.

Yes, I think this is much cleaner to avoid all the conditionals in the
code.

> With 64KB blocksize, a directory entry can have size 64KB which does not fit
> into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> value when read from / written to disk. The patch also converts some places
> to use ext4_next_entry() when we are changing them anyway.
> 
>  	const char * error_msg = NULL;
> -	const int rlen = le16_to_cpu(de->rec_len);
> +	const int rlen = ext4_get_rec_len(le16_to_cpu(de->rec_len));

Maybe we should wrap the le16_to_cpu() into ext4_get_rec_len() itself,
making the parameter just be "__le16 rec_len"?  We appear to have
le16_to_cpu() at every callsite.

Likewise for ext4_store_rec_len() it should do the cpu_to_le16() internally
and return an __le16.  It should maybe be called ext4_set_rec_len() to be
a more natural pairing?

This also needs a patch for e2fsprogs, while I'm not sure the old patch did
(has anyone ever checked this?) We could still consider making
EXT4_DIR_MAX_REC_LEN as in Takashi's patch, but keep the cleanups here.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
