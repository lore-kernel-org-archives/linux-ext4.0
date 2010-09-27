From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Mon, 27 Sep 2010 16:01:11 -0700
Message-ID: <20100927230111.GV25555@tux1.beaverton.ibm.com>
References: <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36602 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0I0XBp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Sep 2010 19:01:45 -0400
Content-Disposition: inline
In-Reply-To: <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 24, 2010 at 12:24:04AM -0600, Andreas Dilger wrote:
> On 2010-09-23, at 17:25, Darrick J. Wong wrote:
> > To try to find an explanation, I started looking for connections between
> > fsync delay values and average flush times.  I noticed that the setups with
> > low (< 8ms) flush times exhibit better performance when fsync coordination
> > is not attempted, and the setups with higher flush times exhibit better
> > performance when fsync coordination happens.  This also is no surprise, as
> > it seems perfectly reasonable that the more time consuming a flush is, the
> > more desirous it is to spend a little time coordinating those flushes
> > across CPUs.
> > 
> > I think a reasonable next step would be to alter this patch so that
> > ext4_sync_file always measures the duration of the flushes that it issues,
> > but only enable the coordination steps if it detects the flushes taking
> > more than about 8ms.  One thing I don't know for sure is whether 8ms is a
> > result of 2*HZ (currently set to 250) or if 8ms is a hardware property.
> 
> Note that the JBD/JBD2 code will already dynamically adjust the journal flush
> interval based on the delay seen when writing the journal commit block.  This
> was done to allow aggregating sync journal operations for slow devices, and
> allowing fast (no delay) sync on fast devices.  See jbd2_journal_stop() for
> details.
> 
> I think the best approach is to just depend on the journal to do this sync
> aggregation, if at all possible, otherwise use the same mechanism in ext3/4
> for fsync operations that do not involve the journal (e.g. nojournal mode,
> data sync in writeback mode, etc).

I've been informed that there's confusion about how to interpret this
spreadsheet.  I'll first provide a few clarifications, then discuss Andreas'
suggestion, which I've coded up and given some light testing.

Zeroth, the kernel is 2.6.36-rc5 with a few patchsets applied:
 1. Tejun Heo's conversion of barriers to flush/fua.
 2. Jan Kara's barrier generation patch.
 3. My old patch to record if there's dirty data in the disk cache.
 4. My newer patch to implement fsync coordination in ext4.
 5. My newest patch which implements coordination via jbd2.

Patches 2, 3, 4, and 5 all have debugging toggles so I can quickly run
experiments.

First, the "fsync_delay_us" column records the behavior of my (latest) fsync
coordination patch.  The raw control values might be a bit confusing, so I
elaborated them a little more in the spreadsheet.  The "old fsync behavior"
entries use the current upstream semantics (no coordination, everyone issues
their own flush).  "jbd2 fsync" means coordination of fsyncs through jbd2 as
detailed below.  "use avg sync time" measures the average time it takes to
issue a flush command, and tells the first thread into ext4_sync_pages to wait
that amount of time for other threads to catch up.

Second, the "nojan" column is a control knob I added to Jan Kara's old barrier
generation patch so that I could measure its effects.  0 means always track
barrier generations and don't submit flushes for already-flushed data.  1 means
always issue flushes, regardless of generation counts.

Third, the "nodj" column is a control knob that controls my old
EXT4_STATE_DIRTY_DATA patch.  A zero here means that a flush will only be
triggered if ext4_write_page has written some dirty data and there hasn't been
a flush yet.  1 disables this logic.

Fourth, the bolded cells in the table represent the highest transactions per
second count across all fsync_delay_us values when holding the other four
control variables constant.  For example, let's take a look at
host=elm3a4,directio=0,nojan=0,nodj=0.  There are five fsync_delay_us values
(old, jbd2, avg, 1, 500) and five corresponding results (145.84, 184.06,
181.58, 152.39, 158.19).  184.06 is the highest, hence jbd2 wins and is in bold
face.

Background colors are used to group the rows by fsync_delay_us.

The barriers=0 results are, of course, the transactions per second count when
the fs is mounted with barrier support disabled.  This ought to provide a rough
idea of the upper performance limit of each piece of hardware.

------

As for Andreas' suggestion, he wants ext4 to use jbd2 as coordination point for
all fsync calls.  I could be wrong, but I think that the following snippet
ought to do the trick:

h = ext4_journal_start(journal, 0);
ext4_journal_stop(h);
if (jbd2_journal_start_commit(journal, &target))
	jbd2_log_wait_commit(journal, target);

It looks as though this snippet effectively says "Send an empty transaction.
Then, if there are any live or committing transactions, wait for them to
finish", which sounds like what we want.  I figured this also means that the
nojan/nodj settings would not have any significant effect on the results, which
seems to be true (though nojan/nodj have had little effect under Tejun's
patchset).  So I coded up that patch and gave it a spin on my testing farm.
The results have been added to the 2.6.36-rc5 spreadsheet.  Though I have to
say, this seems like an awful lot of overhead just to issue a flush command.

Given a quick look around the jbd2 code, it seems that going through the journal
ought to have a higher overhead cost, which would negatively impact performance
on hardware that features low flush times, and this seems to be true for
elm3a63, elm3c44_sas, and elm3c71_sas in directio=1 mode, where we see rather
large regressions against fsync_delay=avg_sync_time.  Curiously, I saw a
dramatic increase in speed for the SSDs when directio=1, which probably relates
to the way SSDs perform writes.

Other than those regressions, the jbd2 fsync coordination is about as fast as
sending the flush directly from ext4.  Unfortunately, where there _are_
regressions they seem rather large, which makes this approach (as implemented,
anyway) less attractive.  Perhaps there is a better way to do it?

--D
