From: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
Subject: AW: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 19:21:32 +0100
Message-ID: <B8A948099C53E0408BDBCE749AAECA9A2A80C7854F@SI-MBX10.de.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
 <20140103154846.GB31411@thunk.org> <52C6F22A.4040202@redhat.com>
 <20140103175111.GA4336@thunk.org> <52C6F944.4030605@redhat.com>
 <20140103180654.GC4336@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:54412 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaACSVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 13:21:40 -0500
In-Reply-To: <20140103180654.GC4336@thunk.org>
Content-Language: de-DE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, Jan 03, 2014 at 19:07, Theodore Ts'o [mailto:tytso@mit.edu]
wrote:
>=20
> On Fri, Jan 03, 2014 at 11:54:12AM -0600, Eric Sandeen wrote:
> > >
> > > This call chain only happens if the block device is mounted.
> >
> > Sure, but I thought that's what they were doing.  Maybe I misread.
> >
>=20
> I thought this was in relation to doing what they called a "barrier
> test", where you are writing to flash device and then drop power, and
> then see if the CACHE FLUSH request was actually honored.  (And
> whether or not the FTL got corrupted so badly that the device brick's
> itself, as does happen for some of the crappier cheap flash out
> there.)
>=20
> But I'm not sure precisely how they implemented their test.  It's
> possible it was done with the file system mounted.  My suggestion was
> to make sure that the flash was proof against power drops by doing
> this using a raw block device, to remove the variable of the file
> system.
>=20

Just as a quick reply for today:
If I remember right, Weller has done the barrier test w/o file system
mounted. Weller can give more details when he is back in office.
However, these tests were done some while ago with another type of
eMMC. =20

> Given that they've since reported that they can repro the problem
> using soft resets, it doesn't sound like the problem is related to
> flash devices not handling powe drops correctly=20

I think so as well, for the same reason and also because our tests with
journal_checksum show the same problem w/o any checksum error.

> --- although given
> that I'm still getting reports of people who have had their SD card
> get completely bricked after a power drop event, it's unfortunately
> not a solved problem by the flash manufacturers yet....  or rather,
> the few (many?) bad apples give all low-end flash a bad name.
>
>
       	     	     	    	  			 - Ted

Mit freundlichen Gr=FC=DFen / Best regards

Dirk Juergens

Robert Bosch Car Multimedia GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
