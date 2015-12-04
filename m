From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: confirm slow/dangerous operations
Date: Fri, 4 Dec 2015 18:36:16 -0500
Message-ID: <20151204233616.GF18359@thunk.org>
References: <20151203204024.GI10580@birch.djwong.org>
 <ADF3DE2C-3BAF-4678-8B9B-7220F3333FE1@dilger.ca>
 <20151204230745.GJ10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39865 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbLDXgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Dec 2015 18:36:20 -0500
Content-Disposition: inline
In-Reply-To: <20151204230745.GJ10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2015 at 03:07:45PM -0800, Darrick J. Wong wrote:
> 
> Ted took it, but I don't think he's pushed his tree to kernel.org recently.

I pushed to kernel.org a few days ago, and that patch is there:

http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=next&id=c5b3ae7fb5d58dd12a1e02c2443bad32c8a76150

						- Ted
