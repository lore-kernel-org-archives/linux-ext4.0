From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 06:22:24 -0400
Message-ID: <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:61953 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932675Ab1JaKW2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 06:22:28 -0400
In-Reply-To: <4EAE6BD4.9080705@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 31, 2011, at 5:35 AM, Coly Li wrote:

> 
> Back to our topic, Ext4 doesn't have too much on-disk incompatible flag-bits now. If we get current bigalloc code merged now, we have to use another incompatible bit when we merge cluster/chunk based extent patch set.

What is the appeal to you have the cluster/chunk based extent patch set?    I'm not sure I understand why it's so interesting to you in the first place.   Ext4's RAID support isn't particularly good, and its sweet spot really is for single disk file systems.   And for cluster file systems, such as when you might build Hadoop on top of ext4, there's no real advantage of using RAID arrays as opposed to having single file systems on each disk.  In fact, due to the specd of being able to check multiple disk spindles in parallel, it's advantageous to build cluster file systems on single disk file systems.

I'm just curious what your use case is, because that tends to drive decision decisions in subtle ways.

Regards,

-- Ted

