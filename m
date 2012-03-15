From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 14 Mar 2012 22:02:02 -0700
Message-ID: <CALCETrUd4cTaFiHVAD+5ezoKEy2G-x6rYhC7N0FgLdboR4yQwA@mail.gmail.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57FC14.5090207@panasas.com> <yq1zkbrhi2l.fsf@sermon.lab.mkp.net>
 <4F5837A2.8000306@panasas.com> <Pine.LNX.4.64.1203072207050.24564@cobra.newdream.net>
 <20120308154326.GA6777@thunk.org> <Pine.LNX.4.64.1203080829300.23757@cobra.newdream.net>
 <4F614F8D.5010702@amacapital.net> <4F617408.7050801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sage Weil <sage@newdream.net>, "Ted Ts'o" <tytso@mit.edu>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F617408.7050801@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 14, 2012 at 9:46 PM, Boaz Harrosh <bharrosh@panasas.com> wr=
ote:
> On 03/14/2012 07:10 PM, Andy Lutomirski wrote:
>> On 03/08/2012 08:43 AM, Sage Weil wrote:
>> I'll add a simple workload. =A0I have a soft real-time program that =
has
>> two threads. =A0One of them fallocates some files, mmaps them, mlock=
s
>> them, and touches all the pages to prefault them. =A0(This thread ha=
s no
>> real-time constraints -- it just needs to keep up.) =A0The other thr=
ead
>> writes to the files.
>>
>> On Windows, this works very well. =A0On Linux without stable pages, =
it
>> almost works. =A0With stable pages, it's a complete disaster. =A0No =
amount
>> of minimizing the amount of time that pages under writeback can caus=
e
>> writers to sleep will help -- writers *must not wait for io* when
>> writing mlocked, prefaulted pages for my code to work.
>>
>
> Right, this is Windows shit. If your goal is to never wait, IO
> as fast as possible, and use the least amount of CPU time
> then it's exactly the opposite of what you want to do.
> You want to do async Direct IO.

I don't care if the io is as fast as possible and I don't care about
cpu time (that's what multicore is for).  I care about real-time
threads not waiting.  And I'm not sure why the superior performance on
Windows is "shit".

In any case, there's no possible way that async direct I/O is as
low-latency as memcpy for short writes.

>
> Also as Dave Chinner said "Double/ring buffering with async
> IO dispatch"

That's certainly an option.  In fact, any program that has issues with
write latency due to stable pages or any other cause can do this.  But
it's more code, it's more likely to lose data on an application crash,
and it's annoying since the kernel *already* has a perfectly good page
cache and mmap mechanism that ought to work.

Also, double buffering is kind of a PITA when other threads might be
trying to real the same file at the same time.  That means I have to
get them all to find the same mapping, which can't live on an ext4
filesystem, requiring a daemon.

So I still claim my use case is valid, and I think Linux should handle
it better than it does now.  The proposed fix of getting rid of stable
pages when they're not needed is good enough for me.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
