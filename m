From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Mon, 14 Jan 2013 22:23:29 -0500
Message-ID: <20130115032329.GC31857@thunk.org>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43419 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab3AODXc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 22:23:32 -0500
Content-Disposition: inline
In-Reply-To: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:18:30PM +0800, Zheng Liu wrote:
> 
> ext2fs_file_llseek_data/hole() seem to be weird because ext2_file_t
> structure is hidden by a typedef.  The caller can not dereference
> it.  So I define a marco called EXT2_SEEK_OFFSET_INVALID to let the
> caller indicate that it find the data/hole from ext2_file_t->pos or
> from offset.  What do you think?

Is the problem you're worried about is that the user can't get current
location?

That's pretty easy to solve.  You can get it the same way it works
with the lseek(2) system call.

     retval = ext2fs_file_llseek(file, 0, SEEK_CUR, &pos);

Upon the return, pos will be contain the current file offset.

     	 	     	     	     	 	 - Ted
