From: Valdis.Kletnieks@vt.edu
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 05 Dec 2010 21:37:25 -0500
Message-ID: <206035.1291603045@localhost>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com> <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com> <20101205100954.GA6564@fritha.org> <4CFB679D.5030900@redhat.com>
            <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291603044_67929P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: device-mapper development <dm-devel@redhat.com>,
	Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Matt <jackdachef@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Sun, 05 Dec 2010 08:24:32 EST."
             <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--==_Exmh_1291603044_67929P
Content-Type: text/plain; charset=us-ascii

On Sun, 05 Dec 2010 08:24:32 EST, Theodore Tso said:

> I've been using a kernel which is between 2.6.37-rc2 and -rc3 with a LUKS /
> dm-crypt / LVM / ext4 setup for my primary file systems, and I haven't observed
> any corruption for the last two weeks or so.

Pretty much exactly the same setup here (LUKS/dm-crypt/LVM/ext4), pretty
consistently running most-recent mmotm kernel, which tends to be somewhat ahead
of linux-next, and I haven't seen anything either. (I admit I haven't tried
-rc4-mmotm1202 yet).

> As another thought, what version of GCC 

rpm -q says 'gcc-4.5.1-5.fc15.x86_64'.  

--==_Exmh_1291603044_67929P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM/ExkcC3lWbTT17ARAqOlAJ0Z49Sd/WnIe419LFzFShCJb+zIjQCg2Dmy
Ot+wazgEszexzIvWmrvcvR4=
=1D7I
-----END PGP SIGNATURE-----

--==_Exmh_1291603044_67929P--
