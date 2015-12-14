From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: EXT4-fs (device loop0): panic forced after error -- bug or not?
Date: Mon, 14 Dec 2015 08:16:11 +0100
Message-ID: <566E6CBB.7070306@oracle.com>
References: <565DAD0A.6030305@oracle.com> <20151201153202.GA3179@thunk.org>
 <565DD1DB.4060803@oracle.com> <20151202134115.GA3356@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbbLNHQW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2015 02:16:22 -0500
In-Reply-To: <20151202134115.GA3356@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/02/2015 02:41 PM, Theodore Ts'o wrote:
> On Tue, Dec 01, 2015 at 05:59:07PM +0100, Vegard Nossum wrote:
>> Strange that you get EACCESS, without errors=remount-ro I get:
>>
>> open("/dev/loop0", O_RDWR)              = 3
>> mkdir("/mnt/ext4", 0755)                = -1 EEXIST (File exists)
>> open("ext4.0", O_RDWR)                  = 4
>> ioctl(3, LOOP_SET_FD, 0x4)              = 0
>> close(4)                                = 0
>> ioctl(3, LOOP_SET_STATUS64, {offset=0, number=0, flags=0,
>> file_name="ext4.0", ...}) = 0
>> mount("/dev/loop0", "/mnt/ext4", "ext4", 0, NULL) = 0
>> open("/mnt/ext4", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
>> getdents(4, <panic>
>
> What is the source code of your test program, and what version of C
> library are you using?  On my system, opendir() is getting translated
> to:
>
> openat(AT_FDCWD, "/vdc", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = -1 EACCES (Permission denied)
>
> (It would have saved me time if you had sent me the source of your
> test program, BTW.)

Hi Ted,

Sorry for dropping the ball on you here.

My test program is simply doing the loopback setup + mount() +
readdir(opendir(<mountpoint>)), there's nothing special about it.
Unfortunately, company policy prohibits me from sharing the actual code.

Compiling a simple readdir(opendir(".")) yields the same result:

open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
brk(0)                                  = 0xa87000
brk(0xab0000)                           = 0xab0000
getdents(3, /* 29 entries */, 32768)    = 904

This particular install is glibc 2.13-38+deb7u8, so it's admittedly
fairly old.

However, if you say it's not a bug when not mounted with
errors=remount-ro, I don't expect anybody to keep looking into this.


Vegard
