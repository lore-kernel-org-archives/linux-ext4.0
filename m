From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4] ext4:Let ext4_ext_fiemap_cb() handle blocks before
 request range correctly.
Date: Tue, 24 May 2011 11:42:12 -0400
Message-ID: <20110524154212.GA26055@thunk.org>
References: <1306134178-9883-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com, amir73il@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49998 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1EXPmQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 11:42:16 -0400
Content-Disposition: inline
In-Reply-To: <1306134178-9883-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 03:02:58PM +0800, Yongqiang Yang wrote:
> To get delayed-extent information, ext4_ext_fiemap_cb() looks up
> pagecache, it thus collects information starting from a page's
> head block.
> 
> If blocksize < pagesize, the beginning blocks of a page may lies
> before the request range. So ext4_ext_fiemap_cb() should proceed
> ignoring them, because they has been handled before. If no mapped
> buffer in the range is found in the 1st page, we need to look up
> the 2nd page, otherwise delayed-extents after a hole will be ignored.
> 
> Without this patch, xfstests 225 will hung on ext4 with 1K block.
> 
> Reported-by: Amir Goldstein <amir73il@users.sourceforge.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 tree.

					- Ted
