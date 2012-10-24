From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 20:49:45 +0100
Message-ID: <878vavveee.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:60207 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2JXTuA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 15:50:00 -0400
In-Reply-To: <20121024052351.GB21714@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 01:23:51 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Theodore Ts'o spake thusly:
> Toralf, Nix, if you could try applying this patch (at the end of this
> message), and let me know how and when the WARN_ON triggers, and if it
> does, please send the empty_bug_workaround plus the WARN_ON(1) report.
> I know about the case where a file system is mounted and then
> immediately unmounted, but we don't think that's the problematic case.
> If you see any other cases where WARN_ON is triggering, it would be
> really good to know....

Confirmed, it triggers. Traceback below.


But first, a rather lengthy apology: I did indeed forget something
unusual about my system. In my defence, this is a change I made to my
shutdown scripts many years ago, when umount -l was first introduced
(early 2000s? something like that). So it's not surprising I forgot
about it until I needed to add sleeps to it to capture the tracebacks
below. It is really ugly. You may need a sick bag. In brief: some of my
filesystems will sometimes be uncleanly unmounted and experience journal
replay even on clean shutdowns, and which it is will vary unpredictably.


Some of my machines have fairly intricate webs of NFS-mounted and
non-NFS-mounted filesystems, and I expect them all to reboot
successfully if commanded remotely, because sometimes I'm hundreds of
miles away when I do it and can hardly hit the reset button.

Unfortunately, if I have a mount structure like this:

/usr         local
/usr/foo     NFS-mounted (may be loopback-NFS-mounted)
/usr/foo/bar local

and /usr/foo is down, any attempt to umount /usr/foo/bar will hang
indefinitely. Worse yet, if I umount the nfs filesystem, the local fs
isn't going to be reachable either -- but umounting nfs filesystems has
to happen first so I can killall everything (which would include e.g.
rpc.statd and rpc.nfsd) in order to free up the local filesystems for
umount.

The only way I could see to fix this is to umount -l everything rather
than umounting it (sure, I could do some sort of NFS-versus-non-NFS
analysis and only do this to some filesystems, but testing this
complexity for the -- for me -- rare case of system shutdown was too
annoying to consider). I consider a hang on shutdown much worse than an
occasional unclean umount, because all my filesystems are journalled so
journal recovery will make everything quite happy.

So I do

sync
umount -a -l -t nfs & sleep 2
killall5 -15
killall5 -9
exportfs -ua
quotaoff -a
swapoff -a
LANG=C sort -r -k 2 /proc/mounts | \
(DIRS=""
 while read DEV DIR TYPE REST; do
     case "$DIR" in
         /|/proc|/dev|/proc/*|/sys)
             continue;; # Ignoring virtual file systems needed later
     esac

     case $TYPE in
         proc|procfs|sysfs|usbfs|usbdevfs|devpts)
             continue;; # Ignoring non-tmpfs virtual file systems
     esac
     DIRS="$DIRS $DIR"
done
umount -l -r -d $DIRS) # rely on mount's toposort
sleep 2

The net effect of this being to cleanly umount everything whose mount
points are reachable and which unmounts cleanly in less than a couple of
seconds, and to leave the rest mounted and let journal recovery handle
them. This is clearly really horrible -- I'd far prefer to say 'sleep
until filesystems have finished doing I/O' or better have mount just not
return from mount(8) unless that is true. But this isn't available, and
even it was some fses would still be left to journal recovery, so I
kludged it -- and then forgot about doing anything to improve the
situation for many years.

So, the net effect of this is that normally I get no journal recovery on
anything at all -- but sometimes, if umounting takes longer than a few
seconds, I reboot with not everything unmounted, and journal recovery
kicks in on reboot. My post-test fscks this time suggest that only when
journal recovery kicks in after rebooting out of 2.6.3 do I see
corruption. So this is indeed an unclean shutdown journal-replay
situation: it just happens that I routinely have one or two fses
uncleanly unmounted when all the rest are cleanly unmounted. This
perhaps explains the scattershot nature of the corruption I see, and why
most of my ext4 filesystems get off scot-free.

I'll wait for a minute until you're finished projectile-vomiting. (And
if you have suggestions for making the case of nested local/rewmote
filesystems work without rebooting while umounts may still be in
progress, or even better suggestions to allow me to umount mounts that
happen to be mounted below NFS-mounted mounts with dead or nonresponsive
NFS server, I'd be glad to hear them! Distros appear to take the
opposite tack, and prefer to simply lock up forever waiting for a
nonresponsive NFS server in this situation. I could never accept that.)


[...]

OK. That umount of local filesystems sprayed your added
empty bug workaround and WARN_ONs so many times that nearly all of them
scrolled off the screen -- and because syslogd was dead by now and this
is where my netconsole logs go, they're lost. I suspect every single
umounted filesystem sprayed one of these (and this happened long before
any reboot-before-we're-done).

But I did the old trick of camera-capturing the last one (which was
probably /boot, which has never got corrupted because I hardly ever
write anything to it at all). I hope it's more useful than nothing. (I
can rearrange things to umount /var last, and try again, if you think
that a specific warning from an fs known to get corrupted is especially
likely to be valuable.)

So I see, for one umount at least (and the chunk of the previous one
that scrolled offscreen is consistent with this):

jbd2_mark_journal_empty bug workaround (21218, 21219)
[obscured by light] at fs/jbd2/journal.c:1364 jbd2_mark_journal_empty+06c/0xbd
...
[addresses omitted for sanity: traceback only]
warn_slowpath_common+0x83/0x9b
warn_slowpath_null+0x1a/0x1c
jbd2_mark_journal_empty+06c/0xbd
jbd2_journal_destroy+0x183/0x20c
? abort_exclusive_wait+0x8e/0x8e
ext4_put_super+0x6c/0x316
? evict_inodes+0xe6/0xf1
generic_shutdown_super+0x59/0xd1
? free_vfsmnt+0x18/0x3c
kill_block_super+0x27/0x6a
deactivate_locked_super+0x26/0x57
deactivate_super+0x3f/0x43
mntput_no_expire+0x134/0x13c
sys_umount+0x308/0x33a
system_call_fastpath+0x16/0x1b
