From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Wed, 16 Jan 2013 09:59:18 -0500
Message-ID: <20130116145918.GC6052@thunk.org>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
 <20130115185509.GA17719@thunk.org>
 <20130116120455.GA21029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43788 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab3APO7X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2013 09:59:23 -0500
Content-Disposition: inline
In-Reply-To: <20130116120455.GA21029@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2013 at 08:04:56PM +0800, Zheng Liu wrote:
> Yeah, it allows us to skip to the next data/hole directly if the extents
> interface is used.  But if we do that, we will need to handle
> extent-based file and indirect-based file resptively like this.
> 
>         if (inode->i_flags & EXT4_EXTENTS_FL) {
>                 ext2fs_file_ext_llseek_data();
>                 ...
>         } else {
>                 ext2fs_file_ind_llseek_data();
>                 ...
>         }
> 
> I am not sure whether it is too complicated or not for us.  What do you
> think?

I'm not too worried about the performance issues for debugfs.  But for
clients who are accessing ext[234] using libext2fs and FUSE, they
would probably notice in at least some circumstances.  I'm not that
worried about the complexity, but it's also not a high priority thing,
either --- it's a "nice to have", not a "must have".

Regards,

					- Ted
