From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous mount: IO failure
Date: Fri, 22 Oct 2010 20:54:41 +0200
Message-ID: <201010222054.42083.bs_lists@aakef.fastmail.fm>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <201010221942.49915.bs_lists@aakef.fastmail.fm> <20101022183219.GQ3127@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36199 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759139Ab0JVSyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:54:47 -0400
In-Reply-To: <20101022183219.GQ3127@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday, October 22, 2010, Ted Ts'o wrote:
> On Fri, Oct 22, 2010 at 07:42:49PM +0200, Bernd Schubert wrote:
> > No, it is far more difficult than that. The devices are managed by
> > pacemaker.  Which means: I/O errors come up -> Lustre complains
> > about that in its proc file. Pacemaker monitoring fails, so
> > pacemaker stops the device and starts it again.
> 
> I'm not sure what errors you're referring to, but if the errors are

There are multiple ways to let Lustre tell you that there is problem. 
Underlying filesystem related is just one of many.

> related to file system inconsistencies, by definition umounting and
> re-mounting isn't going to fix things, and could result in more
> damage.  For certain errors, you really do need to run e2fsck before
> remounting the device.

Yes and that is exactly why I'm asking for another mount option to not allow 
mounts when the filesystem knows better.

> 
> Can you not change pacemaker to stop the device, run e2fsck, and then
> remount the file system?

I am sure I could spend the next 4 weeks to write code that would allow to do 
that with Lustre and pacemaker. But at the same time, it seems far more easy 
to add another mount flag to ext4...

I also cannot simply set a max_failcount=1 in pacemaker, at that would 
completely be against an HA concept. There are so many ways to increase the 
failcount, for example Lustre bugs (ext4 unrelated), pacemaker bugs, human 
errors (something missing on one node, but available on another), etc. A few 
failures (ext4 unrelated) are absolutely 'normal' over a couple of month and 
there is no reason not to allow that.

I'm not asking you to implement another feature, but I'm asking if a patch to 
add a new option would be accepted. I also cannot promise to implement that 
any time soon, given that I will leave DDN end of November. But it seems to be 
option useful for everyone including my desktop. So either I do that over the 
next 4 weeks when I find a minute or during x-mas or so.

Thanks,
Bernd

-- 
Bernd Schubert
DataDirect Networks
