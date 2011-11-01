From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Tue, 1 Nov 2011 07:47:58 -0400
Message-ID: <898A7160-25A8-44BA-B08B-C8FADC87F8EA@MIT.EDU>
References: <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li> <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu> <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca> <20111031162223.GD16825@thunk.org> <4EAEDD56.6000709@coly.li> <20111031193837.GH16825@thunk.org> <4EAF471E.3030701@coly.li>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@MIT.EDU>, Andreas Dilger <adilger@dilger.ca>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:45488 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680Ab1KALsC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 07:48:02 -0400
In-Reply-To: <4EAF471E.3030701@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 31, 2011, at 9:10 PM, Coly Li wrote:
> 
>> I assume the issue then is you
>> want to minimize the number of extents, limited by the 15-bit extent
>> length field?
> Not only extents, but also minimize inode table blocks, bitmap blocks.


So this makes no sense to me.  Bigalloc doesn't have any effect on the number of inode table blocks, and while it certainly shrinks the number block allocation bitmap blocks, changing the extent tree format has no effect on the number of bitmap blocks.

Perhaps I'm not making myself clear.  I was trying to figure out the basis for the desire to use units of clusters for the extent length in the extent tree block.    Is that the reason you were so interested in this change of the bigalloc format?   So you could have a smaller extent tree?

>> 
>> What cluster size are you thinking about?
> Currently we test 1MB cluster size. The extreme ideal configuration (of one use case) is, there is only one block group
> on the whole file system. (In this use case) we are willing to try biggest possible cluster size if we are able to.

This is where you have a single file which is nearly as big as the entire file system?   In that case, why are you using an ext4 file system at all?   Why not just use a raw partition instead, plus an auxiliary partition for the smaller files?

I'm not being critical; I'm just trying to understand your use case and constraints.

Regards,

-- Ted

