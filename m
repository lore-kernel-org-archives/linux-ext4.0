From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Difference in statvfs(2) block count with ext2 and very recent
 Linux 3.2.0 kernels
Date: Wed, 16 Nov 2011 10:33:19 -0600
Message-ID: <4EC3E5CF.6030805@redhat.com>
References: <20111116095418.GA8054@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, meyering@redhat.com
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab1KPQdV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 11:33:21 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAGGXLac027285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 11:33:21 -0500
In-Reply-To: <20111116095418.GA8054@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/16/11 3:54 AM, Richard W.M. Jones wrote:
> 
> Hi,
> 
> We do some automated testing of the kernel and ext2/3/4 filesystems,
> and noticed that the block count returned by statvfs(2) for plain
> *ext2* filesystems has changed with the latest 3.2.0rc1 kernel.
> 
> This is probably just because of more accurate block accounting, but I
> just wanted to check that it isn't a bug.
> 
> This posting contains the numbers and a reproducer:
> 
>   https://www.redhat.com/archives/libguestfs/2011-November/msg00051.html
> 
> Rich.
> 

Note that it is a plain *ext2* filesystem run through the *ext4* driver,
in Fedora, and it was tracked down to commit f975d6bcc7a698a10cc755115e27d3612dcfe322
ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
according to the above post...

I will try to look at this to see just why the change affects ext2, unless
Ted knows offhand.

- -Eric


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOw+XNAAoJECCuFpLhPd7g6dEQALFVADUWDdCVtkqO83Zx06eW
Kc64rAU5nl/HMA/BWV7+kwFxcAxuC/TFlvVJ9Prq7chT+8TudssQPmYJqWXQcbBX
42tvwMMZLhdWhfiUNdMFUTGpuVxx5cz7ZQX0tdp4/zxtDlhUJ3lo2jZMFnajvT+I
0k11h8S7DcW8yWYih/aiuY6FUuTJv2LCP7VWVIZTuNW5zjFGHT02KKNtKQ81Fynh
gpyj2kcBhDGYHDS+DYB4Lm54Jeb7ZO7eKUP/n126MXG8hkEuM1nKxAWOFykdkskX
QbH8MgA0wZDiY1WfJCW8wRBPXC9swJr9w/bQotV6TWyEZ97XA82hhF9we6cqvtLW
F+xMzdIRlKHHvpKUmA/FbrfLn2va7dnihE/0FsVD7Twem7vn35sFZFq4UnZxIlCl
fZ92aq0T7Z8AVvqjBtOpnxJNLa7sTYLxqHMRIT7UqI/kaH0py8byh4vdtI+CSdJs
wK8V4e/BNzrzxdh6OqKsoRwfQOsFObKwAcfCGB/bU2x8WYzxdaqqzsroOa99YxLq
kjuXpU8feopiiqy0H4pFj/sJfPpn9L0J0Ppx5sBReuRAPZEkokurZr6t8d6jbwpj
4Wqa5X573zMgypQOCVDNJvEjg5MWrI0SWs8GtiQzZ4shkjBbGaHserOWTNwAaXzi
kaOxCFg3//vsXEE0kx7z
=U1OD
-----END PGP SIGNATURE-----
