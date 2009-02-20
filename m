From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory
	traversal through deleted inode
Date: Fri, 20 Feb 2009 12:59:00 -0500
Message-ID: <20090220175900.GA18522@mini-me.lan>
References: <20090214141411.GD26628@mini-me.lan> <1234833003-19631-1-git-send-email-bdonlan@gmail.com> <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
To: Bryan Donlan <bdonlan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51509 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZBTVvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2009 16:51:06 -0500
Content-Disposition: inline
In-Reply-To: <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 20, 2009 at 12:53:39PM -0500, Bryan Donlan wrote:
> On Mon, Feb 16, 2009 at 8:10 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> 
> > +               if (unlikely(IS_ERR(inode))) {
> > +                       if (PTR_ERR(inode) == -ESTALE) {
> > +                               ext3_error(dir->i_sb, "ext2_lookup",
> > +                                               "deleted inode referenced: %lu",
> > +                                               ino);
> > +                               return ERR_PTR(-EIO);
> > +                       } else {
> > +                               return ERR_CAST(inode);
> > +                       }
> > +               }
> 
> I just noticed that I forgot to edit the function name in the
> ext3_error and ext4_error invocations... Would it be better to send a
> delta to fix this or resubmit the whole thing?

It's already been pulled into akpm's tree as separate patches.  I'll
fix up the ext4 one by hand; probably better for you to send
replacement patches for ext3 separately to akpm and ask him to replace.

I'd suggest using __FUNC__ instead of hard-coding the function name, BTW...

    	    	  	   	      		  - Ted

