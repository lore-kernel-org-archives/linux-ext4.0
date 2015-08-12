From: Roy Yang <bsdnet@outlook.com>
Subject: RE: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Wed, 12 Aug 2015 12:28:10 -0700
Message-ID: <COL130-W95F37DFE0CBD0ED0680AABD67E0@phx.gbl>
References: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>,<20150812183750.GB3373@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from col004-omc3s6.hotmail.com ([65.55.34.144]:51384 "EHLO
	COL004-OMC3S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbHLT2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2015 15:28:11 -0400
In-Reply-To: <20150812183750.GB3373@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,=A0

=A0 =A0 =A0I will collect some info about jbd2 and get back to this lis=
t.
=A0 =A0 =A0
=A0 =A0 =A0To answer your questions, =A0our workload is mostly sequenti=
al =A0writes from a couple of daemons.
=A0 =A0 =A0Every second, we will create 6 to 10 files, and write around=
 8M bytes into them. We only
=A0 =A0 =A0do extend or truncate when needed, but I am sure we rarely d=
o this on NVMe devices.

=A0 =A0 =A0Reading the kernel document, =A0I also see ext4 ordered opti=
on will combine metadata and data blocks
=A0 =A0 =A0for journaling. If the =A0data block is big, and the workloa=
d is heavy, will JBD2 be soaked?

=A0 =A0 =A0Thanks,
=A0 =A0 =A0
=A0 =A0 =A0Roy

----------------------------------------
> Date: Wed, 12 Aug 2015 14:37:50 -0400
> From: tytso@mit.edu
> To: bsdnet@outlook.com
> CC: linux-ext4@vger.kernel.org
> Subject: Re: fsync stuck at jbd2_log_wait_commit on NVMe devices
>
> Hi Roy,
>
> My suggestion is to collect information from the jbd2_run_stats and
> jbd2_checkpoint_stats tracepoints.
>
> cd /sys/kernel/debug/tracing
> echo 1> events/jbd2/jbd2_run_stats/enable
> echo 1> events/jbd2/jbd2_checkpoint_stats/enable
> cat trace_pipe> /tmp/traces &
> tail -f /tmp/traces
>
> The jbd2_handle_stats tracepoint can be informative, but it's also fa=
r
> more voluminous.
>
> That will give us a hint where things are getting bottlenecked.
>
> What sort of workload is your application doing? Is it just primarily
> doing random writes into a preallocated file? Is it creating or
> deleting files? Extending or truncating files? etc.
>
> - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
