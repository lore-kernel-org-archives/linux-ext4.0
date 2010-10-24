From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Sun, 24 Oct 2010 02:20:45 +0200
Message-ID: <201010240220.46113.bs_lists@aakef.fastmail.fm>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101023222605.GC24650@thunk.org> <201010240156.02655.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40703 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758447Ab0JXAUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 20:20:48 -0400
In-Reply-To: <201010240156.02655.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday, October 24, 2010, Bernd Schubert wrote:
> On Sunday, October 24, 2010, Ted Ts'o wrote:
> > On Sat, Oct 23, 2010 at 07:46:56PM +0200, Bernd Schubert wrote:
> > > I'm really looking for something to abort the mount if an error comes
> > > up. However, I just have an idea to do that without an additional
> > > mount flag:
> > > 
> > > Let e2fsck play back the journal only. That way e2fsck could set the
> > > error flag, if it detects a problem in the journal and our pacemaker
> > > script would refuse to mount. That option also would be quite useful
> > > for our other scripts, as we usually first run a read-only fsck,
> > > check the log files (presently by size, as e2fsck always returns an
> > > error code even for journal recoveries...)  and only if we don't see
> > > serious corruption we run e2fsck. Otherwise we sometimes create
> > > device or e2image backups.  Would a patch introducing "-J recover
> > > journal only" accepted?
> > 
> > So I'm confused, and partially it's because I don't know the
> > capabilities of pacemaker.
> > 
> > If you have a pacemaker script, why aren't you willing to just run
> > e2fsck on the journal and be done with it?  Earlier you talked about
> > "man months of effort" to rewrite pacemaker.  Huh?  If the file system

Hmm, maybe we have a mis-understanding here. If we could make e2fsck to *only* 
recovery the journal, that would be perfect. Kernel and e2fsck journal 
recovery should take approximately the same time. But that option does not 
exist yet (well, a half baken patch is on my disk now). If e2fsck then would 
detect as the kernel:
"clear_journal_err: Filesystem error recorded from previous mount" 
and mark the filesystem with an error, that would be all we need to then abort 
the mount in the pacemaker script and allow us to run a real e2fsck outside of 
pacemaker.


Thanks,
Bernd
-- 
Bernd Schubert
DataDirect Networks
