From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from
 previous mount: IO failure
Date: Fri, 22 Oct 2010 14:32:19 -0400
Message-ID: <20101022183219.GQ3127@thunk.org>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
 <20101022172536.GP3127@thunk.org>
 <201010221942.49915.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60399 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab0JVScV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:32:21 -0400
Content-Disposition: inline
In-Reply-To: <201010221942.49915.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 07:42:49PM +0200, Bernd Schubert wrote:
> No, it is far more difficult than that. The devices are managed by
> pacemaker.  Which means: I/O errors come up -> Lustre complains
> about that in its proc file. Pacemaker monitoring fails, so
> pacemaker stops the device and starts it again.

I'm not sure what errors you're referring to, but if the errors are
related to file system inconsistencies, by definition umounting and
re-mounting isn't going to fix things, and could result in more
damage.  For certain errors, you really do need to run e2fsck before
remounting the device.

Can you not change pacemaker to stop the device, run e2fsck, and then
remount the file system?

It seems like the safer the thing to do.

					- Ted

