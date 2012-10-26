From: Martin <marogge@onlinehome.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 22:13:43 +0200
Message-ID: <508AEEF7.8060301@onlinehome.de>
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it> <jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it> <jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it> <jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it> <jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it> <50882787.3030504@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	stable@vger.kernel.org, gregkh@linuxfoundation.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab2JZUNt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 16:13:49 -0400
In-Reply-To: <50882787.3030504@onlinehome.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2012 07:38 PM, Martin wrote:
> On 10/24/2012 01:40 AM, Nix wrote:
>
>> It's true that in less than a week
>> probably not all that many people have rebooted often enough to trip
>> over this.
>>
>> I hope.
>>
>
> [previous bug report]

First off let me apologize for not having the right follow-up headers, 
but I am not subscribed and I read the list behind an NNTP gateway.

I have studied my corruption problem more closely and can give you a 
description of what happened below. Would you say this may be the same bug?

Thx and regards,

Martin

------------------ snip ---------------------------

Storyboard for my root filesystem crash (source: system logs and memory)
========================================================================

Oct 13 07:48:15

Computer is booted. Computer is then suspended and resumed a few times.


Oct 15 18:43:19

Final resume event before the issue starts. At some point prior to the 
next timestamp the computer freezes. Probably just the video hardware 
becoming unresponsive, but the teenage user does not know about ssh or 
alt-sysreq and decides to turn the killswitch.

He then remembers he is supposed to do a clean shutdown at all times and 
boots the computer again in order to perform a clean shutdown:


Oct 15 19:04:20

Computer is booted for the sole reason to be shut down again.


Oct 15 19:05:15

Computer halts. Nothing unusual in the system logs.


Oct 15 19:56:12

Computer is booted again in order to copy a few files to memory stick. 
Unbeknownst to me, the following entries are logged in the system log:

Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): 
add_dirent_to_buf:1587: inode #655361: block 2629945: comm mount: bad 
entry in directory: rec_len % 4 != 0 - offset=360(360), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:00:16 harold kernel: Aborting journal on device sda5-8.
Oct 15 20:00:16 harold kernel: EXT4-fs (sda5): Remounting filesystem 
read-only
Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in 
ext4_evict_inode:238: Journal has aborted
Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in 
ext4_create:2120: IO failure
Oct 15 20:00:16 harold hp-systray: hp-systray[1594]: warning: No hp: or 
hpfax: devices found in any installed CUPS queue. Exiting.
Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): 
search_dirblock:1098: inode #655361: block 2629945: comm 
dbus-daemon-lau: bad entry in directory: rec_len % 4 != 0 - 
offset=360(8552), inode=655682, rec_len=18, name_len=5
Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): 
search_dirblock:1098: inode #655361: block 2629945: comm 
dbus-daemon-lau: bad entry in directory: rec_len % 4 != 0 - 
offset=360(8552), inode=655682, rec_len=18, name_len=5
Oct 15 20:01:06 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'video' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:01:06 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] No Caching mode page 
present
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] Assuming drive cache: 
write through
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] No Caching mode page 
present
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] Assuming drive cache: 
write through
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] No Caching mode page 
present
Oct 15 20:01:07 harold kernel: sd 8:0:0:0: >[sdc] Assuming drive cache: 
write through
Oct 15 20:01:19 harold udisksd[1710]: Mounted /dev/sdc1 at 
/run/media/jan/INTENSO on behalf of uid 1002
Oct 15 20:01:21 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm pool: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:01:59 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'video' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:01:59 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'video' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:02:17 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'video' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:02:20 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:04:54 harold udisksd[1710]: Mounted /dev/sr0 at 
/run/media/jan/Sixth Sense on behalf of uid 1002
Oct 15 20:05:31 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm bash: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:05:38 harold last message repeated 16 times
Oct 15 20:06:00 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm ls: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:06:43 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm ls: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:06:59 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm mc: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:06:59 harold kernel: EXT4-fs error (device sda5): 
htree_dirblock_to_tree:861: inode #655361: block 2629945: comm mc: bad 
entry in directory: rec_len % 4 != 0 - offset=360(8552), inode=655682, 
rec_len=18, name_len=5
Oct 15 20:07:13 harold kernel: nf_conntrack: automatic helper assignment 
is deprecated and it will be removed soon. Use the iptables CT target to 
attach helpers instead.


