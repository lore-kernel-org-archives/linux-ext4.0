From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 21:54:48 +0200
Message-ID: <87ej7zcrqv.fsf@basil.nowhere.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jamie@shareable.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 16 May 2008 13:05:45 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 16 May 2008 14:02:46 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
>
>> A collection of patches to make ext3 & 4 use barriers by
>> default, and to call blkdev_issue_flush on fsync if they
>> are enabled.
>
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.

Didn't ext4 have some new checksum trick to avoid them?

> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.
>
> If we were seeing a significant number of "hey, my disk got wrecked"

There used to be a couple of reports of people doing

some write workload
use automatic power switch to reset
turn on again
repeat for 24 hours

getting consistent corruption after some time <24hours and those
went away with barriers.

> Do we know which distros are enabling barriers by default?

SUSE did for some releases, although reiserfs used to be the default there
(but that one uses barriers too if the disk supports them) 

BTW for a lot of distros which default to LVM install it won't make 
any difference because DM right now doesn't pass barriers through.
I have a patch queued for that for the one-disk case at least, but it 
didn't make .26-rc.

-Andi
