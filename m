From: Sami Liedes <sami.liedes@iki.fi>
Subject: Announcing the Berserker toolkit for (semi-)automated fs fuzz testing
Date: Sat, 28 Apr 2012 04:39:04 +0300
Message-ID: <20120428013904.GE20648@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:45858 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab2D1BjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 21:39:10 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is an announcement of the first release of the Berserker toolkit
for (semi-)automated fuzz testing and testcase minimization of Linux
kernel filesystem implementations.

The toolkit consists of the following components and their
documentation:

* Debian sid (unstable) based root filesystem image with scripts
  inside and set to run automatically that will test filesystems based
  on kernel commandline parameters, intended to be run inside a
  virtual machine (KVM); a 32-bit x86 system

* berserker-testfs.py, a script to automate running fuzz tests inside
  KVM on a filesystem image (simply give as parameters the filesystem
  type, a working filesystem image and a kernel bzImage - see --help).
  This script takes care of running KVM and interpreting the output.
  Its return values make it suitable for using in "git bisect run". By
  default the VM will fuzz and run until it has produced a crash.

* berserker-minimize.sh (and fuzz-minimize used by it), a program to
  derive a crash-inducing test case with minimal differences to a
  pristine filesystem image by repeatedly automatically running
  berserker-testfs.py on different images. Takes as input the kernel
  image to use, a pristine filesystem image and a fuzzed filesystem
  image that causes the kernel to crash.

To get the source:

   git clone http://www.niksula.hut.fi/~sliedes/berserker/berserker.git

The repository contains a script (download-binaries.sh) that downloads
some files (*at least until my university gets unhappy with the
bandwidth used):

* the root filesystem (hda.autotest; 112 MiB compressed, 501 MiB
  uncompressed); and for quick start

* a vanilla 3.3.4 bzImage for amd64 suitable for use with the system
  (config file included in the git repository)

* testimg.ext4, a 10 MiB ext4 filesystem with the required layout
  (described in more detail in the README file)

The actual fuzzer used is zzuf (Debian package zzuf) by Sam Hocevar. I
believe it is similar in spirit to fsfuzzer which appears to be more
familiar to the kernel community; zzuf was chosen because I was more
familiar with it and because it was packaged for Debian.

Two examples of (what appears to be) ext4 bugs found with this
toolkit, both reproducible with a 1-bit difference to a pristine
filesystem:

  http://www.spinics.net/lists/linux-ext4/msg31850.html
     (sorry, by mistake the subject doesn't quite reflect the bug...)

  http://www.spinics.net/lists/linux-ext4/msg31853.html

See the included README file for a very quick introduction and some
more detailed documentation.

	Sami Liedes

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPm0o4AAoJEKLT589SE0a0VO8P/2MeeLXUalK7KBs0W8CPhtmQ
9Js+Uv8r5EMb++mhUIoAFm2EWD950qsPkC/QWOrxhcCvic+FC/09Sp0oXlDHTRAB
NX85p9FDmeHOwMIk3gqNZKUWlooVaJXo/ibFFB4PEIIRJ1kn0KfAfhyTKxLzKK1O
E2rtgU3nGGGISphLb5ntxyu+gpY5jZYRy/r6qtNGRUzwAocCXfsv8uTPbTMTLvie
20jTO/daRqcOvfKmD15CZPRY2gHo8i/i/gUCfrYd1a8STw4s9gIHNwkStyQbJzpE
c71ebJ2h24JtE+gt0nv2ibCwPSgDDO88yawCRz2K90nYDaGGGIT7CUFd7MQpVRFA
ll0ZikzhoVkggg74/ikeUGhrz6AhMcVOgp8CLx/awJz0cAhmJYWvV3n0ZVyB2wCG
JQtib1S2LcTlJc/bm/AH68EDpcqPQBTOACMScY0kHIkfAd56eBSR9bIL//rJKZc9
dtsNzm+QSUc2IQmJK6h5Yq6aqYdX9DNl0WGx2Ti0nrDZKfIftfL0w2U6xytfdeNy
1RYZffYfmTrM9gK+ISyixvj2y/+Q/9boL1KxOZHu/Dd7bf/uID/w0KcvYxgQ5IWR
rD/g6uCcgTMeS3rWbQ24/4MrmDhdUlpsoUwhfQ6LpmaXCUejO8mKTSZXiFsJbX7J
Ze5s2Ie58BwPsrHOyOPl
=XLN9
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
