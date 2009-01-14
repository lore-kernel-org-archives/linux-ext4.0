From: Theodore Tso <tytso@mit.edu>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
	(fixed in LTTng 0.78)
Date: Tue, 13 Jan 2009 19:13:46 -0500
Message-ID: <20090114001346.GB14730@mit.edu>
References: <20090109235449.GA21999@Krystal> <20090110161137.GA20526@Krystal> <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com> <20090113225827.GA5791@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbZANANv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 19:13:51 -0500
Content-Disposition: inline
In-Reply-To: <20090113225827.GA5791@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 13, 2009 at 05:58:27PM -0500, Mathieu Desnoyers wrote:
> >=20
> > -ECANTBUILD
> >=20
> Thanks for the report. This should be fixed in LTTng 0.78 now.

Out of curiosity, do you maintain a branch of LTTNG versus any of the
-rc kernels, or do you only track the stable kernels?  I tried pulling
LTTNG 0.78 against the most recent Linus mainline and got a whole pile
of conflicts.

I then tried building LTTng 0.78 and got build failures:

  CC      arch/x86/kernel/init_task.o
distcc[27501] ERROR: compile /var/cache/ccache/init_task.tmp.closure.27=
497.i on localhost failed
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: unknown=
 field =E2=80=98user_markers_mutex=E2=80=99 specified in initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: brace=
s around scalar initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: (near=
 initialization for =E2=80=98init_task.latency_record_count=E2=80=99)
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: field n=
ame not in record or union initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: (near i=
nitialization for =E2=80=98init_task.latency_record_count=E2=80=99)

Looks like CONFIG_MARKERS_USERSPAC is busted....

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
