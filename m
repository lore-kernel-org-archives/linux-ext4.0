From: darxus@chaosreigns.com
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Tue, 4 Sep 2012 03:19:57 -0400
Message-ID: <20120904071957.GG19158@chaosreigns.com>
References: <20120903220213.GE19158@chaosreigns.com>
 <20120904032919.GJ5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from panic.chaosreigns.com ([64.71.152.40]:59103 "EHLO
	panic.chaosreigns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2IDHT6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 03:19:58 -0400
Content-Disposition: inline
In-Reply-To: <20120904032919.GJ5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03, Theodore Ts'o wrote:
> The error means that the metadata associated with one of Chromium's
> cache files had gotten corrected.  You say you saw this exact same
> error separated in time by three months.  

Yes.

> Between those three months,
> was the file system corruption fixed by an e2fsck run?

I'll admit I have a pretty bad habit of skipping fscks when they come
up, but when I got that error, my system had just remounted its main
filesystem readonly, and said those scary things in dmesg, and the first
thing I did was reboot and let fsck do whatever it wanted, including a
number of other scary things requiring me to confirm that I wanted it
to go ahead a bunch of times.

So, hard to say for certain, but it seems unlikely that this correction
would not have been included in that.

> If not, the fact that you are getting this message twice isn't
> surprising.  The e2fsck program *should* have been run at each reboot,
> but this error may have required manual intervention to fix up.
> 
> If you did run e2fsck, and the file system corruptions was fixed
> between the two times that you saw the EXT4-fs error message, then
> that is very interesting.  I would discount scribbling over kernel
> memory, since it would be pretty unusual that the exact same inode and
> the exact same block had gotten corrupted in exactly the same way.  It
> could be a bug in the graphics driver, perhaps triggered by the way
> Wayland is using said graphics driver.
> 
> That also seems fairly hard to credit, so I'm going to hope you didn't
> actually run e2fsck to fix the file system corruption....

Yeah, this all seems very unlikely, yet... 

I have lots of photos of the fsck this time, and all the questions it asked
me.  But I guess I should re-fsck (forced), make sure it's all happy, check
my backups, and try to repeat the problem?  :/

-- 
"Eh, wisdom's overrated. I prefer beatings and snacks."
- Unity, Skin Horse
http://www.ChaosReigns.com
