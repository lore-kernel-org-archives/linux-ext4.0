From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: sustained write to disk, frozen copy
Date: Mon, 29 Apr 2013 00:50:23 +0800
Message-ID: <20130428165023.GA5723@gmail.com>
References: <1719908460.2201367046573138.JavaMail.root@shiva>
 <918096296.2221367046962554.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LuVar <luvar@plaintext.sk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55760 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3D1Qcx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2013 12:32:53 -0400
Received: by mail-pd0-f172.google.com with SMTP id 4so3233188pdd.31
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2013 09:32:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <918096296.2221367046962554.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 08:16:02AM +0100, LuVar wrote:
> Hi,
> I have my desktop about 24 hours in "deadlock". I was copying (as root in krusader from USB key (mounted as [1]) data to filesystem [2]) some files from one point to another. Now it is more than 24 hours with sustained disk write, see [3].
> 
> How can I help and "debug" this problem? I have 3.5.7 gentoo kernel ([4]).

Hi LuVar,

You could use 'echo w >/proc/sysrq-trigger' to look at which process has
been deadlock.

 # echo w >/proc/sysrq-trigger (WARN: you need a root privilege)
 # dmesg | vim -

 SysRq : Show Blocked State
   task                        PC stack   pid father

Here is nothing because my system hasn't any deadlock.  Then you could
use 'echo t >/proc/sysrq-trigger' to dump current tasks and their
information.  That would be great if you could paste these details in
mailing list.  They are very useful for us to dig this problem.

Thanks,
                                                - Zheng

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
