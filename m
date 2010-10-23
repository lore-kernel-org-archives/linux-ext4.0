From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from
 previous mount: IO failure
Date: Sat, 23 Oct 2010 18:26:05 -0400
Message-ID: <20101023222605.GC24650@thunk.org>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
 <20101022172536.GP3127@thunk.org>
 <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com>
 <201010231946.56794.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32996 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab0JWW0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 18:26:07 -0400
Content-Disposition: inline
In-Reply-To: <201010231946.56794.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 23, 2010 at 07:46:56PM +0200, Bernd Schubert wrote:
> I'm really looking for something to abort the mount if an error comes up. 
> However, I just have an idea to do that without an additional mount flag:
> 
> Let e2fsck play back the journal only. That way e2fsck could set the
> error flag, if it detects a problem in the journal and our pacemaker
> script would refuse to mount. That option also would be quite useful
> for our other scripts, as we usually first run a read-only fsck,
> check the log files (presently by size, as e2fsck always returns an
> error code even for journal recoveries...)  and only if we don't see
> serious corruption we run e2fsck. Otherwise we sometimes create
> device or e2image backups.  Would a patch introducing "-J recover
> journal only" accepted?

So I'm confused, and partially it's because I don't know the
capabilities of pacemaker.

If you have a pacemaker script, why aren't you willing to just run
e2fsck on the journal and be done with it?  Earlier you talked about
"man months of effort" to rewrite pacemaker.  Huh?  If the file system
is fine, it will recover the journal, and then see that the file
system is clean, and then exit.

As far as the exit codes, it sounds like you haven't read the man
page.  The exit codes are documented in both the fsck and e2fsck man
page, and are standardized across all file systems:

            0    - No errors
            1    - File system errors corrected
            2    - System should be rebooted
            4    - File system errors left uncorrected
            8    - Operational error
            16   - Usage or syntax error
            32   - Fsck canceled by user request
            128  - Shared library error

(These status codes are boolean OR'ed together.)

An exit code has the '1' bit set, that means that the file system had
some errors, but they have since been fixed.  And exit code where the
'2' bit is will only occur in the case of a mounted read-only file
system, and instructs the init script to reboot before continuing,
because while the file system may have had errors fixed, there may be
invalid information cached in memory due to the root file system being
mounted, so the only safe way to make sure that invalid information
won't be written back to disk is to reboot.  If you are not checking
the root filesystem, you will never see the '2' bit being set.

So if you are looking at the size of the fsck log files, I'm guessing
it's because no one has bothered to read and understand how the exit
codes for fsck works.

And I really don't understand why you need or want to do a read-only
fsck first....

						- Ted
