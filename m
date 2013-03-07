From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Dev branch regressions
Date: Thu, 7 Mar 2013 19:54:58 +0800
Message-ID: <20130307115458.GA2800@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <20130306225818.GA13277@thunk.org>
 <alpine.LFD.2.00.1303070746040.24359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33647 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab3CGLjs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 06:39:48 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so412937pab.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2013 03:39:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303070746040.24359@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 07:47:31AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 6 Mar 2013, Theodore Ts'o wrote:
>=20
> > Date: Wed, 6 Mar 2013 17:58:18 -0500
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Zheng Liu <gnehzuil.liu@gmail.com>
> > Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
> >     Dmitry Monakhov <dmonakhov@openvz.org>
> > Subject: Dev branch regressions
> >=20
> > On Wed, Mar 06, 2013 at 10:17:10PM +0800, Zheng Liu wrote:
> > >=20
> > > *Big Note*
> > > When I am testing this patch series, I found some regressions in =
dev branch.
> > > Here is a note.  These regressions could be hitted by running tes=
t case
> > > serveral times.  So If we just run xfstests one time, they could =
be missed.
> > >=20
> > >  - xfstests #74 with data=3Djournal
> > >=20
> > >  - xfstests #247 with data=3Djournal
> > > Some warning messages are printed by ext4_releasepage.  We hit
> > > WARN_ON(PageChecked(page)) in this function.  But the test case i=
tself can
> > > pass.
> > >=20
> > >  - xfstests #269 with dioread_nolock
> > > The system will hang
> >=20
> > I'm going to guess that you were running this using your SSD test
> > setup?  I just ran:
> >=20
> > kvm-xfstests -c data_journal 74,74,74,74,74,247,247,247,247,247
> >=20
> > using my standard hdd setup, and didn't see any failures or warning=
s.
> >=20
> > How frequently are you seeing these failures?  When I have a chance
> > I'll try running these tests with a tmpfs image and see if I have a=
ny
> > better luck reproducing the problem there.
> >=20
> > I did manage to get a hang (preceded with a soft lockup for the
> > dioread_nolock with test 269).
> >=20
> > >  - xfstests #83 with bigalloc
> > > Some threads could be blocked for 120s.
> >=20
> > I've seen this test blocked for hours (but without managing to trig=
ger
> > the 120s soft lockup warning), but I'm not entirely sure this was a
> > regression.  I believe I've seen a similar hang with 3.8.0-rc3 if I
> > recall correctly.  I had been hoping the changes with the extent
> > status tree would fix it, but apparently no such luck.  :-(
>=20
> You're right this is not a regression the problem has always been
> there, however now with some bigalloc fixes it becomes more obvious.
> I have some patches to address this issue, though it's not ready
> yet.

Hi Ted, Lukas,

I take a close look at these problems, and I can confirm that they are
not regression because in 3.8 kernel they have been there.  Honestly
they are hard to be hitted because I need to run several times to
trigger them.  IMHO most users don't use this features (data=3Djournal,
bigalloc, dioread_nolock).  So let us fix them one by one.  I will file
these bugs in mailing list to let folks know.

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
