From: Pavel Machek <pavel@ucw.cz>
Subject: ext4: 3.17? problems
Date: Sun, 28 Sep 2014 12:44:56 +0200
Message-ID: <20140928104456.GA17400@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca
To: kernel list <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

After update to debian testing, my machine sometimes fails to
reboot. (aptitude upgrade seems to be the trigger).

So I had to hard power-down the machine. That should be perfectly
safe, as ext4 has a journal, and this is plain SATA disk, right?

On next boot to Debian stable, I got stacktrace, and messages about
ext4 corruption. Back to Debian testing. systemd ran fsck, determined
it can't fix it, dropped me into emergency shell, _but mounted the
filesstem, anyway_. Oops.

Now I'm getting

fsck 1.42.12
...
Inodes that were part of a corrupted orphan linked list found <y>
Deleted inode has zero dtime <y>
(6 inodes) was part of the orphaned inode list. FIXED.
Block bitmap differences.
Free inode counts wrong.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
