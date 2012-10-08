From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit [V2]
Date: Mon, 8 Oct 2012 18:15:22 +0200
Message-ID: <20121008161522.GG9243@quack.suse.cz>
References: <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
 <1349233163-16178-1-git-send-email-cmaiolino@redhat.com>
 <20121004124212.GG4641@quack.suse.cz>
 <20121004130244.GI4641@quack.suse.cz>
 <20121004135746.GA3296@andromeda.usersys.redhat.com>
 <20121004142900.GJ4641@quack.suse.cz>
 <20121004174743.GA17353@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JHQPY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 12:15:24 -0400
Content-Disposition: inline
In-Reply-To: <20121004174743.GA17353@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-10-12 14:47:43, Carlos Maiolino wrote:
> On Thu, Oct 04, 2012 at 04:29:00PM +0200, Jan Kara wrote:
> > On Thu 04-10-12 10:57:46, Carlos Maiolino wrote:
> > > On Thu, Oct 04, 2012 at 03:02:44PM +0200, Jan Kara wrote:
> > > > On Thu 04-10-12 14:42:12, Jan Kara wrote:
> > > > > On Tue 02-10-12 23:59:23, Carlos Maiolino wrote:
> > > > > > This is the ext3 version of the same patch applied to Ext4, where such goal is
> > > > > > to audit the usage of ext3_bread() due a possible misinterpretion of its return
> > > > > > value.
> > > > > > 
> > > > > > Focused on directory blocks, a NULL value returned from ext3_bread() means a
> > > > > > hole, which cannot exist into a directory inode. It can pass undetected after a
> > > > > > fix in an uninitialized error variable.
> > > > > > 
> > > > > > The (now) initialized variable into ext3_getblk() may lead to a zero'ed return
> > > > > > value of ext3_bread() to its callers, which can make the caller do not detect
> > > > > > the hole in the directory inode.
> > > > > > 
> > > > > > This checks for directory holes when buffer_head and error value are both
> > > > > > zero'ed returning -EIO to their callers
> > > > > > 
> > > > > > Some ext3_bread() callers do not needed any changes either because they already
> > > > > > had its own hole detector paths or because these are deprecaded (like
> > > > > > dx_show_entries)
> > > > > > 
> > > > > > V2: It adds a wrapper function ext3_dir_bread() to check for directory holes
> > > > > > when reading blocks for a directory inode, and callers of ext3_bread() to read
> > > > > > directory blocks were replaced by this wrapper.
> > > > > > 
> > > > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > >   Oh, I see you already sent V2. Thanks. I've put the patch to my tree.
> > > >   Umm, after checking - any reason why you didn't convert also ext3_bread()
> > > > in dir.c and ext3_bread() in ext3_rename()?
> > > > 
> > > I didn't convert some calls for ext3_bread() - like ext3_readdir() -
> > > because those really don't care about the err value, only about if bh is
> > > valid or not. I can change this if you want, not a problem from my point.
> >   Right. I've converted the call in ext3_rename() because there it seems
> > useful. In ext3_readdir() calling ext3_bread() is better because we want
> > to be able to read the faulty directory.
> 
> K, so I don't need to send a V3?
  No. And please use reply-to-all! ;)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
