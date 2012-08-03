From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Fri, 3 Aug 2012 00:01:15 -0400
Message-ID: <20120803040115.GC4253@thunk.org>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
 <20120801071935.GA12929@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: semenko@syndetics.net, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, mangoo@wpkg.org, djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42767 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab2HCEBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2012 00:01:24 -0400
Content-Disposition: inline
In-Reply-To: <20120801071935.GA12929@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 03:19:35PM +0800, Zheng Liu wrote:
> Subject: [PATCH] tune2fs: clear error code before rewriting directory when metadata_csum enabled
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we enable metadata_csum feature in tune2fs, all inodes need to be rewrited
> to calculate checksum.  In this process, the inode that has been removed also
> needs to calculate checksum, but the extent tree in these inodes has been clear.
> Thus, we cannot read any extents, and an 'EXT2_ET_EXTENT_NO_NEXT' error is
> returned back.  But in this condition error code in rewrite_dir_context doesn't
> be initialized, and it causes an unknown error.

Thanks, I've merged this into my e2fsprogs checksum branch.

I've promoted all of the metadata checksum patches in e2fsprogs into
the next branch.  

At that point I'll strongly suggest that people use the development
branch (currently the next branch, but in the next or two, the master
branch) of e2fsprogs.  For the kernel, for now I suggest using the
v3.5 kernel with the ext4_for_linus (commit 03179fe92318) from the
ext4.git tree merged in.  Hopefully the necessary bug fix commits will
be in the v3.5.1 kernel, but the 3.5.y series hasn't been released
yet.

						- Ted
