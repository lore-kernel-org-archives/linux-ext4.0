From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: trim support on 2.6.37
Date: Fri, 7 Jan 2011 18:29:29 -0500
Message-ID: <AANLkTimkf4n8Oyf0c17SCZFbNrpdV9mbcHeTQpkMxbMJ@mail.gmail.com>
References: <1294440738.15738.12.camel@jaschtschik-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jens Kasten <igraltist@rsbac.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59842 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1AGX3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 18:29:50 -0500
Received: by iyi12 with SMTP id 12so16213720iyi.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jan 2011 15:29:50 -0800 (PST)
In-Reply-To: <1294440738.15738.12.camel@jaschtschik-pc>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 7, 2011 at 5:52 PM, Jens Kasten <igraltist@rsbac.org> wrote=
:
> Hi list,
>
> It is the first time the i write to this list.
> I am not sure if it the right place.
>
> I use the kernel 2.6.37 with cryptsetup and lvm on a intel ssd.
> In the logfile after booting i see this entry:
> EXT4-fs (dm-1): re-mounted. Opts: discard,errors=3Dremount-ro
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: disc=
ard
> EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: disc=
ard
> EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: disc=
ard
> EXT4-fs warning (device dm-1): ext4_issue_discard:2619: discard not
> supported, disabling
> EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> supported, disabling
> EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> supported, disabling
> EXT4-fs warning (device dm-3): ext4_issue_discard:2619: discard not
> supported, disabling
> EXT4-fs (sda1): re-mounted. Opts: discard,commit=3D0
> EXT4-fs (dm-3): re-mounted. Opts: discard,commit=3D0
> EXT4-fs (dm-2): re-mounted. Opts: discard,commit=3D0
>
> The mount command shows:
> /dev/mapper/System2-root_ssd on / type ext2
> (rw,noatime,errors=3Dremount-ro,barrier=3D1,stripe=3D32,data=3Dordere=
d,discard)
> and the corresponding entry from fstab:
> UUID=3D"635a1ad9-9ebb-4d1e-b8c3-30e11148bd92" =A0 =A0 / =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 ext4
> noatime,discard,errors=3Dremount-ro =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0=
 =A0 =A0 1
>
> My question is now, I don't have trim support now?
>
> Viele Gr=FCsse
> Jens Kasten

Jens,

I don't believe DM supports discard / trim passthru.  For
clarification, you should ask on the Device Mapper list.
<dm-devel@redhat.com>

Alternatively, you may find that the wiper.sh script packaged with
hdparm may work.  wiper.sh bypasses the DM layer and talks directly to
the drives, but it too has limitations.  The wiper.sh script is meant
to be called on a routine basis via cron, etc.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
