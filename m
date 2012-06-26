From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Extent Depth Histogram Fsck
Date: Tue, 26 Jun 2012 09:40:59 -0600
Message-ID: <55654AE5-17FE-44EC-B7FE-A8D5FAAB3560@dilger.ca>
References: <0408C81F72528E40A0D3235A1F67FFC804A37F@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61012 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2FZPlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 11:41:00 -0400
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A37F@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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





