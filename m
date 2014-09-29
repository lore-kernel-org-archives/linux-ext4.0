From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: 3.17? problems
Date: Mon, 29 Sep 2014 13:44:08 +0200
Message-ID: <20140929114408.GC2738@quack.suse.cz>
References: <20140928104456.GA17400@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140928104456.GA17400@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Sun 28-09-14 12:44:56, Pavel Machek wrote:
> After update to debian testing, my machine sometimes fails to
> reboot. (aptitude upgrade seems to be the trigger).
> 
> So I had to hard power-down the machine. That should be perfectly
> safe, as ext4 has a journal, and this is plain SATA disk, right?
  Yes, it should be safe.

> On next boot to Debian stable, I got stacktrace, and messages about
> ext4 corruption. Back to Debian testing. systemd ran fsck, determined
  It would be really good to get those messages... Ideally you could also
use
  e2image -r <partition> | bzip2 -c
to store fs metadata before doing anything else with the fs to a usb stick.
That is invaluable for future analysis.

> it can't fix it, dropped me into emergency shell, _but mounted the
> filesstem, anyway_. Oops.
  What kernel versions are you running in Debian testing and stable?
My guess would be that kernel had problems only during orphan inode
recovery (i.e. when deleting already deleted files) and we let the mount
proceed if this fails because it's a relatively harmless problem.

> Now I'm getting
> 
> fsck 1.42.12
> ...
> Inodes that were part of a corrupted orphan linked list found <y>
> Deleted inode has zero dtime <y>
> (6 inodes) was part of the orphaned inode list. FIXED.
> Block bitmap differences.
> Free inode counts wrong.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
