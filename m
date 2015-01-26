From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: reserve codepoints used by the ext4 encryption
 feature
Date: Mon, 26 Jan 2015 10:26:41 -0500
Message-ID: <20150126152641.GA31455@thunk.org>
References: <1422041781-14062-1-git-send-email-tytso@mit.edu>
 <20150123194125.GC9976@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, savagaon@google.com, muslukhovi@gmail.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32921 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbbAZP0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2015 10:26:47 -0500
Content-Disposition: inline
In-Reply-To: <20150123194125.GC9976@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 23, 2015 at 11:41:25AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 23, 2015 at 02:36:21PM -0500, Theodore Ts'o wrote:
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  fs/ext4/ext4.h | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index a75fba6..b7f393d 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -364,7 +364,8 @@ struct flex_groups {
> >  #define EXT4_DIRTY_FL			0x00000100
> >  #define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
> >  #define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
> > -#define EXT4_ECOMPR_FL			0x00000800 /* Compression error */
> > +	/* nb: was previously EXT2_ECOMPR_FL */
> > +#define EXT4_ENCRYPT_FL			0x00000800 /* encrypted file */
> >  /* End compression flags --- maybe not all used */
> >  #define EXT4_INDEX_FL			0x00001000 /* hash-indexed directory */
> >  #define EXT4_IMAGIC_FL			0x00002000 /* AFS directory */
> > @@ -421,7 +422,7 @@ enum {
> >  	EXT4_INODE_DIRTY	= 8,
> >  	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
> >  	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
> > -	EXT4_INODE_ECOMPR	= 11,	/* Compression error */
> > +	EXT4_INODE_ENCRYPT	= 11,	/* Compression error */
> 
> Encryption error?

No, it should actually be "inode is encrypted".  My bad for not
catching the error in the comment; I'll fix that up.

	     	      	  	   	- Ted
