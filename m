From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Tracking down suspend/resume ext3/mmc issues on imx233
Date: Thu, 20 Sep 2012 01:23:49 +0200
Message-ID: <20120919232349.GA24132@elf.ucw.cz>
References: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
 <20120907060552.GL26709@S2101-09.ap.freescale.net>
 <CAEOSq-PV+7c2nvu3uauOLJcV7WKa1jmd-df0a1H0qY5K4CM5MA@mail.gmail.com>
 <CAKGA1bnug8nqcideOBZyLQZmiVo=G5L3aRHq4k4SNZyH132Y=g@mail.gmail.com>
 <20120910163345.GB3942@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Matt Sealey <matt@genesi-usa.com>,
	Mike Thompson <mpthompson@gmail.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Linux-Arm-Kernel <linux-arm-kernel@lists.infradead.org>,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120910163345.GB3942@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 2012-09-10 12:33:45, Theodore Ts'o wrote:
> On Mon, Sep 10, 2012 at 10:11:48AM -0500, Matt Sealey wrote:
> > Wouldn't it be better if the root filesystem was marked as
> > non-removable in the device tree - or in the case of a truly removable
> > card, just marked in the MMC subsystem - and the MMC subsystem skipped
> > the "it could be removed" for suspend/resume operations?
> 
> I agree, this makes a lot of sense.  If the root file system
> disappears, you're toasted either way, so it's fair to assume that the
> device on which the root file system is located should is
> non-removable.

I'm not sure I agree.

If you treat root fs as removable, you'll get "crash". You'll need to
replay the journal, but data is safe.

If you treat it as non-removable, and someone manages to remove it,
mount, and reinsert, you'll get silent data corruption.

If the card is not removable, mark it as such...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
