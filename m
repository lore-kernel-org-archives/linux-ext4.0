From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: dumpe2fs/dump/restore not working correctly for ext4?
Date: Thu, 4 Mar 2010 17:21:40 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003041719180.17723@p34.internal.lan>
References: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan> <20100304221728.GH15028@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:46833 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0CDWVl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 17:21:41 -0500
In-Reply-To: <20100304221728.GH15028@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 4 Mar 2010, tytso@mit.edu wrote:

> On Thu, Mar 04, 2010 at 10:19:57AM -0500, Justin Piszcz wrote:
>> Hi,
>>
>> I need to look into this more obviously and try other dumps etc, but
>> I even tried extracting a single (smaller) directory and it also
>> segfaulted, has dump been tested properly with ext4?
>
> Was dump/restore statically or dynamically linked?  And with which
> version of libext2fs from e2fsprogs?
>
> 						- Ted
>

Hi,

I tried restoring from two different datasets on one machine <10GB and another
one ~30GB, all files are corrupted, other users report the same problem:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html

Per your requests:

They are dynamically linked.
This is standard Debian Testing x86_64, nothing custom (in the 
distribution).

p34:~# ldd `which dump`
         linux-vdso.so.1 =>  (0x00007fff93192000)
         libext2fs.so.2 => /lib/libext2fs.so.2 (0x00007f0bdf559000)
         libcom_err.so.2 => /lib/libcom_err.so.2 (0x00007f0bdf356000)
         libblkid.so.1 => /lib/libblkid.so.1 (0x00007f0bdf141000)
         libuuid.so.1 => /lib/libuuid.so.1 (0x00007f0bdef3d000)
         libc.so.6 => /lib/libc.so.6 (0x00007f0bdebe9000)
         libpthread.so.0 => /lib/libpthread.so.0 (0x00007f0bde9cc000)
         /lib64/ld-linux-x86-64.so.2 (0x00007f0bdf79a000)
p34:~# ldd `which restore`
         linux-vdso.so.1 =>  (0x00007fff857ed000)
         libext2fs.so.2 => /lib/libext2fs.so.2 (0x00007f5b5c3cd000)
         libcom_err.so.2 => /lib/libcom_err.so.2 (0x00007f5b5c1ca000)
         libe2p.so.2 => /lib/libe2p.so.2 (0x00007f5b5bfc3000)
         libreadline.so.5 => /lib/libreadline.so.5 (0x00007f5b5bd83000)
         libncurses.so.5 => /lib/libncurses.so.5 (0x00007f5b5bb3e000)
         libc.so.6 => /lib/libc.so.6 (0x00007f5b5b7e9000)
         libpthread.so.0 => /lib/libpthread.so.0 (0x00007f5b5b5cd000)
         /lib64/ld-linux-x86-64.so.2 (0x00007f5b5c60e000)
         libdl.so.2 => /lib/libdl.so.2 (0x00007f5b5b3c9000)
p34:~# dpkg -l | grep libext2fs
p34:~# dpkg -l | grep libe2fs
p34:~# dpkg -l | grep e2fs
ii  e2fslibs                             1.41.10-1                  ext2/ext3/ext4 file system libraries
ii  e2fsprogs                            1.41.10-1                  ext2/ext3/ext4 file system utilities
p34:~#

p34:~# dpkg -S /lib/libext2fs.so.2
e2fslibs: /lib/libext2fs.so.2
p34:~#

Justin.


