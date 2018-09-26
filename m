Return-Path: <SRS0=wjg6=MI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbeIZPNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Sep 2018 11:13:21 -0400
Date: Wed, 26 Sep 2018 11:01:21 +0200
From: Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: initialize retries variable in
 ext4_da_write_inline_data_begin()
Message-ID: <20180926090121.iu7bezcbgpm5ldtw@localhost.localdomain>
References: <20180813133459.24241-1-lczerner@redhat.com>
 <20180912155448.GB32355@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912155448.GB32355@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 12, 2018 at 05:54:48PM +0200, Jan Kara wrote:
> On Mon 13-08-18 15:34:59, Lukas Czerner wrote:
> > Variable retries is not initialized in ext4_da_write_inline_data_begin()
> > which can lead to nondeterministic number of retries in case we hit
> > ENOSPC. Initialize retries to zero as we do everywhere else.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Fixes: bc0ca9df3b2a ("ext4: retry allocation when inline->extent conversion failed")
> > Cc: stable@kernel.org
> > ---
> >  fs/ext4/inline.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Ted, this seems to have fallen through the cracks...

Yeah it did, Ted can you pick this up ?

-Lukas

> 
> 								Honza
> 
> > 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index 3543fe80a3c4..1b13fa5c9d6e 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -863,7 +863,7 @@ int ext4_da_write_inline_data_begin(struct address_space *mapping,
> >  	handle_t *handle;
> >  	struct page *page;
> >  	struct ext4_iloc iloc;
> > -	int retries;
> > +	int retries = 0;
> >  
> >  	ret = ext4_get_inode_loc(inode, &iloc);
> >  	if (ret)
> > -- 
> > 2.17.1
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
