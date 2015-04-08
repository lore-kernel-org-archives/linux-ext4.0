From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/22] ext4: add ext4_mpage_readpages()
Date: Tue, 7 Apr 2015 23:04:43 -0400
Message-ID: <20150408030443.GB21171@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-2-git-send-email-tytso@mit.edu>
 <85D94901-4D36-45F3-A57C-0D6010DE18FA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55732 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbDHDEs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2015 23:04:48 -0400
Content-Disposition: inline
In-Reply-To: <85D94901-4D36-45F3-A57C-0D6010DE18FA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06, 2015 at 03:08:51PM -0600, Andreas Dilger wrote:
> On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > This takes code from fs/mpage.c and optimizes it for ext4.  Its
> > primary reason is to allow us to more easily add encryption to ext4's
> > read path in an efficient manner.
> > 
> [snip]
> > diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> > new file mode 100644
> > index 0000000..9ca4dfc
> > --- /dev/null
> > +++ b/fs/ext4/readpage.c
> > @@ -0,0 +1,261 @@
> > +/*
> > + * linux/fs/ext4/readpage.c
> > + *
> > + * This was originally taken from fs/mpage.c
> > + *
> > + * The intent is the ext4_mpage_readpages() function here is intended
> > + * to replace mpage_readpages() in the general case, not just for
> > + * encrypted files.  It has some limitations (see below), where it
> > + * will fall back to read_block_full_page(), but these limitations
> > + * should never be hit when page_size != block_size.
> 
> Shouldn't this be "... should never be hit when page_size == block_size"?
> Otherwise, we'd hit them almost all the time...

Yes, or maybe "should only be hit when...".  Thanks, good catch.

          	      	      	      	  - Ted
				  				  
