From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH v3 04/11] e4defrag: Use e2p_get_fragscore() for decision
 of whether to defrag
Date: Fri, 18 Nov 2011 17:40:23 +0900
Message-ID: <4EC619F7.405@sx.jp.nec.com>
References: <20111114182217.GH7698@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:65268 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1KRIlX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 03:41:23 -0500
In-Reply-To: <20111114182217.GH7698@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/15 3:22, Ted Ts'o wrote:
> On Mon, Nov 14, 2011 at 03:24:31PM +0900, Kazuya Mio wrote:
>> This makes e4defrag use e2p_get_fragscore() to calculate fragmentation score.
>> If the fragmentation score of the original file is non-zero and
>> the fragmentation score of donor file is zero, e4defrag calls
>> EXT4_IOC_MOVE_EXT ioctl. Because the fragmentation will get better in this case.
>>
>> e4defrag uses 4096 as the threshold of fragmentation because the bigger
>> threshold(<4096) has little effect on the performance from the following
>> results of my experiment.
>
> One of the things that has long bothered me about the whole
> "fragmentation score" concept is that it's not clear to me how well it
> works across different sized files.  For your experiment you used a

The logic of the fragmentation score seems to be complex, but it is easy
to understand what the fragmentation score means. Because if the score of
the file is non-zero, the file has bad fragmentation that leads to
the performance loss. e4defrag allocates the contiguous blocks for such a file
to bring close to the better performance.

The reason why the type of the fragmentation score is not a boolean is to
compare how badly the fragmentation is. In some cases, it is difficult
to allocate the contiguous blocks, so the fragmentation score of the created
files will be non-zero. e4defrag -F uses the score to confirm whether
the fragmentation gets better, and if so, e4defrag calls EXT4_IOC_MOVE_EXT
ioctl.

> 4GB fragmented file.  But does the threshold change if the file is
> substantially smaller?  What if it is substantially larger?

I easily measured the performance by the same test in different file size
(use 256MB or 64GB fragmented file), but the results had a similar tendency
as the previous one. The difference was insignificant.

> I do like the change to tune2fs that removes printing the
> fragmentation score, because I think it's highly misleading what it
> means, especially when comparing two file's fragmentation score across
> two different files which may be of significantly different size.
>
> Perhaps we would be better off if we just simply called this "number
> of discontiguous blocks?" and just left it at that?   Just a thought...

There are some cases that discontiguous blocks are certainly allocated.
(e.g. hole file, the file created by write and fallocate)
Moreover, if the length of contiguous blocks is not clear, we can't tell
whether defrag is required.

Regards,
Kazuya Mio
