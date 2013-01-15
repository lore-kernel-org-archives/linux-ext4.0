From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Tue, 15 Jan 2013 14:57:41 -0500
Message-ID: <20130115195741.GG17719@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
 <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com>
 <20130115031006.GB31857@thunk.org>
 <20130115191254.GD17719@thunk.org>
 <50F5B209.40900@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43579 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab3AOT5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:57:45 -0500
Content-Disposition: inline
In-Reply-To: <50F5B209.40900@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 02:46:17PM -0500, Phillip Susi wrote:
> 
> Does this mean that a cluster is the minimum allocation unit, or can
> two small files allocate different blocks in the same cluster, leaving
> the cluster partially used?  If the former, then how is this different
> than just using a larger block size?

The former.  The difference is that we use units of blocks in the
indirect blocks and extents --- and the reason for this is because
there's a pretty fundamental limitation baked into the MM layer that
the file system block size is less than or equal to the page size.  So
on architectures where we have 16k page sizes, we can use a 16k block
size --- but then you won't be able to mount that file system on an
x86 system.

So bigalloc is basically a hack because it was easier to make this
change in the file system than it is to deal with block sizes greater
than the page size.

						- Ted
