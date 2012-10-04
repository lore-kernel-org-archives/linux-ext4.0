From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit
Date: Thu, 4 Oct 2012 14:38:42 +0200
Message-ID: <20121004123842.GF4641@quack.suse.cz>
References: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
 <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
 <20121002135513.GE22777@quack.suse.cz>
 <20121002142723.GA2323@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab2JDMio (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 08:38:44 -0400
Content-Disposition: inline
In-Reply-To: <20121002142723.GA2323@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-10-12 11:27:23, Carlos Maiolino wrote:
> Hi Jan
> On Tue, Oct 02, 2012 at 03:55:13PM +0200, Jan Kara wrote:
> > On Mon 01-10-12 16:50:55, Carlos Maiolino wrote:
> > > This is the ext3 version of the same patch applied to Ext4, where such goal is
> > > to audit the usage of ext3_bread() due a possible misinterpretion of its return
> > > value.
> > > 
> > > Focused on directory blocks, a NULL value returned from ext3_bread() means a
> > > hole, which cannot exist into a directory inode. It can pass undetected after a
> > > fix in an uninitialized error variable.
> > > 
> > > The (now) initialized variable into ext3_getblk() may lead to a zero'ed return
> > > value of ext3_bread() to its callers, which can make the caller do not detect
> > > the hole in the directory inode.
> > > 
> > > This checks for directory holes when buffer_head and error value are both
> > > zero'ed returning -EIO to their callers
> > > 
> > > Some ext3_bread() callers do not needed any changes either because they already
> > > had its own hole detector paths or because these are deprecaded (like
> > > dx_show_entries)
> >   Umm, can you wrap the check for hole + error message in a helper function
> > like ext3_dir_bread() please? That would save us quite some dupplication..
> > Thanks!
> >
  Please use reply-to-all when replying next time. It makes me see the
email much faster and reply cannot get lost in mailing list traffic...

> I thought about a kind of handler too, but haven't done something like that by
> Ted's suggestion. Please see thread
> http://marc.info/?l=linux-ext4&m=134827512716575&w=2
> 
> But I can work on a kind of wrapper for ext3 if this is ok for you and send a V2
> version of this patch.
  I see. Still I'd rather have the helper function. So please send V2.
Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
