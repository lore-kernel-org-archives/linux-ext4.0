From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Tracking down suspend/resume ext3/mmc issues on imx233
Date: Wed, 19 Sep 2012 20:01:10 -0400
Message-ID: <20120920000110.GA16672@thunk.org>
References: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
 <20120907060552.GL26709@S2101-09.ap.freescale.net>
 <CAEOSq-PV+7c2nvu3uauOLJcV7WKa1jmd-df0a1H0qY5K4CM5MA@mail.gmail.com>
 <CAKGA1bnug8nqcideOBZyLQZmiVo=G5L3aRHq4k4SNZyH132Y=g@mail.gmail.com>
 <20120910163345.GB3942@thunk.org>
 <20120919232349.GA24132@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Sealey <matt@genesi-usa.com>,
	Mike Thompson <mpthompson@gmail.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Linux-Arm-Kernel <linux-arm-kernel@lists.infradead.org>,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51641 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab2ITABU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 20:01:20 -0400
Content-Disposition: inline
In-Reply-To: <20120919232349.GA24132@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 20, 2012 at 01:23:49AM +0200, Pavel Machek wrote:
> 
> I'm not sure I agree.
> 
> If you treat root fs as removable, you'll get "crash". You'll need to
> replay the journal, but data is safe.
> 
> If you treat it as non-removable, and someone manages to remove it,
> mount, and reinsert, you'll get silent data corruption.

We could detect this case; if the file system gets mounted, the last
mount time will change.  So one of the things we could do is have the
file system code freeze the file system at suspend time, so the file
system is consistent (which will reduce the probability of data loss
if the system never comes back up after the suspend), and save the
last mount time and last write time in memory.  When the system comes
back from resume, have the file system code check the last mount and
last write time, and if they have changed, it can refuse the resume
and abort the system to avoid data corruption.  It would require
making ext3/ext4 suspend-aware, but it would be doable, if we really
wanted to support this.

						- Ted
