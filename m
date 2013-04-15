From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: xfstests failure generic/299
Date: Mon, 15 Apr 2013 13:15:38 +0400
Message-ID: <87k3o4xih1.fsf@openvz.org>
References: <nsxvc7ra2cv.fsf@closure.thunk.org> <87sj2uokzc.fsf@openvz.org> <20130414224712.GC12542@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:42924 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934370Ab3DOJPn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Apr 2013 05:15:43 -0400
Received: by mail-la0-f43.google.com with SMTP id eg20so3331716lab.2
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2013 02:15:41 -0700 (PDT)
In-Reply-To: <20130414224712.GC12542@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Sun, 14 Apr 2013 18:47:12 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Sat, Apr 13, 2013 at 01:09:27PM +0400, Dmitry Monakhov wrote:
> > >      Run fio with random aio-dio pattern
> > >      
> > >      Start fallocate/truncate loop
> > >     +./common/rc: line 2055:  3353 Segmentation fault      "$@" >>
> > Yes, this is known issue. I probably use recent fio.git/HEAD
> > Jens does a good job on developing fio, but he tend to commit random
> > untested crap to his git. So stability is worse than it should be.
> > I have golden-good commit (aeb32dfccbd05) which works for me, and suggest
> > to use it.
> 
> Hmm... I just tried recompiling fio to git commit version
> aeb32dfccbd05, and it's blowing up with a seg fault as well.
> 
> One thing about my test environment is that I'm building xfstests and
> fio on a 32-bit x86 environemnt (because that way I can use an 32-bit
> kernel, and because when I use a 64-bit kernel I stress test the
> 64-bit compatibility code paths).  Perhaps this has something to do
> with it?
Yep, reproducible with -m32 compile option
> 
> Unfortunately, I don't have the time to debug this, so at least for
> now I'm going to exclude generic/299 from my automated test runs.
Actually fix is quite simple, after this everything works fine.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-fio-fix-segfault-on-32bits-platforms.patch

>From 473842b2c1181245d3bfd1c5cfc6dbad1b695f79 Mon Sep 17 00:00:00 2001
From: root <root@sandy.qa.sw.ru>
Date: Mon, 15 Apr 2013 13:12:44 +0400
Subject: [PATCH] fio: fix segfault on 32bits platforms

---
 stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/stat.c b/stat.c
index 2665952..f3bc63d 100644
--- a/stat.c
+++ b/stat.c
@@ -601,7 +601,7 @@ void show_thread_status(struct thread_stat *ts, struct group_run_stats *rs)
 					ts->short_io_u[0], ts->short_io_u[1],
 					ts->short_io_u[2]);
 	if (ts->continue_on_error) {
-		log_info("     errors    : total=%lu, first_error=%d/<%s>\n",
+		log_info("     errors    : total=%llu, first_error=%d/<%s>\n",
 					ts->total_err_count,
 					ts->first_error,
 					strerror(ts->first_error));
-- 
1.7.1


--=-=-=


> 
>     	      	 	 	     	  - Ted

--=-=-=--
