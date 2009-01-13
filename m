From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints) (fixed in LTTng 0.78)
Date: Wed, 14 Jan 2009 08:57:21 +0900 (JST)
Message-ID: <20090114085427.442F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com> <20090113225827.GA5791@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: kosaki.motohiro@jp.fujitsu.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39250 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZAMX5X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 18:57:23 -0500
In-Reply-To: <20090113225827.GA5791@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > Hi Mathieu
> > 
> > 2009/1/11 Mathieu Desnoyers <compudj@krystal.dyndns.org>:
> > > Hi,
> > >
> > > LTTng 0.74 fixes the probe Makefile to build the net-trace probe module.
> > > It also adds jbd2 and ext4 tracepoints, and jbd2 probe module.
> > 
> > -ECANTBUILD
> > 
> 
> Hi Kosaki,
> 
> Thanks for the report. This should be fixed in LTTng 0.78 now.
> 
> Best regards,

Unfortunately, lockdep part also can't build.

==
Subject: [PATCH] fix lockdep tracing build error

commit 6afe40b4dace385d7ba2faf24b352f066f3b71bf rename argument a0 to ip.
it cause following build error to lttng tree.

  CC      kernel/lockdep.o
kernel/lockdep.c: In function 'trace_hardirqs_on_caller':
kernel/lockdep.c:2186: error: 'a0' undeclared (first use in this function)
kernel/lockdep.c:2186: error: (Each undeclared identifier is reported only once
kernel/lockdep.c:2186: error: for each function it appears in.)
kernel/lockdep.c: In function 'trace_hardirqs_off_caller':
kernel/lockdep.c:2241: error: 'a0' undeclared (first use in this function)
make[1]: *** [kernel/lockdep.o] Error 1


therefore we also need change trace argument.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2ec98a3..21ef2ad 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2183,7 +2183,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
-	_trace_lockdep_hardirqs_on(a0);
+	_trace_lockdep_hardirqs_on(ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -2238,7 +2238,7 @@ void trace_hardirqs_off_caller(unsigned long ip)
 
 	time_hardirqs_off(CALLER_ADDR0, ip);
 
-	_trace_lockdep_hardirqs_off(a0);
+	_trace_lockdep_hardirqs_off(ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
-- 
1.6.0.6







