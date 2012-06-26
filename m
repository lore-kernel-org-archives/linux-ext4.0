From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Extent Depth Histogram Fsck
Date: Tue, 26 Jun 2012 14:07:51 -0600
Message-ID: <C08A2B0F-07BC-4151-A2B3-6D6AEBDD9AB2@gmail.com>
References: <0408C81F72528E40A0D3235A1F67FFC804A37F@SN2PRD0202MB144.namprd02.prod.outlook.com> <55654AE5-17FE-44EC-B7FE-A8D5FAAB3560@dilger.ca> <0408C81F72528E40A0D3235A1F67FFC804A3B3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60198 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2FZUHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 16:07:37 -0400
Received: by pbbrp8 with SMTP id rp8so529537pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2012 13:07:36 -0700 (PDT)
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A3B3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-26, at 12:07, "Nelson, John R" <John_Nelson@student.uml.edu> wrote:

> ok i see!
> So when there are like
> 3/3/4 that means double index blocks?? How many extents can a single extent index hold in a block?

The header takes 12 bytes, and each extent or index pointer takes 12 bytes, so for 4kB blocksize there can be (4096 / 12) - 1 = 340 extents per block.

The maximum extent size for 4kB blocks is 2^15*4kB = 128MB, so each index block can map up to ~42GB, so a two-level tree can map just over 14TB under ideal conditions. 

Cheers, Andreas

> ________________________________________
> From: Andreas Dilger [adilger@dilger.ca]
> Sent: Tuesday, June 26, 2012 11:40 AM
> To: Nelson, John R
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Extent Depth Histogram Fsck
> 
> On 2012-06-26, at 8:34 AM, Nelson, John R wrote:
>> What does the extent depth histogram mean? Is it a measure of something?
>> 
>> like mine is
>> 
>> 
>> Extent depth histogram: 36010/81
> 
> This means that of all the extent-mapped files in the filesystem,
> 36010 files have an extent tree of depth 0 (i.e. they fit inside the inode)
> 81 files have an extent tree of depth 1 (i.e. there is a single index block)
> 
> Typically, files larger than 4 * 128MB = 512MB need an index block, but if
> the maximum-sized extents cannot be allocated then an index block will be needed for smaller files.  Only if you have very large files (> 40GB),
> or a very fragmented free space would you need more than a single level
> of index blocks.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 
> 
