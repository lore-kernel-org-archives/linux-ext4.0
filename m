From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: regression test for resizing inodes on a
 metadata_csum fs
Date: Sat, 13 Dec 2014 22:19:12 -0500
Message-ID: <20141214031912.GO29787@thunk.org>
References: <20141112224753.GJ10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54918 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaLNDTS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 22:19:18 -0500
Content-Disposition: inline
In-Reply-To: <20141112224753.GJ10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2014 at 02:47:53PM -0800, Darrick J. Wong wrote:
> Regression test for a problem inadvertently fixed by the patchset
> "e2fsprogs/tune2fs: fix memory leak in inode_scan_and_fix()" by Xiaoguang Wang.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This was applied earlier, but it looks like I forgot to ack it.  Thanks!!

     	 	 	      	 - Ted
