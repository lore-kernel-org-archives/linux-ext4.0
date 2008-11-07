From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: a suspected data race bug in Ext4 file system
Date: Fri, 07 Nov 2008 10:56:54 -0800
Message-ID: <1226084214.10191.10.camel@mingming-laptop>
References: <2014bcab0811061809vca13befn813440a32dda3914@mail.gmail.com>
	 <20081106185109.ce8be9b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: hongshin@gmail.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYKGS5F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 13:57:05 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mA7IuWxf015251
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 11:56:32 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7Iutuw067538
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 11:56:56 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA7IuQZ6012871
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 11:56:26 -0700
In-Reply-To: <20081106185109.ce8be9b8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-11-06 at 18:51 -0800, Andrew Morton wrote:
> On Fri, 7 Nov 2008 11:09:49 +0900 "______ shin hong" <hongshin@gmail.com> wrote:
> 
> > Dear Ext4 maintainer,
> > 
> > I found a suspected data race bug at ext4_release_file() in ext4/file.c .
> > 
> > Is it necessary to re-check whether the if-statement's
> > condition(atomic_read(&inode->i_writecount) == 1) is satisifed after
> > semaphore down operation?
> > 
> > It seems to use "test and test and set" pattern(double-checking)
> >  but the second "test" seems to be missed.
> > 
> > Please examine this function. Thank you.
> > 
> > p.s. I sent the same report to sct@redhat.com. But I did not received
> > any reply.
> >        I think my mail was discarded so I am sending the same again.
> > 
> 
> An appropriate way to report this possible bug is to Cc: the ext4 mailing
> list, which I have cc'ed here.

I guess we could add the check after grab the i_data_sem, but not sure
how useful is that, there is always a window that during the process of
freeing preallocation, another new writer to the same inode. The
i_data_sem semaphore is hold to prevent race between discard
preallocation and use of preallocation, not to protect i_writecount.

The check of inode's i_writecount is to avoid doing discard for every
file close, the idea is only try to discard the preallocation for the
last writer of the file. But the i_writecount could be >1 at the time of
discard preallocation. If a new writer comes in after i_data_sem is hold
then the preallocation is freed, then by the time the new writer comes
in and need block allocation, the preallocate gets build up
atomatically.

 
Mingming

