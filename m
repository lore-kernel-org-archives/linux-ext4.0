From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Tue, 15 Jan 2013 17:28:24 -0500
Message-ID: <20130115222824.GA5073@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
 <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com>
 <20130115031006.GB31857@thunk.org>
 <20130115191254.GD17719@thunk.org>
 <50F5B209.40900@ubuntu.com>
 <20130115195741.GG17719@thunk.org>
 <50F5BE57.1000305@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43640 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab3AOW23 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:29 -0500
Content-Disposition: inline
In-Reply-To: <50F5BE57.1000305@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 03:38:47PM -0500, Phillip Susi wrote:
> 
> If it is only to get around the mm pagesize limit, then why not just
> have the fs automatically lie to the kernel about the block size and
> shift the references back and forth on the fly when it detects a
> larger blocksize?

Because of the pain in dealing with how to handle random writes into a
sparse file.  We need to either track which blocks in the large block
have been initialized, or we would need to erase the entire large
block before writing the first page into the large block (and then you
still need to track whether or not you are writing that first or
subsequent page into a large block).

What we're doing with bigalloc is effectively tracking which blocks in
the cluster have been initialized by using entries in the extent tree,
since entries to the allocation bitmaps is in units of clusters, but
entries in the extent tree is in units of blocks.

Looking back at how complicated it has been to get delalloc right, it
may have been the case that just using a brute-force sb_issue_zeroout
when the block is freshly allocated, unless the arguments to the
request to ext4_writepages() exactly covered the large block might
have been simpler.  Getting the Direct I/O path right would have been
messy, but perhaps it would have been less work in the end.

       	   	      	    	      - Ted
