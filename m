From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 17:26:02 -0600
Message-ID: <61355884-798E-4BE1-8CF6-D990851CA3B1@dilger.ca>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com> <20110915165512.GA12086@tux1.beaverton.ibm.com> <20110915171934.GB12086@tux1.beaverton.ibm.com> <7755CB79-FD71-49BE-AF93-0A49CA25CEAC@dilger.ca> <20110915200519.GC12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54259 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOX0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 19:26:03 -0400
In-Reply-To: <20110915200519.GC12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 2:05 PM, Darrick J. Wong wrote:
> On Thu, Sep 15, 2011 at 01:10:41PM -0600, Andreas Dilger wrote:
>> 
>> It really would be interesting to measure the crc32c() and crc16() performance
>> for 512MB in chunks of 4, 32, 128, 256, and 4096 bytes (which is the largest
>> that we will generally use until we get to data checksums).  That would give
>> us a good idea how fast the checksums _really_ are in our actual usage.
> 
> Ok, here's a rough cut with the Xeon X5650 at work:
> 
> crc32c-sby8-le@4: sz=536870912 time=1722.019ms speed=304461.26K/s
> crc32c-sby8-le@32: sz=536870912 time=410.747ms speed=1276424.81K/s
> crc32c-sby8-le@128: sz=536870912 time=338.527ms speed=1548731.75K/s
> crc32c-sby8-le@256: sz=536870912 time=329.869ms speed=1589382.17K/s
  :
  :
> crc32c-sby8-le@536870912: sz=536870912 time=309.269ms speed=1695251.44K/s 

This gets 75% peak speed at 32 bytes, and is 91% of the peak at 128 bytes.

> crc16@4:         sz=536870912 time=1605.590ms speed=326539.15K/s
> crc16@32:        sz=536870912 time=1440.110ms speed=364061.15K/s
> crc16@128:       sz=536870912 time=1374.726ms speed=381376.47K/s
  :
  :
> crc16@536870912: sz=536870912 time=1366.145ms speed=383771.74K/s

This basically doesn't change regardless of the data size, and is only
marginally faster than the optimized crc32c at 4 byte size.

> crc32c-intel@4:         sz=536870912 time=1025.192ms speed=511404.47K/s
> crc32c-intel@32:        sz=536870912 time=135.124ms speed=3880043.59K/s
> crc32c-intel@128:       sz=536870912 time=121.991ms speed=4297766.44K/s
> crc32c-intel@256:       sz=536870912 time=120.008ms speed=4368783.42K/s
  :
  :
> crc32c-intel@536870912: sz=536870912 time=118.369ms speed=4429255.67K/s

This is already faster than crc16 at 4 byte size, and is miles ahead at
32 byte size (the group descriptor CRC chunk size, regardless of whether
a 32-byte or 64-byte descriptor is actually used).

> As you can see from the results, the algorithm(s) that are fast generally
> don't reach full speed until they hit 4KB chunk sizes.  powerpc64 and a
> laptop seems to yield speed scaling similar results.

While it is true they don't reach peak speed until 4kB, even at chunk
sizes as small as 32 bytes crc32c is a clear winner.  This makes me think
that using CRC32c LSB for the group descriptor checksums when RO_COMPAT_CSUM
is present may be worth the effort.

> crc32c-sby8-* = my new crc32c implementation
> crc16 = kernel's crc16 implementation
> crc32c = kernel's current crc32c sw implementation
> crc16-t10dif = t10dif crc16 implementation
> crc32c-intel = hw accelerated crc32c
> 
> --D

Cheers, Andreas





