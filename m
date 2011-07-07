From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Thu, 07 Jul 2011 19:40:02 +0900
Message-ID: <4E158D02.10802@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com> <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com> <4E044AB4.9010804@sx.jp.nec.com> <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com> <4E09AB2A.6000105@sx.jp.nec.com> <BANLkTikZwscrs4F1NeVRKBTPSouthhMgSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61811 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1GGKkn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2011 06:40:43 -0400
In-Reply-To: <BANLkTikZwscrs4F1NeVRKBTPSouthhMgSg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I come up with the new fragmentation score based on your comments.
The interface of new libe2p function will be as follows:

int e2p_get_fragscore(int fd, __u32 threshold, __u32 max_chunk_blks)

This function returns the fragmentation score that shows how badly fragmented
the file might be. The score is extents per @threshold, so the higher score
means the worse fragmentation.

Fragmentation score treats extents, whose file offset continues and
whose status is the same, as one chunk. If the number of extents
in chunk is equal to the ideal number of extents, the chunk is not used for
the fragmentation score because there is no fragment in the chunk.
The ideal number of extents is calculated based on @max_chunk_blks.

In case of ext4, @max_chunk_blks is 32768 blocks. If you have 128MB file
with two extents, these two extents are used for the calculation of
the fragmentation score because the ideal number of extents in this file is one.

e4defrag will judge the necessity of calling EXT4_IOC_MOVE_EXT ioctl by
fragmentation score. If the fragmentation score of defrag target file is
more than one, and the score of the file created by fallocate is zero,
e4defrag will call the ioctl. I'll decide the better value of threshold during
some tests. If you must do e4defrag to the specified file, you will be able to
force defrag by using new option of e4defrag.


Two examples (@threshold=256, @max_chunk_blks=32768):

# filefrag -v fragment
Filesystem type is: ef53
File size of fragment is 409600 (100 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    33807              16
    1      16    32848    33822     84 eof
fragment: 2 extents found

This small file has two extents, so it is fragmented. The calculation is
as follows:

fragmentation score = 2 / (100 / 256)
                     = 5 extents / MB.

# filefrag -v not_fragment
Filesystem type is: ef53
File size of not_fragment is 125829120 (30720 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    33823              16
    1      16    32944    33838     48
    2      64    33152    32991     64
    3     128    34304    33215  30592 eof
not_fragment: 4 extents found

This file has four extents included one large extent. So the score is zero
in this case.

fragmentation score = 4 / (30720 / 256)
                     = 0 extents / MB.

Regards,
Kazuya Mio
