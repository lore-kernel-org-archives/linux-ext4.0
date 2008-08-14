From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Thu, 14 Aug 2008 14:49:32 -0700
Message-ID: <1218750572.6362.3.camel@mingming-laptop>
References: <E1KSEkA-00009o-CV@closure.thunk.org>
	 <20080811143911.GA6455@skywalker> <20080811181524.GA9769@skywalker>
	 <20080813023205.GA8232@mit.edu>  <20080813105222.GG6439@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52864 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYHNVtf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 17:49:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7ELnYRK020534
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 17:49:34 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7ELnYfc107822
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 15:49:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7ELnXSh015684
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 15:49:33 -0600
In-Reply-To: <20080813105222.GG6439@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-13=E4=B8=89=E7=9A=84 16:22 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, Aug 12, 2008 at 10:32:05PM -0400, Theodore Tso wrote:
> > On Mon, Aug 11, 2008 at 11:45:24PM +0530, Aneesh Kumar K.V wrote:
> > > On Mon, Aug 11, 2008 at 08:09:12PM +0530, Aneesh Kumar K.V wrote:
> > > > Can you try this patch ? The patch make group preallocation use=
 the goal
> > > > block.
> > > >=20
> > >=20
> > > Results with and without patch.
> > >=20
> > > http://www.radian.org/~kvaneesh/ext4/lg-fragmentation/
> > >=20
> >=20
> > My results match yours; seems to be a bit better, but it's not fixi=
ng
> > the fundamental problem.  With the patch:
> >=20
> >  26524: expecting 638190 actual extent phys 631960 log 1 len 1
> >  26527: expecting 638191 actual extent phys 631963 log 1 len 1
> >  26533: expecting 638192 actual extent phys 631976 log 1 len 5
> >  26534: expecting 638193 actual extent phys 631981 log 1 len 2
> >  26536: expecting 638194 actual extent phys 631984 log 1 len 6
> >  26538: expecting 638195 actual extent phys 631991 log 1 len 5
> >  26540: expecting 638196 actual extent phys 631997 log 1 len 2
> >  26545: expecting 638197 actual extent phys 632009 log 1 len 1
> >  26546: expecting 638198 actual extent phys 632010 log 1 len 6
> >  26604: expecting 638199 actual extent phys 632156 log 1 len 1
> >=20
> > Useing debugfs's stat command to look at the blocks:
> >=20
> > 26524: (0):638189, (1):631960
> > 26527: (0):638190, (1):631963
> > 26533: (0):638191, (1-5):631976-631980
> > 26534: (0):638192, (1-2):631981-631982
> > 26536: (0):638193, (1-6):631984-631989
> > 26538: (0):638194, (1-5):631991-631995
> > 26540: (0):638195, (1-2):631997-631998
> > 26545: (0):638196, (1):632009
> > 26546: (0):638197, (1-6):632010-632015
>=20
> I am not sure why we are getting single block request for inodes
> 26524 etc. With delayed alloc we should have got 2 block request.
>=20
> >=20
> > Out of curiosity, I also probed the inode numbers that were out of
> > sequence from above.  They seem to be mostly allocating out of the
> > numbers used for the second extent, above. =20
> >=20
> > 26526: (0):631961
> > 26526: (0):631962
> > 26528: (0):631964
> > 26529: (0):411742
> > 26530: (0):631965
> > 26531: (0-1):631966-631967
> > 26532: (0-7):631968-631975
> > 26535: (0):631983
> > 26537: (0):631990
> > 26541: (0-7):631999-632006
> > 26542: (0):632007
> > 26543: (0):632008
> > 26544: (0):411743
> > 26547: (0):632016
> >=20
> > Inode  Pathname
> > 26524  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.py
> > 26525  /lib/rhythmbox/plugins/lyrics/LyrcParser.py
> > 26526  /lib/rhythmbox/plugins/lyrics/LyricsParse.py
> > 26527  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.pyc
> > 26528  /lib/rhythmbox/plugins/lyrics/WinampcnParser.py
> > 26529  /lib/rhythmbox/plugins/magnatune
> > 26530  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_small.=
png
> > 26531  /lib/rhythmbox/plugins/magnatune/magnatune.rb-plugin
> > 26532  /lib/rhythmbox/plugins/magnatune/magnatune-prefs.glade
> > 26533  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.pyc
> > 26534  /lib/rhythmbox/plugins/magnatune/__init__.py
> > 26535  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.py
> > 26536  /lib/rhythmbox/plugins/magnatune/magnatune-purchase.glade
> > 26537  /lib/rhythmbox/plugins/magnatune/TrackListHandler.py
> > 26538  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.py
> > 26539  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_tiny.p=
ng
> > 26540  /lib/rhythmbox/plugins/magnatune/__init__.pyc
> > 26541  /lib/rhythmbox/plugins/magnatune/magnatune-loading.glade
> > 26542  /lib/rhythmbox/plugins/magnatune/TrackListHandler.pyc
> > 26543  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.pyc
> > 26544  /lib/rhythmbox/plugins/audioscrobbler
> > 26546  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-prefs.g=
lade
> > 26547  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-ui.xml
> >=20
> > Looks like we still have some problems with the block allocator...
>=20
> The problem is with delalloc and mballoc locality group. With delallo=
c
> we use pdflush to write the pages. Small file allocation use a per-cp=
u
> prealloc space. In my understanding using Per-CPU prealloc space is
> fine without delalloc. Because without delalloc get_block happens in =
the
> process context at write_begin and OS scheduler will not schedule the
> task to other CPU unless needed.
>=20
> With delalloc we have pdflush doing block allocation and using per-cp=
u
> may not really help here.=20

I wonder if it still make sense for using per~cpu group locality
allocation with delalloc, with the fact that all block allocation is
done via pdflush?=20

> So i tried a small patch as below. But that
> didn't help much. Also the patch would increase contention on the
> locality group mutex. So i guess the change is not worth.=20
>=20
> But with delalloc we should have got multiple block request together.
> That implies we should get a single get_block request for the whole
> file. I will have to instrument the kernel to understand why it is no=
t
> happening.
>=20

I am courious to know this too. Why we get single block allocation
request for delalloc?


Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
