From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Fri, 22 Oct 2010 19:42:49 +0200
Message-ID: <201010221942.49915.bs_lists@aakef.fastmail.fm>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51051 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823Ab0JVRmw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 13:42:52 -0400
In-Reply-To: <20101022172536.GP3127@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday, October 22, 2010, Ted Ts'o wrote:
> On Fri, Oct 22, 2010 at 03:33:29PM +0200, Bernd Schubert wrote:
> > is is really a good idea to allow the filesystem to mount if something
> > like that comes up? I really would prefer if mount would abort.
> > 
> > Oct 22 12:37:36 vm7 kernel: [ 1227.814294] LDISKFS-fs warning (device
> > sfa0074): ldiskfs_clear_journal_err: Filesystem error recorded from p
> > revious mount: IO failure
> > Oct 22 12:37:36 vm7 kernel: [ 1227.814314] LDISKFS-fs warning (device
> > sfa0074): ldiskfs_clear_journal_err: Marking fs in need of filesystem
> > 
> >  check.
> > 
> > (please ignore "ldiskfs", it was just renamed to that by Lustre, but is
> > ext4 based as in RHEL5.5, so 2.6.32-ish).
> 
> Did you try running e2fsck first?  If it detects the error after
> running the journal, it will run the file system check right then and
> there.  If it doesn't, it's a bug.  If you're not running e2fsck

I *think* I got those messages at least once although I run e2fsck. But I'm 
not sure.

> first, and the filesystem had previously detected inconsistencies, the
> long-standing tradition is to allow that, since root should know what
> it's doing.

No, it is far more difficult than that. The devices are managed by pacemaker. 
Which means: I/O  errors come up -> Lustre complains about that in its proc 
file. Pacemaker monitoring fails, so pacemaker stops the device and starts it 
again. If that does not succeed, it tries to start it on fail-over system.
I also cannot tell pacemaker to not to try to re-start after an error, as that 
would completely defeat an HA solution.

> 
> And there are times when you do want to mount a filesystem with known
> errors; for example, in the case of the root file system, we have
> always allowed a read-only mount to continue, so that we can run
> e2fsck without requiring a rescue CD 99% of the time.

Yes, it seems a mount option is missing here. 


Thanks,
Bernd


-- 
Bernd Schubert
DataDirect Networks
