From: Jan Kara <jack@suse.cz>
Subject: Re: Avoid rec_len overflow with 64KB block size
Date: Fri, 21 Sep 2007 15:38:02 +0200
Message-ID: <20070921133802.GP17271@atrey.karlin.mff.cuni.cz>
References: <20070920143214.GC1986@atrey.karlin.mff.cuni.cz> <20070920161722.GE1986@atrey.karlin.mff.cuni.cz> <20070920181849.GE32520@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbXIUNiF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 09:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20070920181849.GE32520@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Sep 20, 2007  18:17 +0200, Jan Kara wrote:
> > With 64KB blocksize, a directory entry can have size 64KB which does not fit
> > into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> > value when read from / written to disk. The patch also converts some places
> > to use ext4_next_entry() when we are changing them anyway.
> > 
> >  	const char * error_msg = NULL;
> > -	const int rlen = le16_to_cpu(de->rec_len);
> > +	const int rlen = ext4_get_rec_len(le16_to_cpu(de->rec_len));
> 
> Maybe we should wrap the le16_to_cpu() into ext4_get_rec_len() itself,
> making the parameter just be "__le16 rec_len"?  We appear to have
> le16_to_cpu() at every callsite.
  Yes, we do and I was also thinking about wrapping this up. The only
think I don't like about this is that the endianity conversion is then
hidden.

> Likewise for ext4_store_rec_len() it should do the cpu_to_le16() internally
> and return an __le16.  It should maybe be called ext4_set_rec_len() to be
> a more natural pairing?
  Yes. Actually, I'd find names like "ext4_rec_len_to_disk" and
"ext4_rec_len_from_disk" more explanative but I guess it's already too
long...

> This also needs a patch for e2fsprogs, while I'm not sure the old patch did
> (has anyone ever checked this?) We could still consider making
> EXT4_DIR_MAX_REC_LEN as in Takashi's patch, but keep the cleanups here.
  I don't mind whether EXT4_DIR_MAX_REC_LEN is 1<<16-1 or 1<<16-4 :).
But e2fsprogs need to be updated in either case as both values were invalid
originally...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
