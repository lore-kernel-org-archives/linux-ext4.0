From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
	for FLEX_BG
Date: Wed, 23 Apr 2008 08:23:49 -0400
Message-ID: <20080423122349.GB7003@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu> <1208868379-17580-2-git-send-email-tytso@mit.edu> <1208868379-17580-3-git-send-email-tytso@mit.edu> <20080422091847.50708436@gara> <20080422145125.GB12836@mit.edu> <20080422103212.1c974bd9@gara> <20080422185728.GC20668@mit.edu> <20080422172751.22d5aef9@gara> <20080423012149.GF20668@mit.edu> <20080423004843.72f65d2b@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54420 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752063AbYDWMYc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 08:24:32 -0400
Content-Disposition: inline
In-Reply-To: <20080423004843.72f65d2b@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 23, 2008 at 12:48:43AM -0500, Jose R. Santos wrote:
>=20
> Well, these Green Power drives from Western Digital dont have constan=
t
> spindle speed and I believe that they run at 7200 rpm under load and
> 5400 when mostly idle.  Makes sense why the seek times would be the
> same.  On the other hand, the VelociRaptor drives with 10k rpm have a
> latency of 5.5ms.

Actually, no, check out some of the web pages, especially:

	  http://www.silentpcreview.com/article786-page1.html

	"Western Digital has caught a lot of flak for withholding the
	rotation speed of the Green Power, especially when the product
	was first launched and the marketing material listed the
	rotation speed as 5,400-7,200 RPM. This led some to speculate
	that the rotation speed changed dynamically during use =E2=80=94 which
	would have been an impressive engineering feat had it been
	true. The reality is revealed by a sentence that Western
	Digital added to the description of IntelliPower: "For each
	GreenPower=E2=84=A2 drive model, WD may use a different, invariable
	RPM." In other words, Western Digital reserves the right to
	release both 5,400 RPM and 7,200 RPM drives under the Green
	Power name =E2=80=94 without telling you which are which."

In fact, all of the Western Digital Green Power disks released to date
are all using 5400rpm, based on people who have put a microphone to
the disk drive and then done a frequency analysis.  The "Intellipower"
nonsense is just marketing fluff so that people don't think the drive
is going to be vastly slower just because the platter turns more
slowly.  I'm pretty sure that's because there are other tradeoffs made
in laptop drives for powersavings, more than just the spindle speed,
but for whatever reason people associate 5400rpm drives with SLOW.  :-)

> Looking at the specs of Seagate Savvio and Cheetah family of drives, =
a
> 33% increase in spindle speed from 10k to 15K rpms give out around 25=
%
> improvement in average seek latency.  Also note that benchmark
> publishes that are sensitive to IO latencies tend to use smaller 15k
> rpm disk than their larger but slower counter parts.  RPM speeds
> usually beats density when it comes to seek time improvements.

Yeah, but that's not a fair comparison, because you're comparing
different generations of disk drives, as well as the fact that Savvio
are enterprise disks which costs much more than the Cheetah drives.

A much better comparison would be the Seagate Cheetah 15k.5 and the
Seagate Cheetah NS.  To quote from the Seagate Cheetah NS description,
"The Seagate Cheetah NS shares the Cheetah 15K.5 design, optimized for
storage capacity and power consumption but maintaining better
performance than standard 10K enterprise products."  So the Cheetah NS
is based off of the same technology and design as the 15k.5 design,
but the spindle speed has been slowed to 10k to save power.  And what
do you see there?

Model			RPM	Seek times (read/write, in ms)

Seagate Cheetah NS	10k	3.9/4.2
Seegate Cheetah 15k.5	15k	3.5/4.0

That's only a 10% improvement going from 10k to 15k, when speed has
gone up by a factor of 50%.  (And that's for average read seek times;
for writing, it's only a 5% improvement.)  It also shows that it is
certainly possible to create a 10k rpm hard drive with a 4ms seek
time.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
