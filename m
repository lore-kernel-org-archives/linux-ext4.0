From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Tue, 17 Apr 2012 14:52:15 -0400
Message-ID: <4F8DBBDF.6010803@redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAF89.5070805@redhat.com> <20120417184306.GA5916@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2DQSwX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2012 14:52:23 -0400
In-Reply-To: <20120417184306.GA5916@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/17/2012 02:43 PM, Ted Ts'o wrote:
> On Tue, Apr 17, 2012 at 01:59:37PM -0400, Ric Wheeler wrote:
>> You could get both security and avoid the run time hit by fully
>> writing the file or by having a variation that relied on "discard"
>> (i.e., no need to zero data if we can discard or track it as
>> unwritten).
> It's certainly the case that if the device supports persistent
> discard, something which we definitely *should* do is to send the
> discard at fallocate time and then mark the space as initialized.

This should be all advertised in /sys/block/sda - definitely worth encouraging 
this for devices. I think that the device mapper "thin" target also supports 
discard so you could get this behaviour with all devices if needed.

>
> Unfortunately, not all devices, and in particular no HDD's for which I
> aware support persistent discard.  And, writing all zero's to the file
> is in fact what a number of programs for which I am aware (including
> an enterprise database) are doing, precisely because they tend to
> write into the fallocated space in a somewhat random order, and the
> extent conversion costs is in fact quite significant.  But writing all
> zero's to the file before you can use it is quite costly; at the very
> least it burns disk bandwidth --- one of the main motivations of
> fallocate was to avoid needing to do a "write all zero pass", and
> while it does solve the problem for some use cases (such as DVR's),
> it's not a complete solution.

We also have a WRITE_SAME (with default pattern of zero data) that has long been 
used in SCSI to initialize data.

>
> Whether or not it is a security issue is debateable.  If using the
> fallocate flag requires CAP_SYS_RAWIO, and the process has to
> explicitly ask for the privilege, a process with those privileges can
> directly access memory and I/O ports directly, via the ioperm(2) and
> iopl(2) system calls.  So I think it's possible to be a bit nuanced
> over whether or not this is as horrible as you might think.

We are still papering over an issue that seems to not be a challenge for XFS.

>
> Ultimately, if there are application programmers who are really
> desperate for that the last bit of performance, they can always use
> FIBMAP/FIEMAP and then read/write directly to the block device.  (And
> no, that's not a theoretical example.)  I think it is a worthwhile
> goal to provide file system interfaces that allow a trusted process
> which has the appropriate security capabilities to do things in a
> safer way than that.
>

I would prefer to let the very few crazy application programmers who need this 
do insane things instead of opening and exposing data to these applications.

Or have them use a different file system that does not have this same penalty 
(or to the same degree).

Thanks!

Ric

