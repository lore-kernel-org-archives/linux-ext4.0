From: LuVar <luvar@plaintext.sk>
Subject: Re: ext4 unknown problem
Date: Wed, 1 Aug 2012 09:33:01 +0100 (GMT+01:00)
Message-ID: <1581230008.179931343809981762.JavaMail.root@shiva>
References: <50180BAC.8070607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	info <info@plaintext.sk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([81.0.124.6]:54672 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HAIdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 04:33:06 -0400
In-Reply-To: <50180BAC.8070607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

----- "Eric Sandeen" <sandeen@redhat.com> wrote:

> On 7/31/12 2:18 AM, luvar@plaintext.sk wrote:
> > Hi,
> > dmesg is probably useles:
> > 
> > Probably some logs after mounting...:
> > 
> > # dmesg | grep EXT
> > EXT3-fs (md2): mounted filesystem with ordered data mode
> > EXT3-fs (md2): using internal journal
> > EXT3-fs (dm-2): using internal journal
> > EXT3-fs (dm-2): mounted filesystem with ordered data mode
> > EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts:
> (null)
> > EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts:
> (null)
> > EXT4-fs (dm-12): mounted filesystem without journal. Opts: (null)
> > EXT4-fs (dm-8): re-mounted. Opts: commit=0
> > EXT4-fs (dm-3): re-mounted. Opts: commit=0
> > EXT4-fs (dm-12): re-mounted. Opts: commit=0
> 
> ^^^ um, what's that all about?

That is some info about startup mounted filesystems. I have about 10-15 mountpoints.

> 
> In theory, according to the docs, that's the same as the default, I
> guess.
> 
> and:
> 
>                 } else if (token == Opt_commit) {
>                         if (arg == 0)
>                                 arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
> 
> ok, I guess it is.
> 
> > EXT4-fs (dm-28): mounted filesystem with ordered data mode. Opts:
> (null)
> > EXT3-fs (dm-10): using internal journal
> > EXT3-fs (dm-10): mounted filesystem with ordered data mode
> > 
> > On last few lines, there is some info about usb key used on thic
> pc:
> > 
> > # dmesg | tail -n 30
> > sd 14:0:0:0: [sdg] Asking for cache data failed
> > sd 14:0:0:0: [sdg] Assuming drive cache: write through
> ...
> 
> > Other lines from dmesg seems not relevant. Should I post them too?
> 
> Usually best to post all the data and let us sort it out, yes.

I have posted it a few minutes ago, but for comfort, my full dmesg is here:
http://dawn.ynet.sk/~luvar/asdf/20120801_1024_dmesg


> 
> -Eric
> 
> > PS: Writing to disk from jbd2/dm-3-8 still active (iotop shows it
> still on top of I/O activity).
> > 
> > LuVar
> > 
> > ----- "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> >> On Mon, Jul 30, 2012 at 08:26:20PM +0100, LuVar wrote:
> >>> Hi,
> >>> I have seriouse issue here. I have copyied about 7GB files to one
> of
> >> my ext4 partitions and from that point of time there is sustained
> >> write to that partition from jbd2/dm-3-8 process. I have lunched
> "sudo
> >> sync" command (about day ago :) and a few hours a after sync start,
> I
> >> have tryied to use umount on that partition... Booth of them are
> still
> >> running...
> >>>
> >>> I have no serious data there, but if I could be helpfull in
> >> bugreport, give me some info what to do.
> >>
> >> Try running the dmesg command, and see if there's anything
> >> interesting
> >> there.  If you're not sure if it's interesting, send it to us and
> we
> >> can take a quick look at it.
> >>
> >> Regards,
> >>
> >> 					- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

By,
--
LuVar
