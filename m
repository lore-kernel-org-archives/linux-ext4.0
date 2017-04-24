From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [sparc64] ext4 TPC and call trace (process blocked/stuck) on git
 kernel 4.8.0-rc3+
Date: Mon, 24 Apr 2017 00:05:48 -0400
Message-ID: <20170424040548.hbawisk25tprbyhp@thunk.org>
References: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
 <CADxRZqwMhCe4OrGxSiON=wHg-+hGahiR5rfof8bHZWVUSVW-EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sparc kernel list <sparclinux@vger.kernel.org>,
        linux-ext4@vger.kernel.org
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADxRZqwMhCe4OrGxSiON=wHg-+hGahiR5rfof8bHZWVUSVW-EA@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 21, 2017 at 07:38:50PM +0300, Anatoly Pugachev wrote:
> On Wed, Aug 24, 2016 at 11:13 AM, Anatoly Pugachev <matorola@gmail.com> wrote:
> > Hello!
> >
> > Running fstests (xfstests) suite on sparc64 debian sid/unstable with
> > linux kernel 4.8.0-rc3+ , I'm getting the following call trace and TPC
> > on server console and system logs:
> 
> 
> got another hung task (sys)log, but not with xfstests and with some
> debug (kernel locks) output (kernel is 4.10.0-git-something). Can
> someone knowing kernel have a look and maybe spot something. If not,
> thanks anyway and machine still works. Thanks!

When you say that the system still works, I assume that means that
writes to root file system (or what ever file system syslog was trying
to log to, typically /var/log) are still succeeding?

These messages are soft lockup messages, and doesn't necessarily means
that the system was locked up forever:

> Apr 19 19:30:43 landau kernel: INFO: task ostree:107749 blocked for
> more than 120 seconds.

It could just mean that a "sync" command took longer than two minutes
to complete.

> Apr 19 19:30:43 landau kernel:       Tainted: G        W
> 4.10.0-10531-g86292b33d4b7 #77
> Apr 19 19:30:43 landau kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 19 19:30:43 landau kernel: ostree          D    0 107749  92509
> 0x208000103000000
> Apr 19 19:30:43 landau kernel: Call Trace:
> Apr 19 19:30:43 landau kernel:  [0000000000a8e790] schedule+0x30/0xc0
> Apr 19 19:30:43 landau kernel:  [0000000000681798]
> wb_wait_for_completion+0x58/0xa0
> Apr 19 19:30:43 landau kernel:  [0000000000682048]
> __writeback_inodes_sb_nr+0x88/0xc0
> Apr 19 19:30:43 landau kernel:  [00000000006820e0] writeback_inodes_sb+0x20/0x40
> Apr 19 19:30:43 landau kernel:  [000000000068a5f4] sync_filesystem+0x34/0xc0
> Apr 19 19:30:43 landau kernel:  [000000000068a7f8] SyS_syncfs+0x38/0x80
> Apr 19 19:30:43 landau kernel:  [0000000000406234] linux_sparc_syscall+0x34/0x44


Without any more details about the system, its workload, whether or
not the system really was hung forever, or it was functioning normally
when you discovered it, it's hard to really say much else given the
lack of information in your e-mail.

Also note that this stack trace has nothing to do with the e-mail
thread from last August which you replied to.  At first I thought
there was a connection, which confused me as I tried to look at the
very small amount of information in your bug report.

Cheers,

					- Ted
