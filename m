From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: directly leave out of
 ext4_find_delalloc_range() if filesystem mount with "nodelalloc"
Date: Mon, 19 Dec 2011 10:39:07 -0500
Message-ID: <20111219153907.GA27501@thunk.org>
References: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
 <1323327594-4914-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43361 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1LSPjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 10:39:12 -0500
Content-Disposition: inline
In-Reply-To: <1323327594-4914-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 08, 2011 at 02:59:54PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> We found performance regression when using bigalloc with "nodelalloc"  (1MB cluster size):
> 
> 1. mke2fs -C 1048576 -O ^has_journal,bigalloc /dev/sda
> 2. mount -o nodelalloc /dev/sda /test/
> 3. time dd if=/dev/zero of=/test/io bs=1048576 count=1024
> 
> The "dd" will cost about 2 seconds to finish, but if we mke2fs without "bigalloc",
> "dd" will only cost lesss than 1 second.
> 
> The reason is:  when using ext4 with "nodelalloc", it will call ext4_find_delalloc_cluster() nearly
> everytime it call ext4_ext_map_blocks(), and ext4_find_delalloc_range() will also scan all pages
> in cluster because no buffer is "delayed".
> A cluster has 256 pages (1MB cluster), so it will scan 256 * 256k pags when creating a 1G file. That
> severely hurts the performance.
> 
> Therefore, we return out from ext4_find_delalloc_range() when using "nodelalloc".
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, applied.

					- Ted
