From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 10:08:20 -0600
Message-ID: <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li> <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "i@coly.li" <i@coly.li>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:27308 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054Ab1JaQH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 12:07:28 -0400
In-Reply-To: <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-31, at 4:22 AM, Theodore Tso <tytso@MIT.EDU> wrote:

> For cluster file systems, such as when you might build Hadoop on top of ext4, there's no real advantage of using RAID arrays as opposed to having single file systems on each disk.  In fact, due to the specd of being able to check multiple disk spindles in parallel, it's advantageous to build cluster file systems on single disk file systems.

For Lustre at least there are a number of reasons why it uses large RAID devices to store the data instead of many small devices:
- fewer devices that need to be managed. Lustre runs on systems with more than 13000 drives, and having to manage connection state for that many internal devices is a lot of overhead. 