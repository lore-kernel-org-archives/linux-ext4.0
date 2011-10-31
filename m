From: Ted Ts'o <tytso@mit.edu>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 12:22:23 -0400
Message-ID: <20111031162223.GD16825@thunk.org>
References: <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu>
 <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com>
 <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu>
 <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com>
 <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
 <4EACE2B7.9070402@coly.li>
 <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu>
 <4EAE6BD4.9080705@coly.li>
 <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu>
 <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "i@coly.li" <i@coly.li>, Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55852 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab1JaQW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 12:22:28 -0400
Content-Disposition: inline
In-Reply-To: <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 31, 2011 at 10:08:20AM -0600, Andreas Dilger wrote:
> On 2011-10-31, at 4:22 AM, Theodore Tso <tytso@MIT.EDU> wrote:
> For cluster file systems, such as when you might build Hadoop on top
> > of ext4, there's no real advantage of using RAID arrays as opposed
> > to having single file systems on each disk.  In fact, due to the
> > specd of being able to check multiple disk spindles in parallel,
> > it's advantageous to build cluster file systems on single disk
> > file systems.
> 
> For Lustre at least there are a number of reasons why it uses large
> RAID devices to store the data instead of many small devices: -
> fewer devices that need to be managed. Lustre runs on systems with
> more than 13000 drives, and having to manage connection state for
> that many internal devices is a lot of overhead.

Well, per the discussion on the ext4 call, with Lustre hardware
multiple RAID LUN's get used, so while they might have tens of
petabytes of data, it is still split across a thousand hardware LUN's
or so.  So there is a middle ground between "put all of your 13000
devices on a single hardware RAID LUN", and "use 13000 file systems".
And in that middle ground, it seems surprising that someone would be
bumping into the the 1EB file system limit offered by ext4.

I'm curious why TaoBao is so interested in changing the extent
encoding for bigalloc file systems.  Currently we can support up to 1
EB worth of physical block numbers, and 16TB of logical block numbers.
Are you concerned about bumping into the 1 EB file system limit?  Or
the 16 TB file size limit?  Or something else?

Regards,

						- Ted
