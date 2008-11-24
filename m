From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: PATCH ext4: fix to call_filldir
Date: Mon, 24 Nov 2008 14:59:41 -0800
Message-ID: <6601abe90811241459p3b03e4cay58b45464c906482f@mail.gmail.com>
References: <20081124182105.184338C977@localhost>
	 <20081124215146.GC20928@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:29174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYKXW7n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 17:59:43 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id mAOMxg0a024837
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 14:59:42 -0800
Received: from rv-out-0708.google.com (rvfc5.prod.google.com [10.140.180.5])
	by zps19.corp.google.com with ESMTP id mAOMx82l015352
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 14:59:41 -0800
Received: by rv-out-0708.google.com with SMTP id c5so2247186rvf.24
        for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 14:59:41 -0800 (PST)
In-Reply-To: <20081124215146.GC20928@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

> Um, how much testing have you done with this patch in place?  The
> change to call_filldir() was part of other changes in how
> call_filldir() was called, and at least in the common case where
> filldir() returns -EINVAL because there's not enough room in the
> user's readdir buffer and the entry needs to be saved for the next
> getdents() systemcall, the code is correct.
>
> In fact, I haven't tried your patch, but I'm pretty certain that if
> applied, it will cause directory entries to be dropped such that rm
> -rf for large hierarchies will *always* fail because some files won't
> get deleted becuase they won't be returned by readdir().
>
> What kernel version were you running when you were testing ext4 using
> bonnie?  If you are using a kernel older than 2.6.28-rc2 (and newer
> than 2.6.27-rc4), I would guess what you ran into was a known bug that
> was fixed by commit 3c37fc86.

Thanks much.  Yes, now I see how the commit above works with the existing code.

I'm running a 2.6.26-based kernel with various patches applied from
the ext4 patch queue.  We don't have this commit in our base, hence my
patch works (at least with basic testing) there.  But I can see how it
would not work with the current base kernel (where this commit is
incorporated).

Sorry for the confusion; but this does point out a problem of mine:
where should I be looking for ext4 patches?  I've been using

       http://repo.or.cz/w/ext4-patch-queue.git

where I'm not seeing this patch (am I just missing it?).  Should I
simply be using

       http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

where in fact I am seeing this patch?

Thanks,
Curt
