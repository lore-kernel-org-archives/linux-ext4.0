From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 15:30:46 -0500
Message-ID: <50884FF6.7030107@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix>	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>	<20121023143019.GA3040@fieldses.org>	<874nllxi7e.fsf_-_@spindle.srvr.nix>	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	=?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab2JXUbS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2012 16:31:18 -0400
In-Reply-To: <878vavveee.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2012 02:49 PM, Nix wrote:
> On 24 Oct 2012, Theodore Ts'o spake thusly:
>> Toralf, Nix, if you could try applying this patch (at the end of this
>> message), and let me know how and when the WARN_ON triggers, and if it
>> does, please send the empty_bug_workaround plus the WARN_ON(1) report.
>> I know about the case where a file system is mounted and then
>> immediately unmounted, but we don't think that's the problematic case.
>> If you see any other cases where WARN_ON is triggering, it would be
>> really good to know....
> 
> Confirmed, it triggers. Traceback below.
> 

<giant snip>

The warn on triggers, but I can't tell - did the corruption still occur
with Ted's patch?

-Eric

> 
> OK. That umount of local filesystems sprayed your added
> empty bug workaround and WARN_ONs so many times that nearly all of them
> scrolled off the screen -- and because syslogd was dead by now and this
> is where my netconsole logs go, they're lost. I suspect every single
> umounted filesystem sprayed one of these (and this happened long before
> any reboot-before-we're-done).
> 
> But I did the old trick of camera-capturing the last one (which was
> probably /boot, which has never got corrupted because I hardly ever
> write anything to it at all). I hope it's more useful than nothing. (I
> can rearrange things to umount /var last, and try again, if you think
> that a specific warning from an fs known to get corrupted is especially
> likely to be valuable.)
> 
> So I see, for one umount at least (and the chunk of the previous one
> that scrolled offscreen is consistent with this):
> 
> jbd2_mark_journal_empty bug workaround (21218, 21219)
> [obscured by light] at fs/jbd2/journal.c:1364 jbd2_mark_journal_empty+06c/0xbd
> ...
> [addresses omitted for sanity: traceback only]
> warn_slowpath_common+0x83/0x9b
> warn_slowpath_null+0x1a/0x1c
> jbd2_mark_journal_empty+06c/0xbd
> jbd2_journal_destroy+0x183/0x20c
> ? abort_exclusive_wait+0x8e/0x8e
> ext4_put_super+0x6c/0x316
> ? evict_inodes+0xe6/0xf1
> generic_shutdown_super+0x59/0xd1
> ? free_vfsmnt+0x18/0x3c
> kill_block_super+0x27/0x6a
> deactivate_locked_super+0x26/0x57
> deactivate_super+0x3f/0x43
> mntput_no_expire+0x134/0x13c
> sys_umount+0x308/0x33a
> system_call_fastpath+0x16/0x1b

