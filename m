From: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
 (v2)
Date: Sun, 25 Sep 2011 15:32:39 +1000
Message-ID: <4E7EBCF7.8090906@tuxonice.net>
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl> <20110807001446.GI3162@dastard> <201109250056.12545.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph <cr2005@u-club.de>, xfs@oss.sgi.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201109250056.12545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

On 25/09/11 08:56, Rafael J. Wysocki wrote:
> On Sunday, August 07, 2011, Dave Chinner wrote:
>> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> Freeze all filesystems during the freezing of tasks by calling
>>> freeze_bdev() for each of them and thaw them during the thawing
>>> of tasks with the help of thaw_bdev().
>>>
>>> This is needed by hibernation, because some filesystems (e.g. XFS)
>>> deadlock with the preallocation of memory used by it if the memory
>>> pressure caused by it is too heavy.
>>>
>>> The additional benefit of this change is that, if something goes
>>> wrong after filesystems have been frozen, they will stay in a
>>> consistent state and journal replays won't be necessary (e.g. after
>>> a failing suspend or resume).  In particular, this should help to
>>> solve a long-standing issue that in some cases during resume from
>>> hibernation the boot loader causes the journal to be replied for the
>>> filesystem containing the kernel image and initrd causing it to
>>> become inconsistent with the information stored in the hibernation
>>> image.
>>>
>>> This change is based on earlier work by Nigel Cunningham.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
> 
> Below is an alternative fix, the changelog pretty much explains the idea.
> 
> I've tested it on Toshiba Portege R500, but I don't have an XFS partition
> to verify that it really helps, so I'd appreciate it if someone able to
> reproduce the original issue could test it and report back.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Freeze kernel threads after preallocating memory
> 
> There is a problem with the current ordering of hibernate code which
> leads to deadlocks in some filesystems' memory shrinkers.  Namely,
> some filesystems use freezable kernel threads that are inactive when
> the hibernate memory preallocation is carried out.  Those same
> filesystems use memory shrinkers that may be triggered by the
> hibernate memory preallocation.  If those memory shrinkers wait for
> the frozen kernel threads, the hibernate process deadlocks (this
> happens with XFS, for one example).
> 
> Apparently, it is not technically viable to redesign the filesystems
> in question to avoid the situation described above, so the only
> possible solution of this issue is to defer the freezing of kernel
> threads until the hibernate memory preallocation is done, which is
> implemented by this change.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

TuxOnIce has the following logic at the moment: Freeze all threads.
Calculate whether we have enough memory for the image, thaw kernel
threads only, free memory and try again if it looks like we don't have
enough. I've never heard of a deadlock, though I suppose one would be
possible if you had the added complication of userspace
drivers/filesystems - it would be good to be able to distinguish and
thaw them.

It does this prior to the atomic copy, using a user-supplied estimate of
the amount of memory drivers will need - the actual amount used is show
in debugging info at the end of the cycle. Apart from that, if you have
everything else frozen, everything else is pretty deterministic
(assuming you don't have any memory leaks in your image-writing code).

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
