From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Fri, 24 Jun 2011 17:28:36 +0900
Message-ID: <4E044AB4.9010804@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com> <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64491 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1FXI3u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 04:29:50 -0400
In-Reply-To: <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Greg,
I'm sorry for the late reply.

2011/06/23 20:16, Greg Freemyer wrote:
> For a sparse file, can you explain why you treat the head and tail
> extents of a block group differently?

Could you tell me what "block group" you said means?

If "block group" means the ext4 block group, I will treat the head and tail
extents of a block group the same way.

And if "block group" means the chunk of the extents whose offset is continued,
I will treat only the tail extents as a special case.

# filefrag -v /mnt/mp1/file
Filesystem type is: ef53
File size of /mnt/mp1/file is 285212672 (69632 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    34816           30720
    1   30720    65536            2048 unwritten
    2   65536    67584            4096 unwritten,eof
/mnt/mp1/file: 1 extent found

The case is not fragmented. The length of #1 extent is a little bit short,
but there is no point in doing defragmentation because of the hole existence.

Regards,
Kazuya Mio
