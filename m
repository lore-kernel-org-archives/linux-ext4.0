From: Roy Yang <bsdnet@outlook.com>
Subject: RE: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Wed, 12 Aug 2015 14:43:22 -0700
Message-ID: <COL130-W3988F47C3C020C3E2D5C38D67E0@phx.gbl>
References: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>,<20150812183750.GB3373@thunk.org>,<COL130-W95F37DFE0CBD0ED0680AABD67E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from col004-omc3s15.hotmail.com ([65.55.34.153]:54016 "EHLO
	COL004-OMC3S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbbHLVnW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 17:43:22 -0400
In-Reply-To: <COL130-W95F37DFE0CBD0ED0680AABD67E0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,=A0

=A0 =A0 I got some JBD2 tracing log by running our test program, most o=
f them will take 10 seconds or so. =A0Compared to the normal system, th=
is test only takes 2 seconds.
=A0 =A0 We saw the spike of running, but checking with kernel source. I=
 don't get =A0what it means. =A0Any insights?

=A0 =A0 =A0 =A0 =A0 =A0<...>-220601 [015] .... 181555.139321: jbd2_run_=
stats: dev 259,3 tid 1064541 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 4 blocks 1 blocks_logged 2
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181555.141161: jbd2_run_=
stats: dev 259,3 tid 1064542 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 4 blocks 1 blocks_logged 2
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181555.143399: jbd2_run_=
stats: dev 259,3 tid 1064543 wait 0 request_delay 0 running 1 locked 0 =
flushing 0 logging 0 handle_count 4 blocks 3 blocks_logged 4
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181555.143710: jbd2_run_=
stats: dev 259,3 tid 1064544 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 4 blocks 1 blocks_logged 2
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181555.143840: jbd2_run_=
stats: dev 259,3 tid 1064545 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 1 blocks 4 blocks_logged 5
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181555.176298: jbd2_run_=
stats: dev 259,3 tid 1064546 wait 0 request_delay 0 running 32 locked 0=
 flushing 0 logging 0 handle_count 31 blocks 5 blocks_logged 6
=A0jbd2/nvme0n1p1--964 =A0 [014] .... 181555.189997: jbd2_run_stats: de=
v 259,1 tid 293294 wait 0 request_delay 0 running 5000 locked 0 flushin=
g 0 logging 0 handle_count 15613 blocks 4 blocks_logged 5
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181556.126407: jbd2_run_=
stats: dev 259,3 tid 1064547 wait 0 request_delay 0 running 929 locked =
0 flushing 0 logging 0 handle_count 30 blocks 3 blocks_logged 4
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [014] .... 181556.159874: jbd2_run_=
stats: dev 259,3 tid 1064548 wait 0 request_delay 0 running 10 locked 0=
 flushing 0 logging 0 handle_count 29 blocks 1 blocks_logged 2
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [000] .... 181557.123872: jbd2_run_=
stats: dev 259,3 tid 1064549 wait 0 request_delay 0 running 941 locked =
0 flushing 0 logging 0 handle_count 30 blocks 3 blocks_logged 4
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181558.135168: jbd2_run_=
stats: dev 259,3 tid 1064550 wait 0 request_delay 1 running 1 locked 0 =
flushing 0 logging 0 handle_count 8 blocks 6 blocks_logged 7
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181558.138895: jbd2_run_=
stats: dev 259,3 tid 1064551 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 1 blocks 4 blocks_logged 5
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181558.139091: jbd2_run_=
stats: dev 259,3 tid 1064552 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 1 handle_count 2 blocks 4 blocks_logged 5
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181558.139886: jbd2_run_=
stats: dev 259,3 tid 1064553 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 12 blocks 6 blocks_logged 7
=A0=A0 =A0 =A0 =A0 =A0 <...>-220601 [015] .... 181558.147189: jbd2_run_=
stats: dev 259,3 tid 1064554 wait 0 request_delay 0 running 0 locked 0 =
flushing 0 logging 0 handle_count 1 blocks 4 blocks_logged 5

=A0 =A0Thanks,
=A0 =A0 Roy

----------------------------------------
> From: bsdnet@outlook.com
> To: tytso@mit.edu
> CC: linux-ext4@vger.kernel.org
> Subject: RE: fsync stuck at jbd2_log_wait_commit on NVMe devices
> Date: Wed, 12 Aug 2015 12:28:10 -0700
>
> Hi Ted,
>
> I will collect some info about jbd2 and get back to this list.
>
> To answer your questions, our workload is mostly sequential writes fr=
om a couple of daemons.
> Every second, we will create 6 to 10 files, and write around 8M bytes=
 into them. We only
> do extend or truncate when needed, but I am sure we rarely do this on=
 NVMe devices.
>
> Reading the kernel document, I also see ext4 ordered option will comb=
ine metadata and data blocks
> for journaling. If the data block is big, and the workload is heavy, =
will JBD2 be soaked?
>
> Thanks,
>
> Roy
>
> ----------------------------------------
>> Date: Wed, 12 Aug 2015 14:37:50 -0400
>> From: tytso@mit.edu
>> To: bsdnet@outlook.com
>> CC: linux-ext4@vger.kernel.org
>> Subject: Re: fsync stuck at jbd2_log_wait_commit on NVMe devices
>>
>> Hi Roy,
>>
>> My suggestion is to collect information from the jbd2_run_stats and
>> jbd2_checkpoint_stats tracepoints.
>>
>> cd /sys/kernel/debug/tracing
>> echo 1> events/jbd2/jbd2_run_stats/enable
>> echo 1> events/jbd2/jbd2_checkpoint_stats/enable
>> cat trace_pipe> /tmp/traces &
>> tail -f /tmp/traces
>>
>> The jbd2_handle_stats tracepoint can be informative, but it's also f=
ar
>> more voluminous.
>>
>> That will give us a hint where things are getting bottlenecked.
>>
>> What sort of workload is your application doing? Is it just primaril=
y
>> doing random writes into a preallocated file? Is it creating or
>> deleting files? Extending or truncating files? etc.
>>
>> - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
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