Since the memory stick couldn't be accessed I had decided at this point 
to look into /etc/groups which is a common cause for this. The file or 
directory entry was missing. Further messages while unmounting:


Oct 15 20:09:25 harold kernel: usb 1-1: >USB disconnect, device number 2
Oct 15 20:09:25 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'video' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:09:26 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:09:26 harold udisksd[1710]: Cleaning up mount point 
/run/media/jan/INTENSO (device 8:33 no longer exist)
Oct 15 20:09:41 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'video' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:09:41 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:09:41 harold kernel: NVRM: GPU at 0000:02:00: 
GPU-918d6d1b-c9fb-6232-601c-99ea6ba768a7
Oct 15 20:09:41 harold acpid: client 1512[0:0] has disconnected
Oct 15 20:09:41 harold acpid: client 1512[0:0] has disconnected
Oct 15 20:09:41 harold acpid: client connected from 2241[0:0]
Oct 15 20:09:41 harold acpid: 1 client rule loaded
Oct 15 20:09:42 harold acpid: client connected from 2241[0:0]
Oct 15 20:09:42 harold acpid: 1 client rule loaded
Oct 15 20:09:42 harold kdm_greet[2245]: Cannot load 
/usr/share/apps/kdm/faces/.default.face: Datei oder Verzeichnis nicht 
gefunden
Oct 15 20:09:44 harold acpid: client 2241[0:0] has disconnected
Oct 15 20:09:47 harold acpid: client 2241[0:0] has disconnected


At this point I went into runlevel 1 to troubleshoot, but then decided 
to reboot and do an fsck from an initrd environment.


Oct 15 20:09:55 harold init: Switching to runlevel: 1
Oct 15 20:09:55 harold udevd[955]: specified group 'plugdev' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'netdev' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'tty' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'dialout' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'kmem' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'video' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'audio' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'lp' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'disk' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'floppy' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'cdrom' unknown
Oct 15 20:09:55 harold udevd[955]: specified group 'tape' unknown
Oct 15 20:09:58 harold squid: getgrnam failed to find groupid for 
effective group 'nogroup'
Oct 15 20:09:58 harold squid: getgrnam failed to find groupid for 
effective group 'nogroup'
Oct 15 20:09:58 harold (squid-1): getgrnam failed to find groupid for 
effective group 'nogroup'
Oct 15 20:09:58 harold acpid: exiting
Oct 15 20:09:58 harold syslogd 1.5.0: restart.
Oct 15 20:09:58 harold kernel: Kernel logging (proc) stopped.
Oct 15 20:09:58 harold kernel: Kernel log daemon terminating.
Oct 15 20:09:58 harold sshd[1307]: Received SIGHUP; restarting.
Oct 15 20:09:58 harold ntpd[1314]: ntpd exiting on signal 1
Oct 15 20:09:58 harold dbus[1333]: [system] Reloaded configuration
Oct 15 20:09:58 harold sshd[2313]: Server listening on 0.0.0.0 port 22.
Oct 15 20:10:04 harold exiting on signal 15


The fsck fixed some issues and testified a clean state.

The next reboot did not even get logged in the system logs, and logon 
was refused.

I have now looked at the filesystem again from an initrd environment. 
Result: lost+found contains 577 files, 90 of which are directories. All 
of them seem to be from /etc. I will try to rename them to their proper 
name on another machine, and restore them on the target machine. 
However, due to the sheer number this might take forever. Also I am 
worried the problem might re-surface, as it has neither been identified 
nor fixed.

Full system logs are available on request.

NB: kernel was v3.5.5 with CK1 and BFQ patches, tainted by nvidia 
module. The rootfs was mounted as type ext4 with mount options 
discard,noatime,nodiratime,errors=remount-ro


