From: Ted Ts'o <tytso@mit.edu>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 15:38:37 -0400
Message-ID: <20111031193837.GH16825@thunk.org>
References: <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu>
 <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com>
 <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
 <4EACE2B7.9070402@coly.li>
 <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu>
 <4EAE6BD4.9080705@coly.li>
 <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu>
 <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca>
 <20111031162223.GD16825@thunk.org>
 <4EAEDD56.6000709@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Coly Li <i@coly.li>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56679 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1JaTim (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 15:38:42 -0400
Content-Disposition: inline
In-Reply-To: <4EAEDD56.6000709@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 01:39:34AM +0800, Coly Li wrote:
> In some application, we allocate a big file which occupies most space of a file system, while the file system built on
> (expensive) SSD. In such configuration, we want less blocks allocated for inode table and bitmap. If the max extent
> length could be much big, there is chance to have much less block groups, which results more blocks for regular file.
> Current bigalloc code does well already, but there is still chance to do better. The sys-admin team believe
> cluster-based-extent can help Ext4 to consume as less meta data memory as raw disk does, and gain as more available data
> blocks as raw disks does, too. This is a small number on one single SSD, but in our cluster environment, this effort can
> help to save a recognized amount of capex.

OK, but you're not running into the 16TB file size limitation, are
you?  That would be a lot of SSD's.  I assume the issue then is you
want to minimize the number of extents, limited by the 15-bit extent
length field?

What cluster size are you thinking about?  And how do you plan to
initialize it?  Via fallocate, or by explicitly writing zeros to the
whole file (so all of the blocks are marked as initialzied?  Is it
going to be sparse file?

	   	   	      	       - Ted
