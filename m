From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 fallocate+truncate not freeing up allocated space
Date: Sat, 30 Oct 2010 10:43:55 -0500
Message-ID: <4CCC3D3B.30205@redhat.com>
References: <007a01cb7796$d515da50$7f418ef0$@com>	<4CCB14D6.6070605@redhat.com> <AANLkTinHFBoyB=N2RN6_NARU626VnDADpCVV+NXrW4t-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: George Kola <georgekola@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0J3PoA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Oct 2010 11:44:00 -0400
In-Reply-To: <AANLkTinHFBoyB=N2RN6_NARU626VnDADpCVV+NXrW4t-@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

George Kola wrote:
> Hi Erik, 
>       Thanks for replying. How to get a hold of kernel  2.6.18-225.el5 ?

It (or a later kernel) will be available to RHEL subscribers when released,
and CentOS at some time after that, on their schedule.

>  I found 2.6.18-227 at http://people.redhat.com/jwilson/el5/227.el5/x86_64/
> I tried it and the bug is fixed is 2.6.18-227.   Thanks for your help.
> 
> This may be off-topic -- how do I find the changes from 2.6.18-194.17.4
> to 2.6.18-225 (or 2.6.18-227) ? I just want to know what other changes I
> am installing in addition to the bug fix.

The kernel RPM changelog has a general description of changes, usually
with reference to bug numbers.

-Eric

> 
> Thanks,
> George 
> 
> 
> On Fri, Oct 29, 2010 at 11:39 AM, Eric Sandeen <sandeen@redhat.com
> <mailto:sandeen@redhat.com>> wrote:
> 
>     George Kola wrote:
>     > I am using RHEL (CentOS) 5.5 with kernel  2.6.18-194.17.4.el5  and
>     ext4. I
>     > posted to RHEL bugzilla and they requested me to post it here.
>     >
> 
>     ...
> 
>     > Steps to Reproduce:
>     >   Have a program
>     > 1.  Open a file on ext4 partition
> 
>     # touch testfile
> 
>     > 2. Fallocate space for that file  say 20 GB
> 
>     # /root/fallocate -l 20g testfile
>     # df -h .
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/sdb2              30G   21G  7.7G  73% /mnt/test
>     # du -h testfile
>     21G     testfile
> 
>     > 3. Write data to the file  (but less than the allocated space) say
>     10 GB
> 
>     # dd if=/dev/zero of=testfile bs=10M count=1024 conv=notrunc
>     10737418240 bytes (11 GB) copied, 125.522 seconds, 85.5 MB/s
>     # du -h testfile
>     21G     testfile
>     # df -h .
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/sdb2              30G   21G  7.7G  73% /mnt/test
> 
>     > 4. Close the file
>     > 5. Call truncate(file-path, size+1), truncate(file-path,size) on
>     that file
>     > to
>     > give up the space (observed that the space is given up using filefrag)
> 
>     10g size I assume? Is the below representative?
> 
>     # /root/truncate 10737418241 testfile
>     # ls -l testfile
>     -rw-r--r-- 1 root root 10737418241 Oct 29 13:48 testfile
>     # /root/truncate 10737418240 testfile
>     # ls -l testfile
>     -rw-r--r-- 1 root root 10737418240 Oct 29 13:48 testfile
> 
>     > 6. Use du and df on that ext4 partition to find that the mismatch
> 
>     # df -h .
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/sdb2              30G   11G   18G  37% /mnt/test
> 
>     # du -h testfile
>     11G     testfile
> 
>     # uname -a
>     Linux bear-05 2.6.18-225.el5 #1 SMP Mon Sep 27 10:32:19 EDT 2010
>     x86_64 x86_64 x86_64 GNU/Linux
> 
>     Seems to work here, though there are ext4 updates in that kernel.
> 
>     -Eric
> 
>     >
>     >
>     > -George
>     >
>     >
>     >
>     > --
>     > To unsubscribe from this list: send the line "unsubscribe
>     linux-ext4" in
>     > the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

