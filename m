From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Tue, 21 Jul 2009 11:52:36 -0700
Message-ID: <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
	 <20090703143729.GJ20343@webber.adilger.int>
	 <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
	 <20090721161018.GH4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:48680 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZGUSwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 14:52:36 -0400
Received: by pzk42 with SMTP id 42so635043pzk.33
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 11:52:36 -0700 (PDT)
In-Reply-To: <20090721161018.GH4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 21, 2009 at 9:10 AM, Andreas Dilger<adilger@sun.com> wrote:
>> Error reading block 576192512 (Attempt to read block from filesystem
>> resulted in short read) while reading inode and block bitmaps. =A0Ig=
nore
>> error? no
>>
>> e2fsck: Can't read an block bitmap while retrying to read bitmaps fo=
r /dev/md2
>> e2fsck: aborted
>
> What is very strange here is that the block numbers being reported as
> having read errors are not even beyond the 16TB limit. =A0Assuming 4k=
B blocks:
>
> 576192512 * 4kB =3D 2304770048kB =3D 2198GB
>
> Are there error messages in syslog/dmesg when this happens?

No, no error messages from the kernel.  But your llverdev utility
ended up showing problems on the device.  After asking around on the
MD mailing list, that was apparently because of the page cache index
limit (at the time I was using a 32-bit kernel).

Switching to a 64-bit kernel allowed me to pass the llverdev test and
get much further with a very large filesystem, but I'm running into
other issues now.  I wrote up a very simple script to write 2TB files
onto the filesystem until the device fills up.  It was able to write
~16TB, but after that it ran into some problems.  My kernel log now
has lots of messages like these:
EXT4-fs error (device md2): ext4_mb_generate_buddy: EXT4-fs: group
163548: 32744 blocks in bitmap, 32768 in gd
- and -
EXT4-fs error (device md2): ext4_mb_mark_diskspace_used: Allocating
block 4294967391 in system zone of 131072 group

I shouldn't need e2fsprogs to be compiled 64-bit as well, right?
Currently I've got a 64-bit kernel with 32-bit userspace.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
