From: Roy Yang <bsdnet@outlook.com>
Subject: RE: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Wed, 12 Aug 2015 16:34:17 -0700
Message-ID: <COL130-W737C0A6D747C8E035546EED67E0@phx.gbl>
References: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>,<20150812183750.GB3373@thunk.org>,<COL130-W95F37DFE0CBD0ED0680AABD67E0@phx.gbl>,<COL130-W3988F47C3C020C3E2D5C38D67E0@phx.gbl>,<20150812223456.GC3373@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from col004-omc3s1.hotmail.com ([65.55.34.139]:65292 "EHLO
	COL004-OMC3S1.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbHLXeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2015 19:34:18 -0400
In-Reply-To: <20150812223456.GC3373@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,=A0

=A0 =A0Appreciate your time, and will get the log from normal work load=
=2E

=A0 =A0BTW, the previous JBD2 log is from the node which is in bad stat=
e.=A0
=A0 Normal node finish within 3 seconds; while on this node, it takes 1=
0 seconds.
=A0
=A0 =A0Thank you very much!

=A0 =A0Rpu

----------------------------------------
> Date: Wed, 12 Aug 2015 18:34:56 -0400
> From: tytso@mit.edu
> To: bsdnet@outlook.com
> CC: linux-ext4@vger.kernel.org
> Subject: Re: fsync stuck at jbd2_log_wait_commit on NVMe devices
>
> On Wed, Aug 12, 2015 at 02:43:22PM -0700, Roy Yang wrote:
>> Hi Ted,
>>
>> I got some JBD2 tracing log by running our test program, most of the=
m will take 10 seconds or so. Compared to the normal system, this test =
only takes 2 seconds.
>> We saw the spike of running, but checking with kernel source. I don'=
t get what it means. Any insights?
>
> You need to get the trace on your normal system --- a system when
> under load, you are seeing the long times for a journal commit to
> complete. The jbd2_run_stats gives us critical insight into what
> might be going wrong --- but just as it doesn't help much to use a
> diagnostic tool on a pet dog when you are trying to determine why the
> child is running a fever, it doesn't help much to take traces on a
> test program/system when we're trying to actually debug why your
> production server is having trouble....
>
>
>> <...>-220601 [015] .... 181555.139321: jbd2_run_stats: dev 259,3 tid=
 1064541 wait 0 request_delay 0 running 0 locked 0 flushing 0 logging 0=
 handle_count 4 blocks 1 blocks_logged 2
>
> There will be one of these trace points emitted for each jd2
> transaction commit. Most of the fields, with the exception of the
> last three (handle_count, blocks, and blocks logged) are in units of
> 1000 HZ "jiffies. So for example, if you don't have any fsync()'s,
> transactions by default will run for 5 seconds before being committed=
,
> so the "running" time will be a bit larger than 5000 jiffies (the
> timer goes off at 5 seconds, but there may be some delay before the
> jbd2 kernel thread gets scheduled):
>
> jbd2/sda3-8-275 [003] ...2 70449.637938: jbd2_run_stats: dev 8,3 tid =
789663 wait 0 request_delay 0 running 5030 locked 0 flushing 0 logging =
0 handle_count 18 blocks 5 blocks_logged 6
>
> The "wait" field indicates the maximum time that a handle associated
> with a transaction had to wait before it could get started. Typically
> this is because we couldn't start a new transactions because the old
> transaction was still in the process of being committed.
>
> The "request_delay" field indicates delay between when transaction
> commit was requested (typically due to an fsync), and when the jbd2
> kernel thread actually started working on the commit. (Again, all tim=
e
> fields are in units of jiffies, so you can read the integer in
> milliseconds --> 5030 jiffies =3D=3D=3D 5030 milliseconds =3D=3D 5.03=
 seconds.
>
> The "running" field indicates how long transaction was running; as
> mentioned above, this will typically be around 5000 jiffies unless
> your workload was doing fsync()'s, or if the transaction was big
> enough that it was forced to close because journal space reasons.
>
> The "locked" field indicates how long it takes for all of the pending
> handles to be completed. When the jbd2 layer starts working on the
> commit, the first thing it does is lock down the transaction so no ne=
w
> handles can be started. It then waits for all curently started
> handles can complete. While we are waiting for handles to close, no
> other handles can be started (see discussion of the maximum wait time
> above). We try to keep handle processing time as short as possible
> (for example, by prefetching blocks before starting a handle), but
> there are cases where this is not possible, or at least not easy.
> Analysis of the jbd2_handle_stats trances can help identify
> longer-running handles. If these long-running handles happen right
> before journal commit (and for a workload that is overly fsync-happy,
> that may be most handles), they can prolong how long a journal commit
> stays in the "locked" phase.
>
> The "flushing" field indicates how long the transaction commit spent
> writing out data blocks. We only need to write out data blocks in
> data=3Dordered mode associated with inodes which have new blocks
> allocated during the last transaction.
>
> The "logging" field indicates how long it took to write out the block=
s
> that are actually written to the journal. The number of blocks
> actually written are reflected in the "blocks" and "blocks_logged"
> fields, where the "blocks_logged" fields includes the overhead blocks
> (jbd2 descriptor blocks, jbd2 revoke blocks, etc.)
>
> The "handle_count" field indicates how many handles are associated
> with a particular transaction. In general each simple system call
> (chmod, creat, chown, symlink, read, etc.) that modifies the file
> system requires at most a single handle. The big exception to this
> rule of thumb is the truncate(2) and unlink(2) system calls, which ma=
y
> require multiple handles in order to complete. The truncate() and
> unlink system calls are also the ones which tend to hold a handle ope=
n
> for longer-than-average amounts of time.
>
> By the way, this is why calling truncate() and doing block allocation=
s
> and doing fsync() a lot is *not* free. If you are purchasing $$$ NVME
> storage, in general it's a wise idea for your application to simply d=
o
> non-allocating writes (i.e., overwriting previous blocks in a
> preallocated file), and tracking which blocks are used for what in
> your application, instead of trying to ask general purpose file syste=
m
> code to do this for you. If you can used a specialized data structure
> (say, a circular buffer) and manage the head and tail pointers
> yourself, it will almost always require much less overhead than what
> the file system will have to do since the file system doesn't have th=
e
> advantage of specialized knowledge of exactly what your requirements
> might be for your workload.
>
> Regards,
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
