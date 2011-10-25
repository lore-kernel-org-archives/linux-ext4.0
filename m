From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/6] ext4: Do not clear EOFBLOCKS_FL too soon
Date: Tue, 25 Oct 2011 15:57:31 +0400
Message-ID: <87obx5i8r8.fsf@dmbot.sw.ru>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org> <1319144939-28801-4-git-send-email-dmonakhov@openvz.org> <20111025081834.GB31921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50572 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1JYL5J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2011 07:57:09 -0400
Received: by bkbzt19 with SMTP id zt19so402563bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2011 04:57:07 -0700 (PDT)
In-Reply-To: <20111025081834.GB31921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Oct 2011 04:18:34 -0400, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 21, 2011 at 01:08:56AM +0400, Dmitry Monakhov wrote:
> > ext4_ext_insert_extent() may fail due to number of reasons (ENOSPC)
> > so let's update eof flag only after extent was successfully inserted.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> The problem with this patch is that if the check_eofblocks_fl() fails,
> the patch jumps to out: and doesn't undo the block allocation and
> extent tree manipulation.
check_eofblocks_fl may fail only due to ext4_journal_get_write_access
or ext4_mark_iloc_dirty, this means that something serious happen,
so it is very unlikely we can undo block allocation.
> 
> I suspect a better way of solving this problem is to keep the existing
> order, but to save the state of eofblocks flag, and if
> ext4_ext_insert_extent() fails, to restore the state of the eofblocks
> flag before jumping to the exit routine.
Yes. This is definitely looks better, will redo.
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
