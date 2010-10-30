From: George Kola <georgekola@gmail.com>
Subject: Re: ext4 fallocate+truncate not freeing up allocated space
Date: Fri, 29 Oct 2010 18:26:42 -0700
Message-ID: <AANLkTikZEiBVGTnYqdLwR42WkRjPnaTe6jAg29H1ayfo@mail.gmail.com>
References: <007a01cb7796$d515da50$7f418ef0$@com>
	<4CCB14D6.6070605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53298 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0J3B0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 21:26:45 -0400
Received: by wyf28 with SMTP id 28so3711415wyf.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 18:26:44 -0700 (PDT)
In-Reply-To: <4CCB14D6.6070605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Erik,
=A0=A0 =A0 =A0Thanks for replying. How to get a hold of kernel=A0=A02.6=
=2E18-225.el5
? =A0I found=A02.6.18-227=A0at
http://people.redhat.com/jwilson/el5/227.el5/x86_64/
I tried it and the bug is fixed is=A02.6.18-227. =A0 Thanks for your he=
lp.
This may be off-topic -- how do I find the changes from
2.6.18-194.17.4 to=A02.6.18-225 (or=A02.6.18-227) ? I just want to know
what other changes I am installing in addition to the bug fix.

Thanks,
George

p/s: yes I am using FALLOC_FL_KEEP_SIZE.


On Fri, Oct 29, 2010 at 11:39 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
>
> George Kola wrote:
> > I am using RHEL (CentOS) 5.5 with kernel =A02.6.18-194.17.4.el5 =A0=
and ext4. I
> > posted to RHEL bugzilla and they requested me to post it here.
> >
>
> ...
>
> > Steps to Reproduce:
> > =A0 Have a program
> > 1. =A0Open a file on ext4 partition
>
> # touch testfile
>
> > 2. Fallocate space for that file =A0say 20 GB
>
> # /root/fallocate -l 20g testfile
> # df -h .
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 =A0 =A030G =A0 21G =A07.7G =A073% /mnt/=
test
> # du -h testfile
> 21G =A0 =A0 testfile
>
> > 3. Write data to the file =A0(but less than the allocated space) sa=
y 10 GB
>
> # dd if=3D/dev/zero of=3Dtestfile bs=3D10M count=3D1024 conv=3Dnotrun=
c
> 10737418240 bytes (11 GB) copied, 125.522 seconds, 85.5 MB/s
> # du -h testfile
> 21G =A0 =A0 testfile
> # df -h .
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 =A0 =A030G =A0 21G =A07.7G =A073% /mnt/=
test
>
> > 4. Close the file
> > 5. Call truncate(file-path, size+1), truncate(file-path,size) on th=
at file
> > to
> > give up the space (observed that the space is given up using filefr=
ag)
>
> 10g size I assume? Is the below representative?
>
> # /root/truncate 10737418241 testfile
> # ls -l testfile
> -rw-r--r-- 1 root root 10737418241 Oct 29 13:48 testfile
> # /root/truncate 10737418240 testfile
> # ls -l testfile
> -rw-r--r-- 1 root root 10737418240 Oct 29 13:48 testfile
>
> > 6. Use du and df on that ext4 partition to find that the mismatch
>
> # df -h .
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 =A0 =A030G =A0 11G =A0 18G =A037% /mnt/=
test
>
> # du -h testfile
> 11G =A0 =A0 testfile
>
> # uname -a
> Linux bear-05 2.6.18-225.el5 #1 SMP Mon Sep 27 10:32:19 EDT 2010 x86_=
64 x86_64 x86_64 GNU/Linux
>
> Seems to work here, though there are ext4 updates in that kernel.
>
> -Eric
>
> >
> >
> > -George
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
