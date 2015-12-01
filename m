From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: EXT4-fs (device loop0): panic forced after error -- bug or not?
Date: Tue, 1 Dec 2015 17:59:07 +0100
Message-ID: <565DD1DB.4060803@oracle.com>
References: <565DAD0A.6030305@oracle.com> <20151201153202.GA3179@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32799 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbbLAQ7P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2015 11:59:15 -0500
In-Reply-To: <20151201153202.GA3179@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/01/2015 04:32 PM, Theodore Ts'o wrote:
> On Tue, Dec 01, 2015 at 03:22:02PM +0100, Vegard Nossum wrote:
>>
>> I'm a bit unsure about whether this is really a bug or not; it looks
>> like the filesystem is set to panic on error but I still find it weird
>> that this behaviour is allowed by default (would it still panic if
>> somebody inserted this filesystem on a USB stick and it got automounted?).
>
> If the distribution cares about this, it should automount with mount
> option "errors=remount-ro".
>
>> I call mount() with mountflags=0 and data=NULL followed by opendir() and
>> readdir(), but if I just a manual mount + ls from the shell I don't see
>> the panic at all, just some of the errors, so I thought maybe there's
>> some sort of race somewhere?
>
> I'm not able to reproduce this; I'm getting EACCES to the opendir().
>
> But looking at your kernel messages, it's not a bug.

Alright, I'll add errors=remount-ro to my scripts.

Strange that you get EACCESS, without errors=remount-ro I get:

open("/dev/loop0", O_RDWR)              = 3
mkdir("/mnt/ext4", 0755)                = -1 EEXIST (File exists)
open("ext4.0", O_RDWR)                  = 4
ioctl(3, LOOP_SET_FD, 0x4)              = 0
close(4)                                = 0
ioctl(3, LOOP_SET_STATUS64, {offset=0, number=0, flags=0, 
file_name="ext4.0", ...}) = 0
mount("/dev/loop0", "/mnt/ext4", "ext4", 0, NULL) = 0
open("/mnt/ext4", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
getdents(4, <panic>

If I do add errors=remount-ro, I get:

open("/dev/loop0", O_RDWR)              = 3
mkdir("/mnt/ext4", 0755)                = -1 EEXIST (File exists)
open("ext4.0", O_RDWR)                  = 4
ioctl(3, LOOP_SET_FD, 0x4)              = 0
close(4)                                = 0
ioctl(3, LOOP_SET_STATUS64, {offset=0, number=0, flags=0, 
file_name="ext4.0", ...}) = 0
mount("/dev/loop0", "/mnt/ext4", "ext4", 0, "errors=remount-ro") = 0
open("/mnt/ext4", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
getdents(4, /* 0 entries */, 32768)     = 0
close(4)                                = 0

Thanks for the quick response.


Vegard
