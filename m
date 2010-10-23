From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Sun, 24 Oct 2010 01:56:02 +0200
Message-ID: <201010240156.02655.bs_lists@aakef.fastmail.fm>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <201010231946.56794.bs_lists@aakef.fastmail.fm> <20101023222605.GC24650@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55532 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202Ab0JWX4G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 19:56:06 -0400
In-Reply-To: <20101023222605.GC24650@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday, October 24, 2010, Ted Ts'o wrote:
> On Sat, Oct 23, 2010 at 07:46:56PM +0200, Bernd Schubert wrote:
> > I'm really looking for something to abort the mount if an error comes up.
> > However, I just have an idea to do that without an additional mount flag:
> > 
> > Let e2fsck play back the journal only. That way e2fsck could set the
> > error flag, if it detects a problem in the journal and our pacemaker
> > script would refuse to mount. That option also would be quite useful
> > for our other scripts, as we usually first run a read-only fsck,
> > check the log files (presently by size, as e2fsck always returns an
> > error code even for journal recoveries...)  and only if we don't see
> > serious corruption we run e2fsck. Otherwise we sometimes create
> > device or e2image backups.  Would a patch introducing "-J recover
> > journal only" accepted?
> 
> So I'm confused, and partially it's because I don't know the
> capabilities of pacemaker.
> 
> If you have a pacemaker script, why aren't you willing to just run
> e2fsck on the journal and be done with it?  Earlier you talked about
> "man months of effort" to rewrite pacemaker.  Huh?  If the file system

Even if I would rewrite it, it wouldn't get accepted. Upstream would just 
start to discuss the other way around...

> is fine, it will recover the journal, and then see that the file
> system is clean, and then exit.

Now please consider what happens if the filesystem is not clean. Resources in 
pacemaker have start/stop/monitor timeouts. Default upstream timeouts are 
120s. We already increase start timeout to 600s. MMP timeouts could be huge in 
the past, although that is limited now and journal recovery also can take 
quite some time. 
Anyway, there is no way to allow to the such huge timeouts as required by 
e2fsck. Sometimes you simply want to try to mount on another node as fast as 
possible (consider a driver bug, that makes mount to go into D-state) and then 
10 minutes are already a lot. Setting that to hours as might be required by 
e2fsck is not an option (yes, I'm aware of uninit_bg and Lustre sets the of 
course). 
So if we would run e2fsck from the pacemaker script, it simply would be killed 
when the timeout is over. Then it would be started on another node and would 
repeat that ping-ping until the maximum restart counter exceeds.

(And while we are here, I read in the past you had some concerns about MMP, 
but MMP is really a great feature to make double sure the HA software does not 
try to do a double mount. While pacemaker supports minoring compared to old 
heartbeat, it still is not perfect. In fact there exists an 
unmanaged->managed resource state bug, that could easily cause a double 
mount).


> 
> As far as the exit codes, it sounds like you haven't read the man
> page.  The exit codes are documented in both the fsck and e2fsck man
> page, and are standardized across all file systems:
> 
>             0    - No errors
>             1    - File system errors corrected
>             2    - System should be rebooted
>             4    - File system errors left uncorrected
>             8    - Operational error
>             16   - Usage or syntax error
>             32   - Fsck canceled by user request
>             128  - Shared library error
> 
> (These status codes are boolean OR'ed together.)
> 
> An exit code has the '1' bit set, that means that the file system had
> some errors, but they have since been fixed.  And exit code where the
> '2' bit is will only occur in the case of a mounted read-only file
> system, and instructs the init script to reboot before continuing,
> because while the file system may have had errors fixed, there may be
> invalid information cached in memory due to the root file system being
> mounted, so the only safe way to make sure that invalid information
> won't be written back to disk is to reboot.  If you are not checking
> the root filesystem, you will never see the '2' bit being set.
> 
> So if you are looking at the size of the fsck log files, I'm guessing
> it's because no one has bothered to read and understand how the exit
> codes for fsck works.

As I said before, journal replay already sets the '1' bit. So how can I 
differentiate in between journal replay bit '1' and pass1 to pass5 bit '1'?
And no, '2' will never come up for pacemaker managed devices, of course.

> 
> And I really don't understand why you need or want to do a read-only
> fsck first....

I have seen it more than one times that e2fsck causes more damage than there 
had been before. Last case was in January, where an e2fsck version from 2008 
wiped out a Lustre OST. The customer just run it without asking anyone and 
then that old version caused lots of trouble. 
Before "e2fsck -y" the filesystem could be mounted read-only and files could 
be read, as far as I remember.  If you shoulbe be interested, the case with 
some log files is in the Lustre bugzilla.
And as I said before, if 'e2fsck -n' shows that there is required a huge 
repair, we double check what is going on and also then consider to create a 
device or at least an e2image backup. 
As you might understand, no each customer can afford peta-byte backups, so 
they sometimes take the risk of data-loss, but of course also appreciate any 
precautions to prevent that.

Please also note, that Lustre combines *many* ext3/ext4 filesystems into a 
global filesystem. And that high number increases the probability to run into 
bugs by a factor of magnitude.


Thanks,
Bernd


-- 
Bernd Schubert
DataDirect Networks
