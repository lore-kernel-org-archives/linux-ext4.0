From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
	(fixed in LTTng 0.78)
Date: Tue, 13 Jan 2009 17:58:27 -0500
Message-ID: <20090113225827.GA5791@Krystal>
References: <20090109235449.GA21999@Krystal> <20090110161137.GA20526@Krystal> <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts5.bellnexxia.net ([209.226.175.25]:42034 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZAMW6o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 17:58:44 -0500
Content-Disposition: inline
In-Reply-To: <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi Mathieu
> 
> 2009/1/11 Mathieu Desnoyers <compudj@krystal.dyndns.org>:
> > Hi,
> >
> > LTTng 0.74 fixes the probe Makefile to build the net-trace probe module.
> > It also adds jbd2 and ext4 tracepoints, and jbd2 probe module.
> 
> -ECANTBUILD
> 

Hi Kosaki,

Thanks for the report. This should be fixed in LTTng 0.78 now.

Best regards,

Mathieu

> fs/jbd2/commit.c:27:24: error: trace/jbd2.h: No such file or directory
> fs/jbd2/commit.c:29: warning: data definition has no type or storage class
> fs/jbd2/commit.c:29: warning: type defaults to 'int' in declaration of
> 'DEFINE_TRACE'
> fs/jbd2/commit.c:29: warning: parameter names (without types) in
> function declaration
> fs/jbd2/commit.c:30: warning: data definition has no type or storage class
> fs/jbd2/commit.c:30: warning: type defaults to 'int' in declaration of
> 'DEFINE_TRACE'
> fs/jbd2/commit.c:30: warning: parameter names (without types) in
> function declaration
> fs/jbd2/commit.c: In function 'jbd2_journal_commit_transaction':
> fs/jbd2/commit.c:374: error: implicit declaration of function
> 'trace_jbd2_start_commit'
> fs/jbd2/commit.c:1003: error: implicit declaration of function
> 'trace_jbd2_end_commit'
> make[2]: *** [fs/jbd2/commit.o] Error 1
> 
> 
> because
> 
> jbd2-instrumentation-move-to-tracepoints patch only change following two files.
> it didn't create trace/jbd2.h
> 
>   fs/jbd2/checkpoint.c 		
>   fs/jbd2/commit.c 		
> 
> 
> 
> 
> 
> >
> > A new version including ext4 probe module should be available shortly.
> >
> > Installation QUICKSTART :
> > http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART
> >
> > git url :
> >
> > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog;h=2.6.28-lttng-0.74
> >
> > tarball :
> >
> > http://ltt.polymtl.ca/lttng/patch-2.6.28-lttng-0.74.tar.gz
> >
> > jbd2/ext4 patches within the tarball :
> >
> > ext4-instrumentation-add-tracepoints.patch
> > jbd2-instrumentation-move-to-tracepoints.patch
> > lttng-instrumentation-jbd2-probes.patch
> >
> > Mathieu
> >
> > * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> >> Hi everyone,
> >>
> >> I just ported LTTng to 2.6.28. Enjoy !
> >>
> >> You may also want to upgrade to lttv 0.12.5 which puts back the syscall
> >> and softirq names in the event list.
> >>
> >> For newcomers, instructions to install LTTng can be found at :
> >> http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART
> >>
> >> (I just updated the QUICKSTART guide. Please feel free to try it and
> >> report inconsistencies.)
> >>
> >> Mathieu
> >>
> >>
> >> --
> >> Mathieu Desnoyers
> >> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> >>
> >> _______________________________________________
> >> ltt-dev mailing list
> >> ltt-dev@lists.casi.polymtl.ca
> >> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> >>
> >
> > --
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
