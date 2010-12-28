From: Con Kolivas <kernel@kolivas.org>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 20:09:21 +1100
Message-ID: <201012282009.21890.kernel@kolivas.org>
References: <201012280953.46149.kernel@kolivas.org> <20101228025343.GD10149@thunk.org> <20101228081917.GA1351@bitwizard.nl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-usb@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from home.kolivas.org ([59.167.196.135]:39989 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0L1JJd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 04:09:33 -0500
In-Reply-To: <20101228081917.GA1351@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Dec 2010 19:19:17 Rogier Wolff wrote:
> On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
> > On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
> > > [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data
> > > mode. Opts: (null)
> > > [1048702.736011] EXT4-fs (sde8): error count: 3
> > > [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
> > > ext4_journal_start_sb:251
> > > [1048702.736018] EXT4-fs (sde8): last error at 1289080948:
> > > ext4_put_super:719
> > 
> > That's actually not an error.  It's a report which is generated every
> > 24 hours, indicating that there has been 3 errors since the last time
> > the error count has been cleared, with the first error taking place at
> > Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
> > ext4_journal_start_sb(), at line 251, and the most recent error taking
> > place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
> > ext4_put_super() at line 719.  This is a new feature which was added
> > in 2.6.36.
> 
> Nice. But the issue you're not mentioning is: What errors could have
> happened on the 6th of november? Should Con worry about those errors?
> 
> OK, the chances are that he has rebooted since november, and that an
> older fsck fixed the errors, but not cleared the "fs errror log". Would
> these errors have triggered a "remount-readonly" if the fs was mounted
> like that?

Indeed the FS was remounted as RO at the time. I had to power down the USB 
device and power it up again after umounting the FS and then doing an FSCK 
before it was usable again, and the machine had about a month of uptime when 
it happened. It has not caused a problem since.

Thanks,
Con
-- 
-ck
