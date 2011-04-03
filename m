From: Zeev Tarantov <zeev.tarantov@gmail.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 3 Apr 2011 21:52:58 +0300
Message-ID: <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com> <4D98BF34.6040503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1DCSxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 14:53:18 -0400
Received: by pzk9 with SMTP id 9so1110446pzk.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 11:53:18 -0700 (PDT)
In-Reply-To: <4D98BF34.6040503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 3, 2011 at 21:40, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/3/11 11:07 AM, Zeev Tarantov wrote:
>> While testing zram I ran a script that creates a block devices,
>> creates a filesystem on in and untars Qt on that filesystem.
>> I was surprised to find ext4_mb_scan_aligned near the top of the pro=
file output.
>> This was evidently because the command "mke2fs -t ext4 -m 0 -I 128 -=
O
>> ^has_journal,^ext_attr <block device>"
>> =A0created a filesystem with (output of tune2fs):
>> RAID stride: =A0 =A0 =A0 =A0 =A0 =A0 =A01
>> RAID stripe width: =A0 =A0 =A0 =A01
>
> mke2fs queries the block device for its geometry, based on what is
> reported via sysfs:
>
> /*
> =A0* Sets the geometry of a device (stripe/stride), and returns the
> =A0* device's alignment offset, if any, or a negative error.
> =A0*/
> static int get_device_geometry( ...
> ...
> =A0 =A0 =A0 =A0min_io =3D blkid_topology_get_minimum_io_size(tp);
> =A0 =A0 =A0 =A0opt_io =3D blkid_topology_get_optimal_io_size(tp);
> ...
>
> =A0 =A0 =A0 =A0fs_param->s_raid_stride =3D min_io / blocksize;
> =A0 =A0 =A0 =A0fs_param->s_raid_stripe_width =3D opt_io / blocksize;
>
> What does
>
> # blockdev --getiomin --getioopt /dev/<yourdevice>
>
> say for your device?

get logical block (sector) size: 4096
get physical block (sector) size: 4096
get minimum I/O size: 4096
get optimal I/O size: 4096
get alignment offset in bytes: 0
get max sectors per request: 255
get blocksize: 4096
get readahead: 256

> The device may be reporting odd values, but mke2fs probably
> should be smart enough not to set block-sized stripe unit and width..=
=2E

If the filesystem created with the default options is slow or has
higher cpu usage, it should be changed.

> -Eric

-Z.T.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
