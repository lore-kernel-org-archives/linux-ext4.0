From: Alexander Zhavnerchik <alex.vizor@gmail.com>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Mon, 28 Nov 2011 15:38:52 +0300
Message-ID: <4ED380DC.3030707@gmail.com>
References: <4ED2994A.9080907@gmail.com> <4ED29C63.8070601@gmail.com> <20111127213432.GA22465@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42777 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1K1Mi6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:38:58 -0500
Received: by yenl6 with SMTP id l6so2800755yen.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 04:38:57 -0800 (PST)
In-Reply-To: <20111127213432.GA22465@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Unfortunately my laptop died today and I can't retest this issue. I'll 
provide more information once and if I repair it.

Thanks,
Alex

On 28.11.2011 00:34, Ted Ts'o wrote:
> On Sun, Nov 27, 2011 at 11:24:03PM +0300, Alex wrote:
>> BTW, after last resume from disk fs was corrupted but fsck managed
>> to fix this error. So I think severity of this issue should be
>> raised.
> Can you reproduce this reliably?  What was running at the time of the s2disk?
>
> What appears to be going on is that insert_inode_locked() is failing
> at fs/ext4/ialloc.c:887, probably because there's another inode with
> that inode number already on the superblock's hash list.  The error
> codepath if insert_inode_locked() fail is incorrect; it's going to
> fail_drop, which tries dropping the inode's dquot (but we haven't
> calle ddquot_initialize)inode) yet) and calls unlock_new_inode(), but
> I_NEW hasn't been set because insert_inode_locked().
>
> So the warning is easy to fix; we just need to have it jump to fail
> instead of fail_drop.  But the bigger issue is why did
> insert_inode_locked() failed in the first place.
>
> Did this error happen *right* after the system resumed, or did some
> amount of time pass before the warning triggered?  This could have
> happened because the in-memory (or possibly on-disk) copy of the inode
> allocation bitmap has gotten corrupted, for example.
>
> What was the nature of the file system corruption which e2fsck decided
> that it need to correct?
>
> Regards,
>
> 						- Ted

