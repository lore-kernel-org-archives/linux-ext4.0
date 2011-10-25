From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 5/6] ext4: fix punch_hole extend handler
Date: Tue, 25 Oct 2011 16:35:45 +0400
Message-ID: <87fwihi6zi.fsf@dmbot.sw.ru>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org> <1319144939-28801-6-git-send-email-dmonakhov@openvz.org> <20111025120553.GF31921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab1JYMfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2011 08:35:24 -0400
Received: by bkbzt19 with SMTP id zt19so446289bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2011 05:35:22 -0700 (PDT)
In-Reply-To: <20111025120553.GF31921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Oct 2011 08:05:53 -0400, "Ted Ts'o" <tytso@mit.edu> wrote:
> On Fri, Oct 21, 2011 at 01:08:58AM +0400, Dmitry Monakhov wrote:
> > Current implementation has following issues:
> >  - EOFBLOCK does not changed if necessery
> >  - ext4_ext_rm_leaf() may return -EAGAIN due to transaction restart
> >  - punched extent converted to uninitialized incorrectly, i dont understand
> >    why do we ever have to do that conversion, but once we do it let's do it
> >    in a right way.
> >  - fsync() logic is broken because ei->i_sync_tid was not updated
> >  - Last but not the least all: punch hole logic is sited directly
> >    in ext4_ext_map_blocks() on 3rd level of control, IMHO one can
> >    easily screw-up his eyes while invastigating that code. We have
> >    nothing to hide aren't we?
> > 
> > This patch performs following changes:
> >  - Move punch hole logic to didicated function similar to uninitialized
> >    extent handlers.
> >  - Clear EOFBLOCK if necessery, unfortunately we can not reuse
> >    check_eofblock_fl() function because it purpose to handle file
> >    expansion, but in our case we have to recheck base invariant that:
> >       clear_eof_flag = (eof_block >= last_allocated_block)
> >  - Repeat punch hole after transaction restart.
> >  - Update inode sync transaction id on exit.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I'm really sorry, but this was too complicated for me to review for
> this merge window.  Maybe Allison or some of the people who worked on
> the punch code could review this?  Or maybe this could be broken up
> into smaller patches?
Yes. ;( you right, it is kind of non obvious patch.
i'll split this like follows:
1) move punch_hole handler from ext4_ext_map_blocks to dedicated
function as is (90% the original patch)
2) fix other issues one by one.
Will do
> 
> Or I can look at this again for the next merge window, but this is too
> complicated for me to understand (and the punch code is too new for me
> to have an deep understanding for quick reviews).  Sorry I didn't
> review this sooner; between trying to get e2fsprogs 1.42 ready for
> release and kernel.org recovery efforts, I got beind on my reviews.
BTW can you please highlight your plans to make libquota in to working
shape, right now it simply rewrites old quota file so fsck each time
result int fs modifications. I have some patches in my queue which add
quota check capabilities in libquota/e2fsck. 

> 
> Regards,
> 
> 						- Ted
