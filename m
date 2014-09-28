From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: 3.17? problems
Date: Sun, 28 Sep 2014 08:46:58 -0400
Message-ID: <20140928124658.GB6694@thunk.org>
References: <20140928104456.GA17400@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140928104456.GA17400@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 28, 2014 at 12:44:56PM +0200, Pavel Machek wrote:
> 
> After update to debian testing, my machine sometimes fails to
> reboot. (aptitude upgrade seems to be the trigger).
> 
> So I had to hard power-down the machine. That should be perfectly
> safe, as ext4 has a journal, and this is plain SATA disk, right?
> 
> On next boot to Debian stable, I got stacktrace, and messages about
> ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> it can't fix it, dropped me into emergency shell, _but mounted the
> filesstem, anyway_. Oops.

I've been running 3.17-rc4 plus the ext4 dev patches and due to either
regressions in i915 or the X server (not sure which) over the last
couple of weeks, I've had to power-down my system a number of times
after the system has hung when either shutting down the X server or
when trying to add or remove an external display.  So I've had to
unfortunately do a fair number of hard-power-offs on my T540p, and
I've not noticed any like what you've described.

Can you give any more details?  Are you using LVM or dm-crypt?  Is
this repeatable?

Cheers,

							- Ted
