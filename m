From: Werner Fischer <devlists@wefi.net>
Subject: Re: -E stride and stripe-width necessary for best performace of
 SSDs?
Date: Fri, 01 Jul 2011 19:40:15 +0200
Message-ID: <1309542015.5364.24.camel@werner-t410>
References: <1309512654.5729.15.camel@werner-t410>
	 <BANLkTinMoDXYn6x7aWzmvbVj3pqN7Rwn9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:34457 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1GARkT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jul 2011 13:40:19 -0400
In-Reply-To: <BANLkTinMoDXYn6x7aWzmvbVj3pqN7Rwn9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Greg,

thanks for your feedback,
On Fri, 2011-07-01 at 12:03 -0400, Greg Freemyer wrote:
> On Fri, Jul 1, 2011 at 5:30 AM, Werner Fischer <devlists@wefi.net> wr=
ote:
> > * I want to optimize ext4 on my SSD (Intel 320 Series 160 GB).
> > * There are some sites recommending the use of the -E stride and -E
> >  stripe-width paramaters, like
> >  http://searchenterpriselinux.techtarget.com/tip/Optimizing-Linux-f=
or-SSD-usage
> > * I know these parameters are useful for RAIDs, but I don't think t=
hat
> >  they have any advantages for SSDs.
> >
> > Can anybody with deeper ext4 knowledge confirm if I'm right?
> That article is highly simplistic, and I dare say inaccurate due to
> the simplifications.
>=20
> For most of us SSDs are magic boxes we push data into and pull data o=
ut of.
>=20
> We know the data gets stored on NAND chips and that many (most?) NAND
> chips have 128KB Erase Blocks.
Meanwhile Block sizes have increased up to 2 MiB: 256 pages =C3=A1 8 Ki=
B for
current 25nm NAND from Intel/Micron (which is used also in my SSD)
http://www.anandtech.com/show/2928

> But we have no knowledge of how the data itself is organized.
> Assuming that a Erase Block contains contiguous sectors is wrong in
> most cases.
I agree, AFAIK this was only true for the very first SSDs on the market=
=2E

> There is sophisticated logic going on that is re-mapping
> the data.  Those algorithms are NOT public. We definitely don't know
> enough to know what stride etc. is optimal.
>
> I personally think using 1MB for partition boundaries=20
I agree

> and a stride
> which is a multiple of 4KB is probably best, but there really is no
> good way to know other than performance testing the specific make /
> model / firmware release you are working with.
=46or the 25nm NAND from Intel/Micron we know its page size =3D 8 KiB.=20
=46or an Ext4 file system with block size 4 KiB (4096 Byte) I could
imagine that using
  stride=3D2        (2 file system blocks =3D 8 KiB) and
  stripe-width=3D2  (also 2 file system blocks =3D 8 KiB)
would make sense? (just taking the page size into account)

> Here's two wiki pages I wrote that may give you some background:
> http://en.opensuse.org/SDB:SSD_Idle_Time_Garbage_Collection_support
> http://en.opensuse.org/SDB:SSD_discard_%28trim%29_support
> You might want to read them both, then read them both again because
> the topics depend on each other.
Thank a lot, I already came across them - they've been valuable to me!

Werner
> And I just noticed this one:
> http://en.opensuse.org/SDB:SSD_performance
> I have no idea how accurate the last article is.  (I have not read/re=
viewed it.)
>=20
> Greg


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
