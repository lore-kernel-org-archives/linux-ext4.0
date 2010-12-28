From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 09:19:17 +0100
Message-ID: <20101228081917.GA1351@bitwizard.nl>
References: <201012280953.46149.kernel@kolivas.org> <20101228025343.GD10149@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Con Kolivas <kernel@kolivas.org>,
	linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101228025343.GD10149@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
> > [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode. 
> > Opts: (null)
> > [1048702.736011] EXT4-fs (sde8): error count: 3
> > [1048702.736016] EXT4-fs (sde8): initial error at 1289053677: 
> > ext4_journal_start_sb:251
> > [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719
> 
> That's actually not an error.  It's a report which is generated every
> 24 hours, indicating that there has been 3 errors since the last time
> the error count has been cleared, with the first error taking place at
> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
> ext4_journal_start_sb(), at line 251, and the most recent error taking
> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
> ext4_put_super() at line 719.  This is a new feature which was added
> in 2.6.36.

Nice. But the issue you're not mentioning is: What errors could have 
happened on the 6th of november? Should Con worry about those errors?

OK, the chances are that he has rebooted since november, and that an
older fsck fixed the errors, but not cleared the "fs errror log". Would
these errors have triggered a "remount-readonly" if the fs was mounted 
like that?

I don't reboot that often: 

obelix:~> uptime
 09:16:19 up 175 days, 19:04, 19 users,  load average: 110.10, 110.61, 111.22

(and yes, the load is quite high on that machine. I won't polute this
thread about that....)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
