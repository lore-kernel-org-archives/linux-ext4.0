From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Difference in statvfs(2) block count with ext2 and very recent
 Linux 3.2.0 kernels
Date: Wed, 16 Nov 2011 11:40:48 -0600
Message-ID: <4EC3F5A0.3040404@redhat.com>
References: <20111116095418.GA8054@amd.home.annexia.org> <4EC3E5CF.6030805@redhat.com> <20111116164356.GT2626@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, meyering@redhat.com
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1KPTxk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 14:53:40 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAGJrGUP020922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 14:53:40 -0500
In-Reply-To: <20111116164356.GT2626@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/16/11 10:43 AM, Richard W.M. Jones wrote:
> On Wed, Nov 16, 2011 at 10:33:19AM -0600, Eric Sandeen wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 11/16/11 3:54 AM, Richard W.M. Jones wrote:
>>>
>>> Hi,
>>>
>>> We do some automated testing of the kernel and ext2/3/4 filesystems,
>>> and noticed that the block count returned by statvfs(2) for plain
>>> *ext2* filesystems has changed with the latest 3.2.0rc1 kernel.
>>>
>>> This is probably just because of more accurate block accounting, but I
>>> just wanted to check that it isn't a bug.
>>>
>>> This posting contains the numbers and a reproducer:
>>>
>>>   https://www.redhat.com/archives/libguestfs/2011-November/msg00051.html
>>>
>>> Rich.
>>>
>>
>> Note that it is a plain *ext2* filesystem run through the *ext4* driver,
>> in Fedora,
> 
> Correct!  We're using CONFIG_EXT4_USE_FOR_EXT23=y.
> 
>> and it was tracked down to commit f975d6bcc7a698a10cc755115e27d3612dcfe322
>> ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
>> according to the above post...
> 
> Well, that's what I thought looked likely.  However I didn't bisect
> this, so it could be another commit to blame ...

Ok, I will take a look, thanks.

- -Eric
 
> Rich.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOw/WeAAoJECCuFpLhPd7gDzkP/3DxN7tMY9gkOvHlGQhOHg5T
OJA2izckL4R18KRos7EbAJbXyX6fzFYPru8ztKZUpCcdLfe8TSkpkzv26qrtfZ8s
ir+ei68xe1hC1IzwrWGHlgoLEEiydbsEHdpxlMEDS1LBwstk5jNKCWl45LAJX4pl
kxCStgxZYZUdsFi1Ta2C36pitjCbPudAB5A7B/4aTu/QxugCtKe9FMJ9fiQmFRe8
g3ulTNp2fWfh8s8a3LkZZmbhIwXNmGPPZZRIsd5wWv4mzcCS5+Nk0cDfatInKeSP
JiRawQO3VjEa0yboam68c2oQre/UN2vzxv6joJOEhijvqws4+reRq7N7uokuXSOI
ZzW1jISeI5HFVI2T+sFMLnkWKcUhUJf8mPQsH4GKPFWUdxDQBTnOJr0TqqyCPE0B
irU6Ji0gmzsHyctW8rJOiPXgSj1CLXQRVhpINKRGvmEbtMopQmPnCrEwXw9FfIcU
0lybfu/+aRGYI6TXcplwPBx+WnPn7CVs5WpzvJifR4f4uyFbq/KypxgnNg23nrGq
fzYipsj/vCxHt0l4Jy3iwgQfVN+ZZTAmcq6PkDNrG9LV3TBVLyEJXxMemWgJ/DH6
e+7swc79aJ8KCBZJALgmYJT6ghz0a7Ma8lhCSotzSX42pW8g7LPanb2Uk5ayVl5U
N61Ggk6X4thGKPOTe+vf
=5ysl
-----END PGP SIGNATURE-----
