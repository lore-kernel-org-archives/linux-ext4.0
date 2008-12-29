From: <Shyam_Iyer@Dell.com>
Subject: RE: Re: jbd2 inside a device mapper module
Date: Mon, 29 Dec 2008 11:50:14 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com>
References: <20081224211038.GT4127@blitiri.com.ar><20081224234915.GA23723@mit.edu>
	<20081225143535.GA4127@blitiri.com.ar>
	<20081227200127.GX5000@webber.adilger.int>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0093007039=="
Cc: linux-ext4@vger.kernel.org, tytso@MIT.EDU, linux-kernel@vger.kernel.org
To: <dm-devel@redhat.com>, <albertito@blitiri.com.ar>, <Alex.Zhuravlev@sun.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20081227200127.GX5000@webber.adilger.int>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--===============0093007039==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9697D.834D0253"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9697D.834D0253
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Andreas Dilger wrote:
> On Dec 25, 2008  12:35 -0200, Alberto Bertogli wrote:
> > On Wed, Dec 24, 2008 at 06:49:15PM -0500, Theodore Tso wrote:
> > > I have no idea why you would need to do manual __breads().  No
doubt
> > > I'm missing some context here. =20
> >
> > I'm writing (just for fun and learning purposes) a device mapper
> > module that stores checksums on writes and verifies them on reads.
The
> > integrity metadata (currently just the checksum) is interleaved in
the
> > backing device: one sector holding the integrity metadata for the
> > following 64 data sectors.

> Alex and I discussed implementing checksums for ext4 using an external
device like this, and he might have some more design information for
you.


That external device could possibly be a TPM chip that can store
checksums.

Shyam Iyer
Dell Linux Engineering

------_=_NextPart_001_01C9697D.834D0253
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.3492" name=3DGENERATOR></HEAD>
<BODY><!-- Converted from text/plain format -->
<P><FONT size=3D2>Andreas Dilger wrote:<BR>&gt; On Dec 25, 2008&nbsp; =
12:35 -0200,=20
Alberto Bertogli wrote:<BR>&gt; &gt; On Wed, Dec 24, 2008 at 06:49:15PM =
-0500,=20
Theodore Tso wrote:<BR>&gt; &gt; &gt; I have no idea why you would need =
to do=20
manual __breads().&nbsp; No doubt<BR>&gt; &gt; &gt; I'm missing some =
context=20
here.&nbsp;&nbsp;<BR>&gt; &gt;<BR>&gt; &gt; I'm writing (just for fun =
and=20
learning purposes) a device mapper<BR>&gt; &gt; module that stores =
checksums on=20
writes and verifies them on reads. The<BR>&gt; &gt; integrity metadata=20
(currently just the checksum) is interleaved in the<BR>&gt; &gt; backing =
device:=20
one sector holding the integrity metadata for the<BR>&gt; &gt; following =
64 data=20
sectors.<BR><BR>&gt; Alex and I discussed implementing checksums for =
ext4 using=20
an external device like this, and he might have some more design =
information for=20
you.<BR><FONT size=3D2></FONT></FONT></P>
<P><FONT size=3D2><FONT size=3D2><FONT face=3DArial color=3D#0000ff>That =
external device=20
could possibly be a TPM chip that can store=20
checksums.</FONT></FONT></FONT></P><FONT size=3D2><FONT size=3D2>
<DIV align=3Dleft><STRONG><FONT face=3DArial size=3D2>Shyam =
Iyer</FONT></STRONG></DIV>
<DIV align=3Dleft><FONT face=3DArial color=3D#0000ff size=3D2>Dell Linux =

Engineering</FONT></DIV></FONT></FONT></BODY></HTML>

------_=_NextPart_001_01C9697D.834D0253--


--===============0093007039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0093007039==--
