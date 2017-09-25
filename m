From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: File system corruption after reboot, when rootfs in mounted over
 nfs
Date: Mon, 25 Sep 2017 10:23:32 -0400
Message-ID: <20170925142332.ekcugi2mimb6k4s5@thunk.org>
References: <CAPXMrf_s10K_b+Eg0emNH_gdQDe-sScyDzgiUhnnj+SYzHK4EA@mail.gmail.com>
 <20170919132518.krlzjckc4z46ichy@thunk.org>
 <CAPXMrf8ykZ_h84+O67fe6640rN6gTPT+YvCCVrMY+jBKzEu=3w@mail.gmail.com>
 <CAPXMrf87tQMUqw0yXncNvYa4z3Sojv-6VbMjLo1By_n-EETo6w@mail.gmail.com>
 <CAPXMrf9a++uRh-euVD-CJdxbHjH1Fi5=fv73aFxYug0E6bpFbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: RAJESH DASARI <raajeshdasari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47228 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933355AbdIYOXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 25 Sep 2017 10:23:34 -0400
Content-Disposition: inline
In-Reply-To: <CAPXMrf9a++uRh-euVD-CJdxbHjH1Fi5=fv73aFxYug0E6bpFbw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 25, 2017 at 12:18:40PM +0530, RAJESH DASARI wrote:
> the below steps were executed in a loop for 100 times. I am seeing the
> issue after executing for around 40 iterations.
>     1) e2fsck -y -n /dev/sda1

Are you really using "e2fsck -y -n"?  That makes no sense.

The options "-f -y" would make sense; as would "-f -n".  I'm going to
assume it really was "-f -y" given your other comments, but being
precise is also really important.  You also didn't mention what
version of e2fsck/e2fsprogs you are using, which might be useful, but
given this is a flaky bug, it really doesn't matter, since it's almost
certainly a hardare problem or a device driver problem.

>      2) mount -t ext2 /dev/sda1 /mnt
>      3) touch /mnt/test.log
>      4) umount /mnt
>      5) e2fsck -y -n /dev/sda1
>      6)reboot
> i tried to mount the hard disk as ext2 as my hard disk partition was
> formatted as ext2 device.

I would suggest doing a series of differential diagnosis.  For
example, replacing the hard drive with another hard drive.  Moving
your hard drive to another system, and seeing if you can reproduce the
problem there.  Simply reseating the cables might help.

But this is not a software problem, but clearly a hardware problem,
and so you're probably better office finding someone local who can
help you walk through debugging a hardware problem.

Cheers,

					- Ted
