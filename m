From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 08:11:19 -0400
Message-ID: <20140704121119.GB10514@thunk.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140704102307.GA19252@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 04, 2014 at 12:23:07PM +0200, Pavel Machek wrote:
> 
> pavel@duo:~$ uname -a
> Linux duo 3.15.0-rc8+ #365 SMP Mon Jun 9 09:18:29 CEST 2014 i686
> GNU/Linux
> 
> EXT4-fs (sda3): error count: 11
> EXT4-fs (sda3): initial error at 1401714179: ext4_mb_generate_buddy:756
> EXT4-fs (sda3): last error at 1401714179: ext4_reserve_inode_write:4877
> 
> That sounds like media error to me?

If you search your system logs since the last fsck, you should find 11
instances of "EXT4-fs error" message, which means that there was some
file system inconsisntencies detected.  The first error was detected at:

% date -d @1401714179
Mon Jun  2 09:02:59 EDT 2014

... which means that you haven't rebooted in a month, or your boot
scripts aren't automatically running fsck, or your clock is
incorrect.

The first inconsistency was detected in the function
ext4_mb_generate_buddy(), in line 756.  This means there's an
inconsistency between the number of blocks marked as in use in a block
allocation bitmap, and summary statistics in the block group
descriptor.  This can be caused by a hardware hiccup, or some kind of
kernel bug.

People have been reporting an increased incidence rate of this bug
since 3.15, so it's something we're trying to track down.  There have
been some reports of eMMC bugs in 3.15 (see one such report at:
https://lkml.org/lkml/2014/6/12/19).  But other people are reporting
this on SSD's such as the Samsung 840 PRO, which is a SATA attached
device.  See some of the messages on ext4 with the subject line:
"ext4: journal has aborted").

At this point I suspect we have multiple causes that result in the
same symptom that have all appeared at about the same time, which has
made tracking down the root cause(s) very difficult.

It does seem to happen more often after an unclean shutdown, and there
does seem to be a very high correlation with eMMC devices.  It's
possible there is a jbd2 bug that got introduced recently, where ext4
is modifying some field outside of a journal transaction.  But I
haven't been able to reproduce this yet in controlled circumstances.

What I need from people reporting problems: 

* What is the HDD/SSD/eMMC device involved

* What kernel version were you running

* What distribution are you running (more so I know what the init
  scripts might or might not have been doing vis-a-vis running fsck
  after a crash)

* Was there an unclean shutdown / power drop / hard reset involved?
  If so, did the HDD/SSD/eMMC lose power, or was the reset button hit
  on the machine?

* What sort of workload / application / test program running before
  the crash, if any?


I really need all of this information, especially since at this point
I suspect there may be more than one cause with similar symptoms.  So
it's important that just because someone else reports a similar
symptom, that folks not assume because one person has reported one set
of hardware / software details, that it's the same problem as theirs,
and so they don't need to report anymore info.  I need as many data
points as possible at this point.

						- Ted
