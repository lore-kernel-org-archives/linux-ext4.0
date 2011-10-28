From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/6] ext4: move inode indepth shrink logic to didicated function
Date: Fri, 28 Oct 2011 14:47:40 +0400
Message-ID: <87mxclz92r.fsf@dmbot.sw.ru>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org> <1319144939-28801-3-git-send-email-dmonakhov@openvz.org> <20111025080135.GA31921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1J1Krr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 06:47:47 -0400
Received: by bkbzt4 with SMTP id zt4so315234bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 03:47:45 -0700 (PDT)
In-Reply-To: <20111025080135.GA31921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Oct 2011 04:01:35 -0400, "Ted Ts'o" <tytso@mit.edu> wrote:
> On Fri, Oct 21, 2011 at 01:08:55AM +0400, Dmitry Monakhov wrote:
> > - add ext4_ext_try_shrink helper
> > - ext4_mark_inode_dirty() called externally in order to allow
> >   caller to butch several inode updates in to one mark_dirty call.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> This patch is broken in two ways:
> 
> 1) It drops the absolutely necessary calls to ext4_ext_get_access()
>     and ext4_ext_dirty().  If you don't do this you will get file
>     system corruptions.
You almost caught me.. When i read this comment for the first time, i've
thought that you right, and this patch is crap. Patch was written two
month ago so i almost forget exact details. But still it was strange
because whole series was tested very hard, and never saw any corruption,
or complains. From other point of view usually meta data modification
w/o prior get_write_access call result in complain from JBD thread about dirty
bufs in transaction.c:warn_dirty_buffer(). This never happen in my case.

Answer is simple: ext4_ext_get_access(path[0]) is noop in case of inode body
because it has no bh attached. And ext4_ext_dirty() turns in to
ext4_mark_inode_dirty(). That's why patch is correct..
> 
> 2) Some of the callers to the new ext4_ext_try_shrink() helper depends
>    on it return 0 or 1 depending on whether the tree was shrunk, but
>    others assumed that it would return an error code.  Which is OK,
>    since the error codes should be negative, but that means it's
>    critical that the callers check to see whether return code is
>    really an error before returning it.
and {0:1} retcode is sufficient. Situation will change after flexible
tree reduction appear, but this happens in perfect future.
> 
> Since this is just a cleanup, I'm going to skip this for now.  Dmitry,
> could you fix this up and resubmit?   Thanks!!
> 
> 						- Ted
