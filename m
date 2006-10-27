From: sho@tnes.nec.co.jp
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 16:23:26 +0900
Message-ID: <20061027162326sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:36784 "EHLO
	tyo202.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S1946165AbWJ0HXP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 03:23:15 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162] (may be forged))
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id k9R7NErT013545
	for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2006 16:23:14 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id k9R7NEh11737 for linux-ext4@vger.kernel.org; Fri, 27 Oct 2006 16:23:14 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id k9R7NDo08733 for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2006 16:23:13 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061027.162749.09301964 for <linux-ext4@vger.kernel.org>
	; Fri, 27 Oct 2006 16:27:49 +0900
To: alex@clusterfs.com
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi,

> TT> On Mon, Oct 23, 2006 at 02:27:10PM +0200, Jan Kara wrote:
> >> Hello,
> >>
> >> I've written a simple patch implementing ext3 ioctl for file
> >> relocation. Basically you call ioctl on a file, give it list of blocks
> >> and it relocates the file into given blocks (provided they are still
> >> free). The idea is to use it as a kernel part of ext3 online
> >> defragmenter (or generally disk access optimizer).
>
>isn't that a kernel responsbility to find/allocate target blocks?
>wouldn't it better to specify desirable target group and minimal
>acceptable chunk of free blocks?

Agreed.

I am considering the online defrag function for ext4 and thinking
that your following patch set for multi-block allocation is useful
to search contiguous free blocks for the defragmentation.

"[RFC] extents,mballoc,delalloc for 2.6.16.8" 
http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2

I will send the patch of simple defrag implementation for ext4 later.

Cheers, Takashi
