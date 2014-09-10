From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: tune2fs -O ^metadata_csum not checking bitmap failures
Date: Wed, 10 Sep 2014 14:16:36 -0700
Message-ID: <20140910211636.GI10351@birch.djwong.org>
References: <BAY179-W1203B52FCFC4FE2CA267BDFDCF0@phx.gbl>
 <20140910204840.GH10351@birch.djwong.org>
 <BAY179-W439AA99AF43810A0FC1C49FDCF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaIJVQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 17:16:43 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W439AA99AF43810A0FC1C49FDCF0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2014 at 05:10:21PM -0400, TR Reardon wrote:
> > Date: Wed, 10 Sep 2014 13:48:40 -0700
> > From: darrick.wong@oracle.com
> > To: thomas_reardon@hotmail.com
> > CC: linux-ext4@vger.kernel.org
> > Subject: Re: tune2fs -O ^metadata_csum not checking bitmap failures
> >
> > On Wed, Sep 10, 2014 at 04:30:41PM -0400, TR Reardon wrote:
> >> When running tune2fs -O ^metadata_csum, disable_uninit_bg() is cal=
led to
> >> reset the gdt. However, return value is not checked, which allows =
a failure
> >> (say, a block bitmap failure somewhere, among other errors) to con=
tinue
> >> through to rewrite_metadata_checksums()
> >>
> >> This seems wrong; should not the rewrite occur only if
> >> disable/enable_uninit_bg() succeeds?
> >
> > The rewrite will fail if either of the error cases in disable_unini=
t_bg() fail,
> > since rewrite_metadata_checksums() also tries to load the bitmap an=
d scan the
> > inodes.
>=20
> Actually, rewrite_metadata_checksums() loads the bitmap with checksum=
s OFF,
> which in the test I just ran, will succeed. =A0This leaves the fs in =
a weird
> half-checksummed state.

Icky. :(

> I should have been clearer above: if the initial disable_uninit_bg() =
failure
> occurs because of a *checksum error*, then we get into this confused =
state.
> =A0Given that people would possibly try to disable metadata_csum if t=
here are
> checksum errors, this seems like a fairly common scenario.

I would say that if you have checksum errors you ought to run e2fsck, n=
ot just
tape over the warning light...

=2E..though if you're prepared to deal with the fallout/really know wha=
t you're
doing, you can nuke the feature bit with 'feature ^metadata_csum' in de=
bugfs.

In any case, we ought to avoid tune2fs writing junk to a broken fs.

--D
>=20
>=20
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
