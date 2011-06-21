From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Tue, 21 Jun 2011 20:28:05 +0900
Message-ID: <4E008045.1040909@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53248 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FUL3V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 07:29:21 -0400
In-Reply-To: <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/18 16:19, Andreas Dilger wrote:
> I was thinking about this, and am wondering if it makes sense to have an absolute score for fragmentation
> instead of a relative one?
>
> By absolute I mean something like fragments per MB or similar. A bad score might be anything>  1. For
> files smaller than 1 MB in size it would scale the ratio to the equivalent if the file was 1MB in size
> (e.g. a 16kB file with 4 fragments would have a score of 256, which is clearly bad).  Large files can
> have a score much less than 1, which is good.

I think fragments per MB is easy to understand. I will fix the library function
to "double e2p_get_fragscore(int fd)". To return fragments per MB, it will
get the number of extents and the total length of extents except the following
special cases:
- The extent whose initialize status is different from the next extent
- There is a hole between the extent and the next extent
- The extent is a tail

The output of filefrag would be as follows:

# filefrag /mnt/mp1/testfile
/mnt/mp1/testfile: 4 extents found, 0.75 fragments/MB

Regards,
Kazuya Mio

