From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Thu, 27 Oct 2011 07:48:34 -0400
Message-ID: <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:63648 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab1J0Lsl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 07:48:41 -0400
In-Reply-To: <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 27, 2011, at 5:38 AM, Andreas Dilger wrote:

> Writing 64kB is basically the minimum useful unit of IO to a modern disk drive, namely if you are doing any writes then zeroing 64kB isn't going to be noticeably slower than 4kB or 16kB. 

That may be true if the cluster size is 64k, but if the cluster size is 1MB, the requirement to zero out 1MB chunks each time a 4k block is written would be painful. 

> 
>> In any case, it's not a simple change that we can make before the merge window.
> 
> Are you saying that bigalloc is already pushed for this merge window?  It sounds like there is someone else working on this issue already, and I'd like to give them and me a chance to resolve it before the on-disk format of bigalloc is cast in stone.

Yes, it's already in the ext4 and e2fsprogs tree, and it's due to be pushed to Linus this week.  E2fsprogs with bigalloc support just entered Debian testing, so it's really too late change the bigalloc format without a new feature flag.

> This is all a bit hand wavy, since I admit I haven't yet dug into this code, but I don't think it has exactly the same issues as large blocks, since fundamentally there are not multiple pages that address the same block number, so the filesystem can properly address the right logical blocks in the filesystem.

That's a good point, but we could do that with a normal 64k block file system.   The block number which we use on-disk can be in multiples of 64k, but the "block number" that we use in the bmap function and in the bh_blocknr field attached to the pages could be in units of 4k pages.

This is also a bit hand-wavy, but if we also can handle 64k directory blocks, then we could mount 64k block file systems as used in IA64/Power HPC systems on x86 systems, which would be really cool.

-- Ted


