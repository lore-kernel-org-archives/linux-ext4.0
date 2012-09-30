From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Sun, 30 Sep 2012 18:00:57 +0400
Message-ID: <87sj9z4nl2.fsf@openvz.org>
References: <20120919190541.GE28470@thunk.org> <20120925124252.GA1518@gmail.com> <20120925205921.GA8625@thunk.org> <20120926020955.GA4101@gmail.com> <20120926024745.GA11468@thunk.org> <20120926032426.GA496@gmail.com> <20120926033740.GC11468@thunk.org> <20120928072714.GA8544@gmail.com> <20120928174233.GB887@thunk.org> <CANWLp02F=qDXY_KbhAziPkBe8qGKV6oN3XtSdc5bWOkbDG684g@mail.gmail.com> <20120929030759.GA12136@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60100 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2I3OBA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Sep 2012 10:01:00 -0400
In-Reply-To: <20120929030759.GA12136@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 28 Sep 2012 23:07:59 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Sep 29, 2012 at 08:54:47AM +0800, Zheng Liu wrote:
> > 
> > When I try to fix the bigalloc bug, some code that operates on extent
> > status tree and  maintains its status are changed when I do some changes in
> > ext4_find_delalloc_range().  So that quite has a lot of changes I thought
> > in the whole patch series.  So I think that we'd better drop this patch set
> > from dev branch.  Thanks.
> 
> OK, dropped.
After patch-set was dropped, 269'th succeed.
Both warnings: ext4_convert_unwritten_extent which fail with ENOSPC and
WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space
are gone away.  
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
