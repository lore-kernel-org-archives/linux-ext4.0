From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: 3.17? problems
Date: Mon, 29 Sep 2014 13:36:43 +0400
Message-ID: <87iok6ojis.fsf@openvz.org>
References: <20140928104456.GA17400@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca
To: Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140928104456.GA17400@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 28 Sep 2014 12:44:56 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
> 
> After update to debian testing, my machine sometimes fails to
> reboot. (aptitude upgrade seems to be the trigger).
> 
> So I had to hard power-down the machine. That should be perfectly
> safe, as ext4 has a journal, and this is plain SATA disk, right?
> 
AFAIU you have some corruption on your fs (the root of cause is unknown
at this moment)
So you have following stages:
1) fs corruption
2) boot-> mount attempt
3) fsck
During (1) Once ext4 driver found this error it will call ext4_error
which will tag sb with FS_ERROR flag.
During (2) it will found that tag and clear s_orphan which result
in complain you have seen  during(3)

My idea is that (2) and (3) is consequences of (1).
Please provide more details(dmsg) about initial error.
> On next boot to Debian stable, I got stacktrace, and messages about
> ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> it can't fix it, dropped me into emergency shell, _but mounted the
> filesstem, anyway_. Oops.
> 
> Now I'm getting
> 
> fsck 1.42.12
> ...
> Inodes that were part of a corrupted orphan linked list found <y>
> Deleted inode has zero dtime <y>
> (6 inodes) was part of the orphaned inode list. FIXED.
> Block bitmap differences.
> Free inode counts wrong.
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
