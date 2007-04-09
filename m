From: Valdis.Kletnieks@vt.edu
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 09 Apr 2007 09:42:19 -0400
Message-ID: <7641.1176126139@turing-police.cc.vt.edu>
References: <20070409000556.GA13980@implementation>
            <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176126139_28267P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932929AbXDINm2@vger.kernel.org>
In-Reply-To: Your message of "Sun, 08 Apr 2007 22:24:50 CDT."
             <4619B202.3050601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--==_Exmh_1176126139_28267P
Content-Type: text/plain; charset=us-ascii

On Sun, 08 Apr 2007 22:24:50 CDT, Eric Sandeen said:
> Can you elaborate?  Under what circumstances is log replay going to harm 
> data?  Do you mean that the installer mounts partitions, looking for 
> what OS is installed?  How is that harmful?

Another usage case that really wants to avoid the log replay is if you're
looking at an unknown disk image with a forensics CD such as Helix:

http://www.e-fense.com/helix/

Yes, good forensics always clones the disk image twice (the first clone being
used for nothing but creating second-gen clones for analysis), and in most
cases the forensic analyst can work around the fact that you *do* cause some
changes to the disk image by mounting.  But sometimes, you'd rather be looking
at a possibly inconsistent image than replaying the log  - particularly if
you're looking at a "seized and power plug pulled" image, and you actually
care about things that may have been in the log, like just-erased files. 

--==_Exmh_1176126139_28267P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGGkK7cC3lWbTT17ARAroiAKD8wEmjkMS2sBrfaagLOUsvioKjcwCgsczw
tZjWjCpax3vEhjl+Cl41ktE=
=g6KH
-----END PGP SIGNATURE-----

--==_Exmh_1176126139_28267P--
