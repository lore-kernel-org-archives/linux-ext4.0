From: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
Subject: AW: AW: AW: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 19:56:45 +0100
Message-ID: <B8A948099C53E0408BDBCE749AAECA9A2A80C78553@SI-MBX10.de.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com>
 <52C6F28A.6060706@redhat.com>
 <B8A948099C53E0408BDBCE749AAECA9A2A80C78551@SI-MBX10.de.bosch.com>
 <52C70610.4010907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:54919 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaACS4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 13:56:54 -0500
In-Reply-To: <52C70610.4010907@redhat.com>
Content-Language: de-DE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 03, 2014 at 19:49, Eric Sandeen wrote
>=20
> On 1/3/14, 12:45 PM, Juergens Dirk (CM-AI/ECO2) wrote:
> >
> > On Thu, Jan 03, 2014 at 19:24, Eric Sandeen wrote
> >>
> >> On 1/3/14, 10:29 AM, Juergens Dirk (CM-AI/ECO2) wrote:
> >>> So, I think there _might_ be a kernel bug, but it could be also a
> >> problem
> >>> related to the particular type of eMMC. We did not observe the sa=
me
> >> issue
> >>> in previous tests with another type of eMMC from another supplier=
,
> >> but this
> >>> was with an older kernel patch level and with another HW design.
> >>>
> >>> Regarding a possible kernel bug: Is there any chance that the
> invalid
> >>> ee_len or ee_start are returned by, e.g., the block allocator ?
> >>> If so, can we try to instrument the code to get suitable traces ?
> >>> Just to see or to exclude that the corrupted inode is really
> written
> >>> to the eMMC ?
> >>
> >> From your description it does sound possible that it's a kernel bu=
g.
> >> Adding testcases to the code to catch it before it hits the journa=
l
> >> might be helpful - but then maybe this is something getting
> overwritten
> >> after the fact - hard to say.
> >>
> >> Can you share more details of the test you are running?  Or maybe
> even
> >> the test itself?
> >
> > Yes, for sure, we can. Weller, please provide additional details
> > or corrections.
> >
> > In short:
> > Basically we use an automated cyclic test writing many small
> > (some kBytes) files with CRC checksums for easy consistency check
> > into a separate test partition. Files also contain meta information
> > like filename,  sequence number and a random number to allow to
> identify
> > from block device image dumps, if we just see a fragment of an old
> > deleted file or a still valid one.
> >
> > Each test loop looks like this:
>=20
> 0) mkfs the filesystem - with what options?  How big?

Here we do need the details from Weller, cause=20
he has done all this.=20

>=20
> > 1) Boot the device after power on or reset
> > 2) Do fsck -n BEFORE mounting
> > 2 a) (optional) binary dump of the journal
> > 3) Mount test partition
>=20
> Again with what options, if any?

Details again have to be given by Weller, sorry.

>=20
> > 4) File content check for all files from prev. loop
> > 5) erase all files from previous loop
> > 6) start writing hundreds/thousands of test files
> >     in multiple directories with several threads
>=20
> I guess this is where we might need more details in order,
> to try to recreate the failure, but perhaps
> this is not a case where you can simply share the IO
> generation utility...?

I think we can share the code, please let me check on Monday.

>=20
> Thanks,
> -Eric
>=20
> > 7) after random time cut the power or do soft reset
> >
> > If 2), 3), 4) or 5) fails, stop test.
> >
> > We are running the test usually with kind of transaction
> > safe handling, i.e. use fsync/rename, to avoid zero length files
> > or file fragments.
> >
> >>
> >> I've used a test framework in the past to simulate resets w/o
> needing
> >> to reset the box, and do many journal replays very quickly.  It'd =
be
> >> interesting to run it using your testcase.
> >>
> >> Thanks,
> >> -Eric
> >
> > Mit freundlichen Gr=FC=DFen / Best regards
> >
> > Dirk Juergens
> >
> > Robert Bosch Car Multimedia GmbH
> >


Mit freundlichen Gr=FC=DFen / Best regards

Dirk Juergens

Robert Bosch Car Multimedia GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
