From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Extent tree status asking
Date: Thu, 19 Apr 2012 17:38:30 +0800
Message-ID: <20120419093829.GA4547@gmail.com>
References: <20120416175534.GA5533@gmail.com>
 <4F8E5CEE.9050607@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2DSJb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2012 05:31:57 -0400
Received: by pbcun15 with SMTP id un15so10030306pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2012 02:31:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F8E5CEE.9050607@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 17, 2012 at 11:19:26PM -0700, Allison Henderson wrote:
> On 04/16/2012 10:55 AM, Zheng Liu wrote:
> >Hi Allison,
> >
> >Currently I am trying to reduce the lock contention of direct I/O in ext4
> >because it is a bottleneck.  A trivial idea is that a new fucntion is
> >defined to replace the generic_file_aio_write, which do some write
> >operations with acquiring i_data_sem lock in inode.
> >
> >I know that you are trying to implement extent tree, and I have seen your patch
> >set '[PATCH] Rename delayed extents to status extents'.  After extent tree is
> >made, the implementation of direct I/O without i_mutex and range lock is
> >straightforward and it is better than my trivial idea.  I think that
> >maybe I can borrow you works.  So could you please share me your schedule
> >and/or other information?
> >
> >Last month on ext4 workshop, we discuss the extent tree, range lock and I/O
> >tree.  Obviously, I/O tree is used to store I/O operations, which can track
> >delay allocation, do unwritten->written conversion and implement range lock.
> >It is very useful for ext4 and I am interested in this proposal.  I know that
> >you have begun to do some works.  So would you like to tell me the status of
> >extent tree?  I don't know whether or not there has some things that I can be
> >involved.  If you have some advices or there is something that I can help,
> >please let me know.  Thank you and looking forward your reply.
> >
> >Regards,
> >Zheng
> 
> Hi Zheng,
> 
> Well, I can share with you what I have done so far with Yongqiang's
> delayed extent tree, but since I was moved to the ganesha project,
> extent locks are no longer a business priority now.  I've done some
> work on it on my own time, but I have not been able to keep up pace
> with it.  If someone else has the hours to push it faster than I can
> at this point, I would certainly be understanding of that.
> 
> Basically though the plan was to modify Yongqiang's delayed extent
> tree to track allocated extents as well as delayed extents.  And
> then add the extent locks on top of that once that's working.  My
> idea was to add a type member to the extents so that we have have
> "delayed" "allocated" and "hole" extents.  I've renamed the delayed
> extent scheme to "status extents" because it seemed more
> appropriate.  That part I can send out, but I was still in the
> middle of coding and debugging allocated extents and extent locks.
> Because the tree was originally written to merge things as much as
> possible, there is some rewrite that is needed.  I was working on
> making the add and remove routines more like "type replace" routines
> sense once the extent is locked, we can really only change the type,
> and we cannot merge dissimilar types or extents locked by other
> processes. I hope that makes sense, please let me know if you need
> more clarification.  I will send out the status extent set, sense
> that part is stable.

Thank you for sharing with me.  I am willing to take this work because
my employee provides me a full time to finish this work.  I see that you
have sent the patch set to the mailing list.  I will pick it and go on
working.  Thanks again. :)

Regards,
Zheng
