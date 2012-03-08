From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 10:54:19 -0500
Message-ID: <20120308155419.GB6777@thunk.org>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55066 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab2CHPyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2012 10:54:24 -0500
Content-Disposition: inline
In-Reply-To: <4F581BF6.8000305@zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 07, 2012 at 09:39:50PM -0500, Zach Brown wrote:
> 
> >Can you devise a non-secret testcase that demonstrates this?
> 
> Hmm.  I bet you could get fio to do it.  Giant file, random mmap()
> writes, spin until the CPU overwhelms writeback?

Kick off a bunch of fio processes, each in separate I/O cgroups set up
so that each of the processes get a "fair" amount of the I/O
bandwidth.  (This is quite common in cloud deployments where you are
packing a huge number of tasks onto a single box; whether the tasks
are inside virtual machines or containers don't really matter for the
purpose of this exercise.  We basically need to simulate a system
where the disks are busy.)

Then in one of those cgroups, create a process which is constantly
appending to a file using buffered I/O; this could be a log file, or
an application-level journal file; and measure the latency of that
write system call.  Every so often, writeback will push the dirty
pages corresponding to the log/journal file to disk.  When that
happens, and page stablization is enabled, the latency of that write
system call will spike.

And any time you have a distributed system where you are depending on
a large number of RPC/SOAP/Service Oriented Architecture Enterpise
Service Bus calls (I don't really care which buzzword you use, but IBM
and Oracle really like the last one :-), long-tail latencies are what
kill your responsiveness and predictability.  Especially when a thread
goes away for a second or more...

						- Ted
