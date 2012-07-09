From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3 v3] ext4: add dio overwrite nolock
Date: Mon, 9 Jul 2012 11:01:19 -0400
Message-ID: <20120709150118.GE3649@thunk.org>
References: <1341152506-32649-1-git-send-email-wenqing.lz@taobao.com>
 <1341152506-32649-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Robin Dong <hao.bigrat@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38041 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab2GIPBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 11:01:24 -0400
Content-Disposition: inline
In-Reply-To: <1341152506-32649-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01, 2012 at 10:21:46PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Aligned and overwrite direct I/O can be parallelized.  In ext4_file_dio_write,
> we first check whether these conditions are satisfied or not.  If so, we
> take i_data_sem and release i_mutex lock directly.  Meanwhile iocb->private is
> set to indicate that this is a dio overwrite, and it will be handled in
> ext4_ext_direct_IO.
> 
> CC: Tao Ma <tm@tao.ma>
> CC: Eric Sandeen <sandeen@redhat.com>
> CC: Robin Dong <hao.bigrat@gmail.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
