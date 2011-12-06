From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 6 Dec 2011 14:31:37 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112061412310.1949@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com> <alpine.LSU.2.00.1112060030220.1615@sister.anvils> <CAGBYx2YA3B5-nLxwdHavmd=794ycrpqnMbvM=VabrdPL2FQ0sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-813777252-1323210711=:1949"
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ted Ts'o <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1LFWcM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 17:32:12 -0500
Received: by iakc1 with SMTP id c1so4318784iak.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 14:32:11 -0800 (PST)
In-Reply-To: <CAGBYx2YA3B5-nLxwdHavmd=794ycrpqnMbvM=VabrdPL2FQ0sw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-813777252-1323210711=:1949
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 6 Dec 2011, Yongqiang Yang wrote:
> On Tue, Dec 6, 2011 at 4:55 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I've now tried the fsx test on three machines, with both 1/2 and 2/2
> > applied to 3.2-rc4. =A0On one machine, with ext2 on loop on tmpfs, the
> > fsx test failed in a couple of minutes with those patches; on another
> > machine, with ext2 on loop on tmpfs, it failed after about 40 minutes
> > with =A0the patches; on this laptop, with ext2 on SSD, it's just now
> > failed after 35 minutes with the patches.

> ext2?  So files are indirect mapped?  If so, the failure should has
> nothing to do with punching hole, I remember that punch hole is not
> supported for indirect mapped files.

Yes, I am not trying to test hole punching: just trying to do my own
testing under traditional loads, and hitting problems in changes which
have gone into extN to fix up hole punching.

Some of the time I've been using an old fsx which doesn't even know
about fallocate(), some of the time a recent fsx from xfstests.  Most
of the time I've been using ext2, but occasionally I try it on ext4.

I think the only thing which makes the problems go away is blocksize
same as pagesize; but it's a long time since I tried nomblk_io_submit,
that made a big difference around 2.6.38/39, perhaps it still does.

>=20
> Do you mean fsx failure or the bug you reported earlier due to
> referencing a unlocked page?

In first quoted paragraph above, fsx failure.

Hugh
--8323584-813777252-1323210711=:1949--
