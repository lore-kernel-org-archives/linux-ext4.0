From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from
 previous mount: IO failure
Date: Sat, 23 Oct 2010 18:17:14 -0400
Message-ID: <20101023221714.GB24650@thunk.org>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
 <20101022172536.GP3127@thunk.org>
 <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47184 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921Ab0JWWRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 18:17:19 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 23, 2010 at 06:00:05PM +0200, Amir Goldstein wrote:
> 
> IMHO, and I've said it before, the mount flag which Bernd requests
> already exists, namely 'errors=', both as mount option and as
> persistent default, but it is not enforced correctly on mount time.
> If an administrator decides that the correct behavior when error is
> detected is abort or remount-ro, what's the sense it letting the
> filesystem mount read-write without fixing the problem?

Again, consider the case of the root filesystem containing an error.
When the error is first discovered during the source of the system's
operation, and it's set to errors=panic, you want to immediately
reboot the system.  But then, when root file system is mounted, it
would be bad to have the system immediately panic again.  Instead,
what you want to have happen is to allow e2fsck to run, correct the
file system errors, and then system can go back to normal operation.

So the current behavior was deliberately designed to be the way that
it is, and the difference is between "what do you do when you come
across a file system error", which is what the errors= mount option is
all about, and "this file system has some kind of error associated
with it".  Just because it has an error associated with it does not
mean that immediately rebooting is the right thing to do, even if the
file system is set to "errors=panic".  In fact, in the case of a root
file system, it is manifestly the wrong thing to do.  If we did what
you suggested, then the system would be trapped in a reboot loop
forever.

							- Ted
