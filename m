From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: O_DIRECT and delayed allocation question
Date: Fri, 19 Jun 2009 17:25:01 +0530
Message-ID: <20090619115500.GE17784@skywalker>
References: <6601abe90906181253u657e67a7u67025774cc53bc4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49426 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110AbZFSLzH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jun 2009 07:55:07 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5JLt8rl024287
	for <linux-ext4@vger.kernel.org>; Sat, 20 Jun 2009 07:55:08 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5JBt8J6479328
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2009 21:55:08 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5JBt8k8028932
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2009 21:55:08 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90906181253u657e67a7u67025774cc53bc4f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 18, 2009 at 12:53:17PM -0700, Curt Wohlgemuth wrote:
> This might be a question with an obvious answer, but I'd like
> verification one way or the other.
> 
> Does the use of O_DIRECT essentially disable delayed allocation for a
> given file?
> 
> My simple tests show a larger degree of block fragmentation for files
> written using O_DIRECT than without, and on its face, this makes sense
> to me.  This fragmentation can be removed by using fallocate() on a
> file before extending it with writes.
> 
> (Strictly speaking, I guess the use of O_DIRECT wouldn't "disable"
> delayed allocation, since the blocks are allocated at the "normal"
> time -- when going to disk.  But effectively there would be a lot less
> block grouping available to build large extents if each write goes to
> disk immediately, instead of going through the page cache.)
> 

exactly. So it is possible that we are getting smaller number of block
request in O_DIRECT case. But you should still see better block
allocation because of mballoc. mballoc normalize the input block request
count based on the file size. w.r.t fallocate I have noticed one problem with O_DIRECT
which is explained in the url below. So there may be performance impact on using
O_DIRECT with fallocate.

http://article.gmane.org/gmane.comp.file-systems.ext4/13762

-aneesh
