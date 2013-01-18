From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Fri, 18 Jan 2013 18:07:11 +0800
Message-ID: <20130118100711.GC20442@gmail.com>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
 <20130115185509.GA17719@thunk.org>
 <20130116120455.GA21029@gmail.com>
 <20130116145918.GC6052@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57716 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3ARJxT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 04:53:19 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so1311485pbc.26
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 01:53:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130116145918.GC6052@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2013 at 09:59:18AM -0500, Theodore Ts'o wrote:
> On Wed, Jan 16, 2013 at 08:04:56PM +0800, Zheng Liu wrote:
> > Yeah, it allows us to skip to the next data/hole directly if the extents
> > interface is used.  But if we do that, we will need to handle
> > extent-based file and indirect-based file resptively like this.
> > 
> >         if (inode->i_flags & EXT4_EXTENTS_FL) {
> >                 ext2fs_file_ext_llseek_data();
> >                 ...
> >         } else {
> >                 ext2fs_file_ind_llseek_data();
> >                 ...
> >         }
> > 
> > I am not sure whether it is too complicated or not for us.  What do you
> > think?
> 
> I'm not too worried about the performance issues for debugfs.  But for
> clients who are accessing ext[234] using libext2fs and FUSE, they
> would probably notice in at least some circumstances.  I'm not that
> worried about the complexity, but it's also not a high priority thing,
> either --- it's a "nice to have", not a "must have".

Understood.  Let me try it.

Thanks,
                                                - Zheng
