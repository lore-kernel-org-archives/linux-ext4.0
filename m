From: Andy Campbell <andycampbell.uk@gmail.com>
Subject: Re: High latency with ext4 / jbd2 kernel thread
Date: Fri, 15 Jul 2011 11:00:03 +0100
Message-ID: <CALEedhcpBqNFhOmd+3FFHaOCz5aAL1X1ah3uaVy3Lq399TdpSQ@mail.gmail.com>
References: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
	<A9ADAB08-144C-4636-A02B-076CF47300F4@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56070 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab1GOKAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jul 2011 06:00:05 -0400
Received: by gyh3 with SMTP id 3so470134gyh.19
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jul 2011 03:00:03 -0700 (PDT)
In-Reply-To: <A9ADAB08-144C-4636-A02B-076CF47300F4@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, thanks very much for getting back to me

The problem started when I upgraded from Fedora 14 to Fedora 15.
Previously I was using ext3.  However, I was also using a different
firewire stack (the "old stack", instead of the new "Juju stack").
So, there have been several changes around the time that the problem
started, not only a change to Ext4.

I have tried many different buffer sizes on the audio software.
Previously this hardware worked perfectly with 3 * 256 buffers.  I've
tried up to 3 * 1024 buffers, but I still get the same problem.

I tried using barrier=3D0.
This stopped the "writing buffer to disk (synchronous)"  =3D
"jbd2_journal_commit_transaction" latency events from showing, which
is great.  However, I still get high latency from other events in the
system including "kworker/1:1 Executing raw SCSI command" and
"kworker/u:7 - Fork() system call".

These still cause drop-outs on my system.  It looks like either the
new stack is more sensitive to latency, or  something else changed in
the kernel between Fedora 14 and Fedora 15.

I think my conclusion is that my problems are not caused by Ext4, but
are something else... I will keep looking :O)

Thanks for your help!

A

On Tue, Jul 12, 2011 at 12:17 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Jul 11, 2011, at 8:07 PM, Andy Campbell wrote:
>
>> Hi ext4 mailing list members,
>>
>> I hope you can help me with a problem.
>>
>> I recently upgraded my main audio PC to Fedora FC15 and, at the same
>> time, reformatted by root drive to ext4. =A0Since this upgrade this,=
 my
>> system has high system latency which is causing my audio hardware
>> (firewire) to experience buffer under-runs (XRUNs). =A0This causes
>> "unhandled xrun" errors and the audio software fails.
>
> What were you using before? =A0ext3 ? =A0 It may be that ext4's defau=
lt use of
> barriers (for safety reasons) is causing a difference. =A0 Try mounti=
ng your
> file systems with barrier=3D0. =A0 For the root filesystem, add "root=
flags=3Dbarrier=3D0".
> This is an unsafe way to run, in that if you have a power failure whi=
le you
> are writing to the disk, your file system(s) could get corrupted. =A0=
 Ext3
> defaulted to this for historical reasons (although the enterprise Lin=
ux systems,
> RHEL and SuSE changed the default for safety reasons).
>
> If this solves the problem, I'd suggest that you look into finding wa=
ys to
> increase the buffer size of your audio system (were you recording or
> doing playback at the time). =A0 You might also try to see if there w=
as
> some amount of disk activity (especially write activity) that could b=
e
> avoided or find some way of avoiding the use of fsync() so that you
> can re-enable write barriers without causing your latency skips.
>
> Regards,
>
> -- Ted
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
