From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 10:04:21 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1204180951380.5310@dhcp-27-109.brq.redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAF89.5070805@redhat.com> <20120417184306.GA5916@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120417184306.GA5916@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 17 Apr 2012, Ted Ts'o wrote:

> On Tue, Apr 17, 2012 at 01:59:37PM -0400, Ric Wheeler wrote:
> > 
> > You could get both security and avoid the run time hit by fully
> > writing the file or by having a variation that relied on "discard"
> > (i.e., no need to zero data if we can discard or track it as
> > unwritten).
> 
> It's certainly the case that if the device supports persistent
> discard, something which we definitely *should* do is to send the
> discard at fallocate time and then mark the space as initialized.

Yes using discard to avoid reading stale data might be partial solution
on some hardware. Although it has its own problems like minimum discard
range size, cache flush, slowness with some hardware and the fact that
it might not actually zero all of the data, but all of that should get
better in future I guess. Unfortunately this is definitely not a
solution for now.

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
> 
> Whether or not it is a security issue is debateable.  If using the
> fallocate flag requires CAP_SYS_RAWIO, and the process has to
> explicitly ask for the privilege, a process with those privileges can
> directly access memory and I/O ports directly, via the ioperm(2) and
> iopl(2) system calls.  So I think it's possible to be a bit nuanced
> over whether or not this is as horrible as you might think.

I do not think this is debatable at all. It _is_ security hole no matter
what. What you're talking about is just the privilege to create such
dangerous file. After it is created, it is protected _only_ by the
application logic (and bug in the application can expose stale data to
the regular use) or file permission which is even worse since people get
this wrong all the time. So it is not like it is perfectly safe to let only
root create such file, not at all.

Moreover users will get this wrong, because they will not understand
every corner case. And when you add the "performance boost" and the
vague name of the flag (really FALLOC_FL_EXPOSE_USER_DATA would have
been much better) into the mix you'll get a disaster.

> 
> Ultimately, if there are application programmers who are really
> desperate for that the last bit of performance, they can always use
> FIBMAP/FIEMAP and then read/write directly to the block device.  (And
> no, that's not a theoretical example.)  I think it is a worthwhile
> goal to provide file system interfaces that allow a trusted process
> which has the appropriate security capabilities to do things in a
> safer way than that.

Well, then let them use xfs, since they do not have this problem, or
rather let's fix the root cause.

Regards
-Lukas

> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
