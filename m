From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 06/36 v4] libext2fs: add data structures for inline data
 feature
Date: Mon, 13 Aug 2012 16:10:03 +0800
Message-ID: <20120813081003.GC21093@gmail.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
 <1343735309-30579-7-git-send-email-wenqing.lz@taobao.com>
 <20120807185053.GA30272@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35336 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2HMIBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2012 04:01:13 -0400
Received: by pbbrr13 with SMTP id rr13so6862657pbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2012 01:01:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120807185053.GA30272@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 07, 2012 at 02:50:53PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 31, 2012 at 07:47:59PM +0800, Zheng Liu wrote:
> > +struct ext2_ext_attr_ibody_header {
> > +	__u32	h_magic;
> > +};
> > +
> 
> I've searched through the entire patch series, and I don't find any
> usage of h_magic, and in fact the only place this structure definition
> is used is in ext2fs_get_inline_xattr_pos().
> 
> So that's a bit worrying; if this is a magic number, then it should be
> checked (and an error returned if the magic number is not what we
> expect it tobe).  Add checks into e2fsck would also be a really good
> idea.  Also, what is the value that h_magic is epxected to be?  It
> needs to be defined here.
> 
> It's also clear from looking at this function that this patch
> significantly changes the layout of the extended attribute block of
> data.  It would be a really good idea to add some ascii art to
> document exactly what is going on.  A diagram so it's obvious to
> future developers about the data layout is really needed.

Thanks, I will fix it.

Regards,
Zheng
