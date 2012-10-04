From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit [V2]
Date: Thu, 4 Oct 2012 14:47:43 -0300
Message-ID: <20121004174743.GA17353@andromeda.usersys.redhat.com>
References: <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
 <1349233163-16178-1-git-send-email-cmaiolino@redhat.com>
 <20121004124212.GG4641@quack.suse.cz>
 <20121004130244.GI4641@quack.suse.cz>
 <20121004135746.GA3296@andromeda.usersys.redhat.com>
 <20121004142900.GJ4641@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab2JDRrr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 13:47:47 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q94HllH1026643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2012 13:47:47 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-129.phx2.redhat.com [10.3.113.129])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q94HlhbK026016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2012 13:47:46 -0400
Content-Disposition: inline
In-Reply-To: <20121004142900.GJ4641@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2012 at 04:29:00PM +0200, Jan Kara wrote:
> On Thu 04-10-12 10:57:46, Carlos Maiolino wrote:
> > On Thu, Oct 04, 2012 at 03:02:44PM +0200, Jan Kara wrote:
> > > On Thu 04-10-12 14:42:12, Jan Kara wrote:
> > > > On Tue 02-10-12 23:59:23, Carlos Maiolino wrote:
> > > > > This is the ext3 version of the same patch applied to Ext4, where such goal is
> > > > > to audit the usage of ext3_bread() due a possible misinterpretion of its return
> > > > > value.
> > > > > 
> > > > > Focused on directory blocks, a NULL value returned from ext3_bread() means a
> > > > > hole, which cannot exist into a directory inode. It can pass undetected after a
> > > > > fix in an uninitialized error variable.
> > > > > 
> > > > > The (now) initialized variable into ext3_getblk() may lead to a zero'ed return
> > > > > value of ext3_bread() to its callers, which can make the caller do not detect
> > > > > the hole in the directory inode.
> > > > > 
> > > > > This checks for directory holes when buffer_head and error value are both
> > > > > zero'ed returning -EIO to their callers
> > > > > 
> > > > > Some ext3_bread() callers do not needed any changes either because they already
> > > > > had its own hole detector paths or because these are deprecaded (like
> > > > > dx_show_entries)
> > > > > 
> > > > > V2: It adds a wrapper function ext3_dir_bread() to check for directory holes
> > > > > when reading blocks for a directory inode, and callers of ext3_bread() to read
> > > > > directory blocks were replaced by this wrapper.
> > > > > 
> > > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > >   Oh, I see you already sent V2. Thanks. I've put the patch to my tree.
> > >   Umm, after checking - any reason why you didn't convert also ext3_bread()
> > > in dir.c and ext3_bread() in ext3_rename()?
> > > 
> > I didn't convert some calls for ext3_bread() - like ext3_readdir() -
> > because those really don't care about the err value, only about if bh is
> > valid or not. I can change this if you want, not a problem from my point.
>   Right. I've converted the call in ext3_rename() because there it seems
> useful. In ext3_readdir() calling ext3_bread() is better because we want
> to be able to read the faulty directory.

K, so I don't need to send a V3?

cheers
-- 
--Carlos
