From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Tue, 15 Jul 2014 08:31:01 +0200
Message-ID: <20140715083101.2c70e8f5@archvile>
References: <20140704154559.026331ec@archvile>
	<20140704184539.GA11103@thunk.org>
	<20140707141701.2f9529af@archvile>
	<20140707155310.GB8254@thunk.org>
	<20140707225619.GD8254@thunk.org>
	<20140710185748.GA26636@wallace>
	<20140710200126.GE10417@birch.djwong.org>
	<CAFnufp2yDsbHby6Ye-Ldjz=qGWyxOJUMv8JZJa-5+f6CUFSpYw@mail.gmail.com>
	<20140710223245.GB12018@thunk.org>
	<20140711001334.GF10417@birch.djwong.org>
	<20140711004507.GB26636@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Matteo Croce <technoboy85@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Azat Khuzhin <a3at.mail@gmail.com>
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:8347 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbaGOGbB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2014 02:31:01 -0400
In-Reply-To: <20140711004507.GB26636@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Dear Eric, Ted, ...

On Thu, 10 Jul 2014 20:45:08 -0400
Eric Whitney <enwlinux@gmail.com> wrote:

> * Darrick J. Wong <darrick.wong@oracle.com>:
> > On Thu, Jul 10, 2014 at 06:32:45PM -0400, Theodore Ts'o wrote:
> > > To be clear, what you would need to do is to revert commit
> > > 007649375f6af242d5b1df2c15996949714303ba to prevent the fs corruption.
> > > Darrick's patch is one that tries to fix the problem addressed by that
> > > commit in a different fashion.
> > > 
> > > Quite frankly, reverting the commit, which is causing real damage, is
> > > far more impotrant to me right now than what to do in order allow
> > > CONFIG_EXT4FS_DEBUG to work (which is nice, but it's only something
> > > that file system developers need, and to be honest I can't remember
> > > the last time I've used said config option).  But if we know that
> > > Darrick's fix works, I'm willing to push that to Linus at the same
> > > time that I push a revert of 007649375f6af242d5b1df2c15996949714303ba
> > 
> > Reverting the 007649375... patch doesn't seem to create any obvious regressions
> > on my test box (though again, I was never able to reproduce it as consistently
> > as Eric W.).
> > 
> > Tossing in the [1] patch also fixes the crash when CONFIG_EXT4_DEBUG=y on
> > 3.16-rc4.  I'd say it's safe to send both to Linus and stable.
> > 
> > If anyone experiences problems that I'm not seeing, please yell loudly and
> > soon!
> > 
> 
> Reverting the suspect patch - 007649375f - on 3.16-rc3 and running on the
> Panda yielded 10 successive "successful" generic/068 failures (no block
> bitmap trouble on reboot).  So, it looks like that patch is all of it.
> 
> Running the same test scenario on Darrick's patch (CONFIG_EXT4FS_DEBUG =>
> CONFIG_EXT4_DEBUG) applied to 3.16-rc3 lead to exactly the same result.
> No panics, BUGS, or other misbehavior whether generic/068 completed 
> successfully or failed (and that test used here simply because it was
> convenient) and no trouble on boot, etc.

Thanks a lot to everyone for the excellent work hunting this down!
I can confirm that on 3.16-rc5 the problem is gone. At least after extensively
testing yesterday, I have not been unable to reproduce it. No ext4 error
messages and no filesystem corruption anymore!

Best regards,

-- 
David Jander
Protonic Holland.
