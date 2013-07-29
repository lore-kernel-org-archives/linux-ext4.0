From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 11:13:42 -0500
Message-ID: <51F694B6.90901@redhat.com>
References: <20130729083941.GG28871@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab3G2QN4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 12:13:56 -0400
In-Reply-To: <20130729083941.GG28871@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/29/13 3:39 AM, Nikola Ciprich wrote:
> Hi,
> 
> trying to compile latest e2fsprogs and running check under RHEL6-compatible
> distro (centos) fails:
> 
> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
> r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed
> 
> dunno whether this is known issue... will bisect help?
> 
> with regards
> 
> nik
> 

Ted, these are the same ones I saw, plus one I think (working on getting
all the info).

I don't think it's a regression, because:

commit e79a9395b382e831c125d000d2bf16ba4b6253d4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Mar 31 20:34:24 2013 -0400

    tests: add more tests for off-line resizing

and:

$ git describe --contains e79a9395b382e831c125d000d2bf16ba4b6253d4
v1.42.8~31

the tests were only added in the last release.  Running the same tests
on older releases most likely breaks as well.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR9pS1AAoJECCuFpLhPd7g+dMP/1MdRJN8AzVIL6iX8sQ/yo2F
atDLdkzDjyjS+UzsTPEP0Q7C9MjSl74Z7+57SNyKjgESAY1MOp8LlPSsFMiuJfbW
u7Myd9iWfVHK/DIlOPBvW55WAi8y7w6HhXcTKhbjuEPUPJAPb1H36p+iwb/Sd40H
A/Ti6yOYyI05rXHonG+zzD4TFG3gNQT0zg3O0+BQZgX5uFuENlehgoZXxH61dwtP
tQTbFCrjcn337fTukwKDgDSBzuQT1Z6cQemzmoT+2C9Nhkqztjm6MMX+xjd96W0R
/aPITdVC4zLVl15QZSv/knAP0fJJyhhKsGJOYvzGXW2ydhFu/EmLtWSvu80E+slf
tigSqmh98WJzqyrrxcLOmV/ZncYKke/hpWa20t3eD775Lx4znkOGt7XkB7RtK648
LAcTrGi6Z7Saj44kS2zOvWs+IcxEzKAZWpZ2tFxxa5kn1riuHimhIlQZJwIAVF+j
XJT4c0IMGOIan0Z0NuP+K68RVi6X6Rsvr+o5OiUv6N4pnv8DsIskDAmpYpRUSwPV
R5WlwidCOpnPoiff8dAOnFjDZnmxG0VUMq9URTtvchNwPflBgp6LDC7LLbb+HWkh
uxCOqiirv1T1ZTGIglN804CzccWHjTufNZz6p/5klApxBa/HUZuzb29YQ7oicUSy
3fiWWRobTPA/+PQGKGBT
=G+1+
-----END PGP SIGNATURE-----
