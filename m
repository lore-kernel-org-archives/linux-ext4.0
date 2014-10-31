From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Thu, 30 Oct 2014 18:08:27 -0600
Message-ID: <5452D2FB.40100@windriver.com>
References: <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com> <alpine.DEB.2.11.1410291854090.5308@nanos> <54513BDA.1050804@windriver.com> <alpine.DEB.2.11.1410292013510.5308@nanos> <20141029231916.GD5000@thunk.org> <alpine.DEB.2.11.1410302204570.5308@nanos> <20141030232437.GF31927@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Austin Schuh <austin@peloton-tech.com>, <pavel@pavlinux.ru>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	<linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>,
	rt-users <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20141030232437.GF31927@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/30/2014 05:24 PM, Theodore Ts'o wrote:
> On Thu, Oct 30, 2014 at 10:11:26PM +0100, Thomas Gleixner wrote:
>>
>> That's a way better explanation than what I saw in the commit logs and
>> it actually maps to the observed traces and stackdumps.
>
> I can't speak for Jan, but I suspect he didn't realize that there was
> a problem.  The commit description in b34090e5e2 makes it clear that
> the intent was a performance improvement, and not an attempt to fix a
> potential deadlock bug.
>
> Looking at the commit history, the problem was introduced in 2.6.27
> (July 2008), in commit c851ed54017373, so this problem wasn't noticed
> in the RHEL 6 and RHEL 7 enterprise linux QA runs, and it wasn't
> noticed in all of the regression testing that we've been doing.
>
> I've certainly seen this before.  Two years ago we found a bug that
> was only noticed when we deployed ext4 in production at Google, and
> stress tested it at Google scale with the appropriate monitoring
> systems so we could find a bug that had existed since the very
> beginning of ext3, and which had never been noticed in all of the
> enterprise testing done by Red Hat, SuSE, IBM, HP, etc.  Actually, it
> probably was noticed, but never in a reproducible way, and so it was
> probably written off as some kind of flaky hardware induced
> corruption.
>
> The difference is that in this case, it seems that Chris and Kevin was
> able to reproduce the problem reliably.  (It also might be that the RT
> patch kits widens the race window and makes it much more likely to
> trigger.)  Chris or Kevin, if you have time to try to create a
> reliable repro that is small/simple enough that we could propose it as
> an new test to add to xfstests, that would be great.  If you can't,
> that's completely understable.

It appears that EXT4_I(inode)->i_data_sem is involved, so I wonder if it 
might have something to do with the fact that the RT patches modify the 
reader-writer semaphores so that the read-side is exclusive?

I suspect I won't have time to isolate a useful testcase, unfortunately.

For what it's worth, we initially discovered the problem when copying 
large (10GB) files from an NFS client onto an NFS-mounted ext4 
filesystem that was mounted with "noatime,nodiratime,data=ordered". 
Initially it failed quite reliably, then something in our environment 
changed and it became more intermittent (could take several hours of 
stress test to reproduce).

We discovered somewhat by accident that we could more reliably reproduce 
it running on a pair of VirtualBox VMs.  The server exported the 
filesystem as per above, and on the client I just used dd to copy from 
/dev/zero to the NFS-mounted filesystem.  Generally it would hang before 
copying 5GB of data.

Chris


