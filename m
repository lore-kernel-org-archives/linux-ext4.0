From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: bug#8411: due to missing sync even on 2.6.39,	cp fails to copy
 an odd file
Date: Sat, 02 Apr 2011 14:29:16 +0100
Message-ID: <4D9724AC.2070009@draigBrady.com>
References: <87fwq0gay0.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: 8411@debbugs.gnu.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:2223 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753372Ab1DBN37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 09:29:59 -0400
In-Reply-To: <87fwq0gay0.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/04/11 12:16, Jim Meyering wrote:
> Hi P=E1draig,
>=20
> As of this change,
>=20
>     copy: with fiemap copy, only sync when needed
>     http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=3Df6987=
6e55
>=20
> fiemap copy with extents beyond EOF can fail on ext4 even with
> Fedora 15 (2.6.38) and rawhide's 2.6.39 kernel.
>=20
> Here we construct an odd file.  First, preallocate 10MB of space,
> and then write 5KiB of random data into the beginning of that:
>=20
>     $ fallocate -l 10000000 -n k
>     $ dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullbloc=
k of=3Dk
>=20
> However, when we try to copy "k", we get a file, "k2" of the
> expected size, but with only NUL bytes for contents:

So the extent info is not updated until sync(),
which means cp will consider the "unwritten" extent
as NUL data and not bother to read it :(

I guess this is a corner case that was missed
in the fixups for ext4 (and btrfs?) in 2.6.38 for this?
I've copied ext4 devs for clarification.
I.E. if you do this:

  fallocate -l 10000000 -n k
  dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=3D=
k
  filefrag -v k

Do you get all extents still unwritten.
I do on my 2.6.35.11-83.fc14.i686 kernel, but I expected that.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
