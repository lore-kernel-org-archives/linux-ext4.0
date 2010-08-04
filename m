From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Any qualms about reverting 3d0518f4, ext4: New rec_len encoding for very large blocksizes ?
Date: Tue, 3 Aug 2010 18:33:10 -0600
Message-ID: <E451F0D5-F2FB-44A1-BA84-224D7F86F447@dilger.ca>
References: <4C58987B.2040602@redhat.com> <38BC6435-5556-422C-BFA3-A964F6C6E6B9@dilger.ca> <4C589CF2.9030406@redhat.com> <20100803231219.GH9453@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Wei Yongjun <yjwei@cn.fujitsu.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab0HDAeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 20:34:05 -0400
In-Reply-To: <20100803231219.GH9453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-03, at 17:12, Ted Ts'o wrote:
> On Tue, Aug 03, 2010 at 05:49:22PM -0500, Eric Sandeen wrote:
>> As far as I know, reverting it won't break 64kb dir blocks...?
> 
> I seem to recall there was some confusion about what was the correct
> way of recording a rec_len of 64k --- 0 or 65535.  So after reverting
> the patch, we need to make sure we didn't end up breaking
> compatibility with (a) existing file systems and (b) what older
> versions of mke2fs may have generated.

Right - the newer code accepts both EXT4_MAX_REC_LEN and 0 to mean "blocksize".  The old code took EXT4_MAX_REC_LEN to mean "1 << 16".  For filesystems with blocksize < 64k there is no difference, but I think it makes sense to continue to accept both EXT4_MAX_REC_LEN and "0".

>>>> (this does 200 iterations) and got this for the file creations:
>>>> 
>>>> ext4 stock:   Average = 21206.8 files/s
>>>> ext4 patched: Average = 22822.1 files/s
>>>> 
>>>> This is a 7.6% improvement...
> 
> So one way of dealing wih this is making it an inline, and then
> #ifdef'ing out the more complex code if the page size is < 64k....

Should it also be put under "unlikely()", or for that matter, the whole thing could be #ifdef'd out for PAGE_SIZE < 65536 since we won't magically grow blocksize > PAGE_SIZE support without knowing it.

Cheers, Andreas





