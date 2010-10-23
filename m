From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Sat, 23 Oct 2010 19:46:56 +0200
Message-ID: <201010231946.56794.bs_lists@aakef.fastmail.fm>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57462 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902Ab0JWRq7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 13:46:59 -0400
In-Reply-To: <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday, October 23, 2010, Amir Goldstein wrote:
> On Fri, Oct 22, 2010 at 7:25 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Fri, Oct 22, 2010 at 03:33:29PM +0200, Bernd Schubert wrote:
> >> is is really a good idea to allow the filesystem to mount if something
> >> like that comes up? I really would prefer if mount would abort.
> >> 
> >> Oct 22 12:37:36 vm7 kernel: [ 1227.814294] LDISKFS-fs warning (device
> >> sfa0074): ldiskfs_clear_journal_err: Filesystem error recorded from p
> >> revious mount: IO failure
> >> Oct 22 12:37:36 vm7 kernel: [ 1227.814314] LDISKFS-fs warning (device
> >> sfa0074): ldiskfs_clear_journal_err: Marking fs in need of filesystem
> >> check.
> >> 
> >> (please ignore "ldiskfs", it was just renamed to that by Lustre, but is
> >> ext4 based as in RHEL5.5, so 2.6.32-ish).
> > 
> > Did you try running e2fsck first?  If it detects the error after
> > running the journal, it will run the file system check right then and
> > there.  If it doesn't, it's a bug.  If you're not running e2fsck
> > first, and the filesystem had previously detected inconsistencies, the
> > long-standing tradition is to allow that, since root should know what
> > it's doing.
> > 
> > And there are times when you do want to mount a filesystem with known
> > errors; for example, in the case of the root file system, we have
> > always allowed a read-only mount to continue, so that we can run
> > e2fsck without requiring a rescue CD 99% of the time.
> 
> Ted,
> 
> IMHO, and I've said it before, the mount flag which Bernd requests
> already exists, namely 'errors=',
> both as mount option and as persistent default, but it is not enforced
> correctly on mount time.
> If an administrator decides that the correct behavior when error is
> detected is abort or remount-ro,
> what's the sense it letting the filesystem mount read-write without
> fixing the problem?
> I realize that the umount/mount may have fixed things by "unrolling"
> the last transaction,
> but still, the state of ERROR_FS with read-write mount, seems to be
> inconsistent the the defined errors behavior.
> root can always use errors=continue mount to override this restriction.

Hmm, yes and no, while mounting it read-only eventually will be later on 
detected by Lustre, that would cause a fencing/stonith of the hole node. 

I'm really looking for something to abort the mount if an error comes up. 
However, I just have an idea to do that without an additional mount flag:

Let e2fsck play back the journal only. That way e2fsck could set the error 
flag, if it detects a problem in the journal and our pacemaker script would 
refuse to mount. That option also would be quite useful for our other scripts, 
as we usually first run a read-only fsck, check the log files (presently by 
size, as e2fsck always returns an error code even for journal recoveries...) 
and only if we don't see serious corruption we run e2fsck. Otherwise we 
sometimes create device or e2image backups.
Would a patch introducing "-J recover journal only" accepted?

Another option is to add a proc or sysfs file stating the health of the 
filesystem.

Thanks,
Bernd




-- 
Bernd Schubert
DataDirect Networks
