From: Ryan Wang <openspace.wang@gmail.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Date: Tue, 27 Nov 2012 09:20:47 +0800
Message-ID: <CAPxxNQmgOmEzkmzL7Tei4KAxaP49yx1fmhNgxvwaFNiYVosGtA@mail.gmail.com>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
	<alpine.LFD.2.00.1211261442490.18234@localhost>
	<20121126145559.GK31891@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34228 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2K0BUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 20:20:48 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4642233eaa.19
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 17:20:47 -0800 (PST)
In-Reply-To: <20121126145559.GK31891@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/11/26 Theodore Ts'o <tytso@mit.edu>:
> On Mon, Nov 26, 2012 at 02:43:40PM +0100, Luk=C3=A1=C5=A1 Czerner wro=
te:
>> > The I checked the script common.rc, and found that it uses
>> > df to determine the filesystem type and it uses the realpath
>> > "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
>> > shows "devtmpfs" instead of "ext4" for /dev/dm-0.
>> >
>> > I run "mount" and found that devtmpfs is mount on /dev/ on opensus=
e
>> > ***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /so=
medir",
>> > df still showed devtmpfs.
>> >
>> > Any ideas to kick off the xfstests?
>
> At least with the df which ships with Debian Testing, df will display
> the file system in use if it matches the device name which is
> /etc/mtab.  It looks the issue is that mount is canonicalizing the
> device name to be the human friendly version:
>
> # ls -l /dev/mapper/closure-bigscratch
> 0 lrwxrwxrwx 1 root root 7 Nov 16 15:15 /dev/mapper/closure-bigscratc=
h -> ../dm-7
> <tytso.root@closure> {/home/tytso/bin}, level 2
> # mount /dev/dm-7 /u2
> # df /u2
> Filesystem                     1K-blocks   Used Available Use% Mounte=
d on
> /dev/mapper/closure-bigscratch  52403200 224772  52178428   1% /u2
> # grep /u2 /etc/mtab
> /dev/mapper/closure-bigscratch /u2 xfs rw,relatime,attr2,inode64,noqu=
ota 0 0
>
> So the simplest solution is to just use /dev/mapper/mpatha instead of
> insisting on using /dev/dm-0.  That's what I do....

In xfstests/common.rc, it will use realpath to obtain /dev/dm-0, even i=
f you
specified /dev/mapper/mpatha.
My problem is in SuSE, the devtmpfs is mounted on /dev by default, seem=
s
used by udev. And df reports devtmpfs on /dev/dm-0, instead of ext4.

>
>                                                 - Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
