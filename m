From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Extent tree status asking
Date: Tue, 17 Apr 2012 23:19:26 -0700
Message-ID: <4F8E5CEE.9050607@linux.vnet.ibm.com>
References: <20120416175534.GA5533@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58290 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2DRGTx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 02:19:53 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Apr 2012 02:19:52 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id C597E6E8049
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 02:19:28 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3I6JSsk3158202
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 02:19:28 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3I6JSGl032179
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 02:19:28 -0400
Received: from lc4eb0185863151.ibm.com (sig-9-48-104-184.mts.ibm.com [9.48.104.184])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id q3I6JRt1032170
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 02:19:27 -0400
In-Reply-To: <20120416175534.GA5533@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/16/2012 10:55 AM, Zheng Liu wrote:
> Hi Allison,
>
> Currently I am trying to reduce the lock contention of direct I/O in ext4
> because it is a bottleneck.  A trivial idea is that a new fucntion is
> defined to replace the generic_file_aio_write, which do some write
> operations with acquiring i_data_sem lock in inode.
>
> I know that you are trying to implement extent tree, and I have seen your patch
> set '[PATCH] Rename delayed extents to status extents'.  After extent tree is
> made, the implementation of direct I/O without i_mutex and range lock is
> straightforward and it is better than my trivial idea.  I think that
> maybe I can borrow you works.  So could you please share me your schedule
> and/or other information?
>
> Last month on ext4 workshop, we discuss the extent tree, range lock and I/O
> tree.  Obviously, I/O tree is used to store I/O operations, which can track
> delay allocation, do unwritten->written conversion and implement range lock.
> It is very useful for ext4 and I am interested in this proposal.  I know that
> you have begun to do some works.  So would you like to tell me the status of
> extent tree?  I don't know whether or not there has some things that I can be
> involved.  If you have some advices or there is something that I can help,
> please let me know.  Thank you and looking forward your reply.
>
> Regards,
> Zheng

Hi Zheng,

Well, I can share with you what I have done so far with Yongqiang's 
delayed extent tree, but since I was moved to the ganesha project, 
extent locks are no longer a business priority now.  I've done some work 
on it on my own time, but I have not been able to keep up pace with it. 
  If someone else has the hours to push it faster than I can at this 
point, I would certainly be understanding of that.

Basically though the plan was to modify Yongqiang's delayed extent tree 
to track allocated extents as well as delayed extents.  And then add the 
extent locks on top of that once that's working.  My idea was to add a 
type member to the extents so that we have have "delayed" "allocated" 
and "hole" extents.  I've renamed the delayed extent scheme to "status 
extents" because it seemed more appropriate.  That part I can send out, 
but I was still in the middle of coding and debugging allocated extents 
and extent locks.  Because the tree was originally written to merge 
things as much as possible, there is some rewrite that is needed.  I was 
working on making the add and remove routines more like "type replace" 
routines sense once the extent is locked, we can really only change the 
type, and we cannot merge dissimilar types or extents locked by other 
processes. I hope that makes sense, please let me know if you need more 
clarification.  I will send out the status extent set, sense that part 
is stable.

Allison Henderson


> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

