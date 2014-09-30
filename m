From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: 3.17? problems
Date: Tue, 30 Sep 2014 23:01:08 +0200
Message-ID: <20140930210108.GB14283@amd>
References: <20140929114408.GC2738@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!


On Sun 2014-09-28 08:46:58, Theodore Ts'o wrote:
> On Sun, Sep 28, 2014 at 12:44:56PM +0200, Pavel Machek wrote:
> > 
> > After update to debian testing, my machine sometimes fails to
> > reboot. (aptitude upgrade seems to be the trigger).
> > 
> > So I had to hard power-down the machine. That should be perfectly
> > safe, as ext4 has a journal, and this is plain SATA disk, right?
> > 
> > On next boot to Debian stable, I got stacktrace, and messages about
> > ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> > it can't fix it, dropped me into emergency shell, _but mounted the
> > filesstem, anyway_. Oops.
> 
> I've been running 3.17-rc4 plus the ext4 dev patches and due to either
> regressions in i915 or the X server (not sure which) over the last
> couple of weeks, I've had to power-down my system a number of times
> after the system has hung when either shutting down the X server or
> when trying to add or remove an external display.  So I've had to
> unfortunately do a fair number of hard-power-offs on my T540p, and
> I've not noticed any like what you've described.

Ok, I'm not 100% sure it was 3.17-rcX... but according to logs, it
is. 3.17-rc4

> Can you give any more details?  Are you using LVM or dm-crypt?  Is
> this repeatable?

No, I don't think it is repeatable in useful way for debugging, but it
is not first time it happened here. No LVM or dm-crypt in use.

> > So I had to hard power-down the machine. That should be perfectly
> > safe, as ext4 has a journal, and this is plain SATA disk, right?
> > 
> AFAIU you have some corruption on your fs (the root of cause is unknown
> at this moment)
> So you have following stages:
> 1) fs corruption
> 2) boot-> mount attempt
> 3) fsck
> During (1) Once ext4 driver found this error it will call ext4_error
> which will tag sb with FS_ERROR flag.
> During (2) it will found that tag and clear s_orphan which result
> in complain you have seen  during(3)

I tried to search syslog, but could not find original messages. It
happened during shutdown. I guess syslog was already stopped at that
point..>?

Logs say:

Sep 28 11:45:38 amd NetworkManager[3422]: <info> Activation (tun0)
successful, device activated.
Sep 28 11:45:38 amd nm-dispatcher: Dispatching action 'up' for tun0
Sep 28 11:45:39 amd systemd[1]: Stopping OpenBSD Secure Shell
server...
Sep 28 11:45:39 amd systemd[1]: Starting OpenBSD Secure Shell
server...
Sep 28 11:45:39 amd systemd[1]: Started OpenBSD Secure Shell server.
Sep 28 11:45:41 amd NetworkManager[3422]: <warn> Could not send ARP
for local address 10.10.0.14: Failed to execute child process
"/sbin/arping" (No such file or directory)
Sep 28 11:45:49 amd ntpdate[1413]: adjust time server 193.85.174.5
offset 0.002797 sec
Sep 28 12:17:01 amd /USR/SBIN/CRON[3612]: (root) CMD (   cd / &&
run-parts --report /etc/cron.hourly)
Sep 28 12:58:12 amd rsyslogd: [origin software="rsyslogd"
swVersion="8.4.0" x-pid="3380" x-info="http://www.rsyslog.com"] start
Sep 28 12:58:12 amd systemd[1]: Starting Load Kernel Modules...
Sep 28 12:58:12 amd systemd[1]: Mounted POSIX Message Queue File
System.
Sep 28 12:58:12 amd systemd[1]: Starting udev Kernel Socket.
Sep 28 12:58:12 amd systemd[1]: Listening on udev Kernel Socket.
Sep 28 12:58:12 amd systemd[1]: Starting udev Control Socket.
Sep 28 12:58:12 amd systemd[1]: Listening on udev Control Socket.
Sep 28 12:58:12 amd systemd[1]: Starting udev Coldplug all Devices...
Sep 28 12:58:12 amd systemd[1]: Started Set Up Additional Binary
Formats.
Sep 28 12:58:12 amd systemd[1]: Starting Dispatch Password Requests to
Console Directory Watch.
Sep 28 12:58:12 amd systemd[1]: Started Dispatch Password Requests to
Console Directory Watch.
Sep 28 12:58:12 amd systemd[1]: Mounting Debug File System...
Sep 28 12:58:12 amd kernel: Initializing cgroup subsys cpu
Sep 28 12:58:12 amd kernel: Linux version 3.17.0-rc4 (pavel@amd) (gcc
version 4.9.1 (Debian 4.9.1-12) ) #1 SMP Sun Sep 14 21:24:53 CEST 2014

> > After update to debian testing, my machine sometimes fails to
> > reboot. (aptitude upgrade seems to be the trigger).
> > 
> > So I had to hard power-down the machine. That should be perfectly
> > safe, as ext4 has a journal, and this is plain SATA disk, right?
>   Yes, it should be safe.

Good.

> > On next boot to Debian stable, I got stacktrace, and messages about
> > ext4 corruption. Back to Debian testing. systemd ran fsck, determined
>   It would be really good to get those messages... Ideally you could also
> use
>   e2image -r <partition> | bzip2 -c
> to store fs metadata before doing anything else with the fs to a usb stick.
> That is invaluable for future analysis.

Too late for that :-(.

> > it can't fix it, dropped me into emergency shell, _but mounted the
> > filesstem, anyway_. Oops.
>   What kernel versions are you running in Debian testing and stable?

Debian testing was 3.17-rc4, AFAICT. For debian stable -- not sure.

> My guess would be that kernel had problems only during orphan inode
> recovery (i.e. when deleting already deleted files) and we let the mount
> proceed if this fails because it's a relatively harmless problem.

Is there some phase during shutdown where journalling no longer
protects fs integrity?

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
