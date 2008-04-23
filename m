From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
 for FLEX_BG
Date: Wed, 23 Apr 2008 11:24:36 -0500
Message-ID: <20080423112436.4cc42bc5@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
	<1208868379-17580-3-git-send-email-tytso@mit.edu>
	<20080422091847.50708436@gara>
	<20080422145125.GB12836@mit.edu>
	<20080422103212.1c974bd9@gara>
	<20080422185728.GC20668@mit.edu>
	<20080422172751.22d5aef9@gara>
	<20080423012149.GF20668@mit.edu>
	<20080423004843.72f65d2b@gara>
	<20080423122349.GB7003@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38174 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYDWQYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 12:24:49 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NGMCCE002243
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 12:22:12 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NGOgdA210792
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 10:24:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NGOgLx026451
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 10:24:42 -0600
In-Reply-To: <20080423122349.GB7003@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Apr 2008 08:23:49 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Apr 23, 2008 at 12:48:43AM -0500, Jose R. Santos wrote:
> >=20
> > Well, these Green Power drives from Western Digital dont have const=
ant
> > spindle speed and I believe that they run at 7200 rpm under load an=
d
> > 5400 when mostly idle.  Makes sense why the seek times would be the
> > same.  On the other hand, the VelociRaptor drives with 10k rpm have=
 a
> > latency of 5.5ms.
>=20
> Actually, no, check out some of the web pages, especially:
>=20
> 	  http://www.silentpcreview.com/article786-page1.html
>=20
> 	"Western Digital has caught a lot of flak for withholding the
> 	rotation speed of the Green Power, especially when the product
> 	was first launched and the marketing material listed the
> 	rotation speed as 5,400-7,200 RPM. This led some to speculate
> 	that the rotation speed changed dynamically during use =E2=80=94 whi=
ch
> 	would have been an impressive engineering feat had it been
> 	true. The reality is revealed by a sentence that Western
> 	Digital added to the description of IntelliPower: "For each
> 	GreenPower=E2=84=A2 drive model, WD may use a different, invariable
> 	RPM." In other words, Western Digital reserves the right to
> 	release both 5,400 RPM and 7,200 RPM drives under the Green
> 	Power name =E2=80=94 without telling you which are which."
>=20
> In fact, all of the Western Digital Green Power disks released to dat=
e
> are all using 5400rpm, based on people who have put a microphone to
> the disk drive and then done a frequency analysis.  The "Intellipower=
"
> nonsense is just marketing fluff so that people don't think the drive
> is going to be vastly slower just because the platter turns more
> slowly.  I'm pretty sure that's because there are other tradeoffs mad=
e
> in laptop drives for powersavings, more than just the spindle speed,
> but for whatever reason people associate 5400rpm drives with SLOW.  :=
-)

The biggest power savings tradeoff in laptop drives IS rpm speed. :)

All the test I've seen about the WD GP 1TB drives seem to point out tha=
t
the performance is very disappointing.  So the "5400rpm drives are SLOW=
"
seems to be a correct assessment.  The same test that compares it to a
WD Raptor drive at 10K rpm show the that a drive with 5 time less
capacity but with higher rpms can run circles around a large capacity
hard drives with slower rpm.

This goes to my original point of testing FLEX_BG on laptop hard drive
with slower RPM speeds since the response time on random access
workloads is higher than desktop counterparts.  Higher platter density
seems to help them very little here. =20

>=20
> > Looking at the specs of Seagate Savvio and Cheetah family of drives=
, a
> > 33% increase in spindle speed from 10k to 15K rpms give out around =
25%
> > improvement in average seek latency.  Also note that benchmark
> > publishes that are sensitive to IO latencies tend to use smaller 15=
k
> > rpm disk than their larger but slower counter parts.  RPM speeds
> > usually beats density when it comes to seek time improvements.
>=20
> Yeah, but that's not a fair comparison, because you're comparing
> different generations of disk drives, as well as the fact that Savvio
> are enterprise disks which costs much more than the Cheetah drives.
>=20
> A much better comparison would be the Seagate Cheetah 15k.5 and the
> Seagate Cheetah NS.  To quote from the Seagate Cheetah NS description=
,
> "The Seagate Cheetah NS shares the Cheetah 15K.5 design, optimized fo=
r
> storage capacity and power consumption but maintaining better
> performance than standard 10K enterprise products."  So the Cheetah N=
S
> is based off of the same technology and design as the 15k.5 design,
> but the spindle speed has been slowed to 10k to save power.  And what
> do you see there?
>=20
> Model			RPM	Seek times (read/write, in ms)
>=20
> Seagate Cheetah NS	10k	3.9/4.2
> Seegate Cheetah 15k.5	15k	3.5/4.0
>=20
> That's only a 10% improvement going from 10k to 15k, when speed has
> gone up by a factor of 50%.  (And that's for average read seek times;
> for writing, it's only a 5% improvement.)  It also shows that it is
> certainly possible to create a 10k rpm hard drive with a 4ms seek
> time.

But the NS also has larger per platter capacity which attributes to the
4ms.  The 15k drive also has about a 30% better average latency than
the NS which still support my previous statement that higher RPM
_usually_ beats density when it comes to seek time improvements.

> 						- Ted



-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
