From: Tao Ma <tm@tao.ma>
Subject: Re: bigalloc and max file size
Date: Thu, 27 Oct 2011 09:05:49 +0800
Message-ID: <4EA8AE6D.6050907@tao.ma>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43999 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277Ab1J0BF4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 21:05:56 -0400
In-Reply-To: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,
On 10/27/2011 07:36 AM, Andreas Dilger wrote:
> Ted,
> we were having a discussion about bigalloc and the maximum file size
> (as limited by the 2^32 logical block number in struct ext4_extent).
> 
> Currently the maximum file size is blocksize * 2^32, 16TB for 4kB blocks.
> 
> Since it is not possible to allocate sub-blocks in the bigalloc code,
> what about storing the "chunk number" in the extent logical block?
> This would allow us to create files up to chunksize * 2^32.  With
> a bigalloc chunk size of 1MB we could have a maximum file size of
> 2^(20 + 32) = 2^52 = 4PB, which is within spitting distance of the
> maximum filesystem size of 2^56 bytes (4kB blocks * 2^48 blocks)
> with the current extent format, and beyond reasonable limits today.
> 
> This essentially allows creating files as large as the filesystem size
> without having to change the extent format, which is a good thing.
> 
> Is this implemented in bigalloc?  If not, it would be great to do
> this before landing bigalloc in the upstream kernel, since it is
> basically free to do, can already fall under the INCOMPAT_BIGALLOC
> feature flag, and avoids issues in the near future.  I don't think
> the e2fsprogs with bigalloc support is released yet either, so it
> should still be OK to change the on-disk format?
That is also our need here. ;) We have asked Ted about it, and Ted had
expressed his concern. Please searched the mailist for the subject
"Question about BIGALLOC".

ocfs2 has implemented similar mechanism for the file's extents and it
seems to work by now. But ocfs2 doesn't have delayed allocation, so the
case may not be the same here. Anyway, one of my colleague Robin is
trying to change extent length from blocks to clusters. I'd like him to
update his process here.

Thanks
Tao
