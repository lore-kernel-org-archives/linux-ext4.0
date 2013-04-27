From: Azat Khuzhin <dohardgopro@gmail.com>
Subject: Re: sustained write to disk, frozen copy
Date: Sun, 28 Apr 2013 01:48:11 +0400
Message-ID: <CAAW1UO8WSk6K9LOZurTuMMg6_UmTAOpriRVkpQPjdyaiuOD4MQ@mail.gmail.com>
References: <1719908460.2201367046573138.JavaMail.root@shiva>
	<918096296.2221367046962554.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: LuVar <luvar@plaintext.sk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:52048 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3D0VsM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 17:48:12 -0400
Received: by mail-ia0-f178.google.com with SMTP id j38so4548891iad.23
        for <linux-ext4@vger.kernel.org>; Sat, 27 Apr 2013 14:48:11 -0700 (PDT)
In-Reply-To: <918096296.2221367046962554.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Luvar,

Could you see this thread
http://comments.gmane.org/gmane.comp.file-systems.ext4/38323

Seems that you have something similar.

On Sat, Apr 27, 2013 at 11:16 AM, LuVar <luvar@plaintext.sk> wrote:
> Hi,
> I have my desktop about 24 hours in "deadlock". I was copying (as root in krusader from USB key (mounted as [1]) data to filesystem [2]) some files from one point to another. Now it is more than 24 hours with sustained disk write, see [3].
>
> How can I help and "debug" this problem? I have 3.5.7 gentoo kernel ([4]).
>
> PS: I am an average user, so please by verbose to me.
>
> [1] sudo mount -o rw,uid=luvar,gid=luvar,iocharset=utf8 /dev/sdg1 /mnt/usbstick/
>
> [2]:
> luvar@blacktroja ~ $ mount | grep music
> /dev/mapper/vg-music on /var/lib/mpd/music/local type ext4 (rw,noatime,commit=0)
>
> [3]:
> iotop, two first records :
> 17714 be/3 root        0.00 B/s    0.00 B/s  0.00 % 97.60 % [jbd2/dm-3-8]
>  6546 be/4 root        0.00 B/s    0.00 B/s  0.00 % 93.48 % kdeinit4: kio_file [kdeinit] file local:/tmp/ksocket-root/~-socket local:/tmp/ksocket-root/krusaderZz6431.slave-socket
>
> [4]:
> luvar@blacktroja ~ $ uname -a
> Linux blacktroja 3.5.7-gentoo #1 SMP Sun Oct 28 17:18:07 CET 2012 x86_64 Intel(R) Core(TM) i7 CPU 930 @ 2.80GHz GenuineIntel GNU/Linux
>
> Thanks, LuVar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Respectfully
Azat Khuzhin
Primary email a3at.mail@gmail.com
