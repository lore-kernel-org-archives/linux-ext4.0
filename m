From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 15:17:05 -0700
Message-ID: <1248905825.4035.142.camel@mingming-laptop>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
	 <6601abe90907290910x7cf1122cwac689d1f106326d3@mail.gmail.com>
	 <4A708451.4060908@redhat.com>  <4A70A77B.6080006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:46689 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZG2WRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2009 18:17:16 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6TMDnPE028635
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 16:13:49 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6TMHG77250880
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 16:17:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6TMHG60020941
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 16:17:16 -0600
In-Reply-To: <4A70A77B.6080006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-07-29 at 14:48 -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> ...
> 
> > Also, IIRC xfs does the conversion to written (vs. unwritten) extents in
> > an IO completion handler, just FWIW.
> 
> After talking w/ Jeff Moyer, realized that w/o using the io completion,
> there's a race with AIO.
> 
> Userspace will get notified that the write is done before the extents
> get flipped to initialized ....

Yes, for the AIO case, the DIO submit the IO and returns without waiting
for IO to complete. If we do conversion in ext4_direct_IO, then we could
convert the extents before the real IO hit to disk. Could cause stale
data exposed if crash before the data written to disk.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


