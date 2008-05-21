From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 11:03:24 -0700
Message-ID: <20080521110324.668048e0.akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com>
	<20080518211140.b29bee30.akpm@linux-foundation.org>
	<200805191316.27551.chris.mason@oracle.com>
	<200805191439.36577.chris.mason@oracle.com>
	<20080521112224.GD5028@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936704AbYEUSEn@vger.kernel.org>
In-Reply-To: <20080521112224.GD5028@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 21 May 2008 13:22:25 +0200 Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> > >
> > > Here's a test workload that corrupts ext3 50% of the time on power fail
> > > testing for me.  The machine in this test is my poor dell desktop (3ghz,
> > > dual core, 2GB of ram), and the power controller is me walking over and
> > > ripping the plug out the back.
> > 
> > Here's a new version that still gets about corruptions 50% of the time, but 
> > does it with fewer files by using longer file names (240 chars instead of 160 
> > chars).
> > 
> > I tested this one with a larger FS (40GB instead of 2GB) and larger log (128MB 
> > instead of 32MB).  barrier-test -s 32 -p 1500 was still able to get a 50% 
> > corruption rate on the larger FS.
> 
> Ok, Andrew, is this enough to get barrier patch applied and stop
> corrupting data in default config, or do you want some more testing?
> 
> I guess 20% benchmark regression is bad, but seldom and impossible to
> debug data corruption is worse...

It is 20%?  I recall 30% from a few years ago, but that's vague and it
might have changed.  Has much quantitative testing been done recently? 
I might have missed it.

If we do make this change I think it should be accompanied by noisy
printks so that as many people as possible know about the decision
which we just made for them.

afaik there is no need to enable this feature if the machine (actually
the disks) are on a UPS, yes?
