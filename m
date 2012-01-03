From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl
 updates inode
Date: Wed, 4 Jan 2012 00:14:32 +0100
Message-ID: <20120103231432.GA23522@dztty>
References: <20120103013152.GA26455@dztty>
 <20120103124624.GB31457@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:56679 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2ACXL2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 18:11:28 -0500
Content-Disposition: inline
In-Reply-To: <20120103124624.GB31457@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 03, 2012 at 01:46:24PM +0100, Jan Kara wrote:
>   Hello,
> 
> On Tue 03-01-12 02:31:52, Djalal Harouni wrote:
> > 
> > The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
> > this can lead to a race with the other operations that update the same
> > inode.
> > 
> > Patch tested.
>   Thanks for the patch but I don't quite understand the problem.
> i_generation is set when:
>   a) inode is loaded from disk
>   b) inode is allocated
>   c) in SETVERSION ioctl
> 
>   The only thing that can race here seems to be c) against c) and that is
> racy with i_mutex as well. So what problems do you exactly observe without
> the patch?
Right, but what about the related i_ctime change ? (i_ctime is updated in
other places...)

The i_ctime update must reflect the _appropriate_ inode modification
operation. This is why IMHO we should protect them to avoid a lost update.

BTW the i_generation which is used by NFS and fuse filesystems is updated
even if the inode is marked immutable, is this the intended behaviour?


> 								Honza
Thanks for your response.

-- 
tixxdz
http://opendz.org
