From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Tue, 15 Jan 2013 21:02:11 +0800
Message-ID: <20130115130211.GA13492@gmail.com>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
 <20130115032329.GC31857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52084 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3AOMsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 07:48:24 -0500
Received: by mail-pb0-f53.google.com with SMTP id jt11so24583pbb.12
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 04:48:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130115032329.GC31857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:23:29PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 14, 2013 at 10:18:30PM +0800, Zheng Liu wrote:
> > 
> > ext2fs_file_llseek_data/hole() seem to be weird because ext2_file_t
> > structure is hidden by a typedef.  The caller can not dereference
> > it.  So I define a marco called EXT2_SEEK_OFFSET_INVALID to let the
> > caller indicate that it find the data/hole from ext2_file_t->pos or
> > from offset.  What do you think?
> 
> Is the problem you're worried about is that the user can't get current
> location?
> 
> That's pretty easy to solve.  You can get it the same way it works
> with the lseek(2) system call.
> 
>      retval = ext2fs_file_llseek(file, 0, SEEK_CUR, &pos);
> 
> Upon the return, pos will be contain the current file offset.

Ah, I see.  I will remove EXT2_SEEK_OFFSET_INVALID flag in next version.

Thanks,
                                                - Zheng
