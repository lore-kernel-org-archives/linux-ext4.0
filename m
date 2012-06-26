From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: RE: Extent Depth Histogram Fsck
Date: Tue, 26 Jun 2012 18:07:10 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC804A3B3@SN2PRD0202MB144.namprd02.prod.outlook.com>
References: <0408C81F72528E40A0D3235A1F67FFC804A37F@SN2PRD0202MB144.namprd02.prod.outlook.com>,<55654AE5-17FE-44EC-B7FE-A8D5FAAB3560@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:33037
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2FZSHS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 14:07:18 -0400
In-Reply-To: <55654AE5-17FE-44EC-B7FE-A8D5FAAB3560@dilger.ca>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ok i see!
So when there are like
3/3/4 that means double index blocks?? How many extents can a single extent index hold in a block?
________________________________________
From: Andreas Dilger [adilger@dilger.ca]
Sent: Tuesday, June 26, 2012 11:40 AM
To: Nelson, John R
Cc: linux-ext4@vger.kernel.org
Subject: Re: Extent Depth Histogram Fsck

On 2012-06-26, at 8:34 AM, Nelson, John R wrote:
> What does the extent depth histogram mean? Is it a measure of something?
>
> like mine is
>
>
> Extent depth histogram: 36010/81

This means that of all the extent-mapped files in the filesystem,
36010 files have an extent tree of depth 0 (i.e. they fit inside the inode)
81 files have an extent tree of depth 1 (i.e. there is a single index block)

Typically, files larger than 4 * 128MB = 512MB need an index block, but if
the maximum-sized extents cannot be allocated then an index block will be needed for smaller files.  Only if you have very large files (> 40GB),
or a very fragmented free space would you need more than a single level
of index blocks.

Cheers, Andreas







