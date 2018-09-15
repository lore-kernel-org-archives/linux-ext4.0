From: =?UTF-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>
Subject: Re: metadata operation reordering regards to crash
Date: Sat, 15 Sep 2018 14:58:07 +0800
Message-ID: <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
 <20180914222336.GD16550@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
To: david@fromorbit.com, cmumford@cmumford.com,
        linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914222336.GD16550@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 15, 2018 at 6:23 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Sep 14, 2018 at 05:06:44PM +0800, =E7=84=A6=E6=99=93=E5=86=AC wro=
te:
> > Hi, all,
> >
> > A probably bit of complex question:
> > Does nowadays practical filesystems, eg., extX, btfs, preserve metadata
> > operation order through a crash/power failure?
>
> Yes.
>
> Behaviour is filesystem dependent, but we have tests in fstests that
> specifically exercise order preservation across filesystem failures.
>
> > What I know is modern filesystems ensure metadata consistency
> > after crash/power failure. Journal filesystems like extX do that by
> > write-ahead logging of metadata operations into transactions. Other
> > filesystems do that in various ways as btfs do that by COW.
> >
> > What I'm not so far clear is whether these filesystems preserve
> > metadata operation order after a crash.
> >
> > For example,
> > op 1.  rename(A, B)
> > op 2.  rename(C, D)
> >
> > As mentioned above,  metadata consistency is ensured after a crash.
> > Thus, B is either the original B(or not exists) or has been replaced by=
 A.
> > The same to D.
> >
> > Is it possible that, after a crash, D has been replaced by C but B is s=
till
> > the original file(or not exists)?
>
> Not for XFS, ext4, btrfs or f2fs. Other filesystems might be
> different.

Thanks, Dave,

I found this archive:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31937.html

It seems btrfs people thinks reordering could happen.

It is a relatively old reply. Has the implement changed? Or is there
some new standard that requires reordering not happen?

> Cheers,
>
> Dave,
> --
> Dave Chinner
> david@fromorbit.com
