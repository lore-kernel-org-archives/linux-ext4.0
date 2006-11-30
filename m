From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: Re:[RFC][PATCH 0/3] Extent base online defrag
Date: Thu, 30 Nov 2006 12:46:09 +0530
Message-ID: <1164870969.3255.11.camel@alpha.linsyssoft.com>
References: <012a01c713a5$54910430$4168010a@bsd.tnes.nec.co.jp>
	 <20061129233931sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: rupesh@clusterfs.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36787 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1758460AbWK3HKv
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 02:10:51 -0500
To: sho@tnes.nec.co.jp
In-Reply-To: <20061129233931sho@rifu.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,


On Wed, 2006-11-29 at 23:39 +0900, sho@tnes.nec.co.jp wrote:
> Hi,
> 
> Thank you for your trial and report of the result!
> 
> > Hi,
> > I tried to use defrag utility. But these are the results that, I got:
> > 
> > [root@metis e4defrag]# ./defrag /dev/hda8
> > Start defragment for device(/dev/hda8)
> >        Total:                   393
> >        Success:                   0 
> >        Failure:                 393
> > [root@metis e4defrag]# ./defrag /mnt/test1/root
> > Start defragment for directory(/mnt/test1/root)
> >        Total:                   392
> >        Success:                   0
> >        Failure:                 39
> > I tried same thing with different directories and files, but the result
> > was the same.
> > By doing strace on defrag utility I found that ioctl always retunarned
> > ENOSPC. So I decreased the no. files, but still that didn't help, I came
> > down till filesystem was only 9% full.
> 
> I think that your files didn't have many fragments, so ioctl returned
> ENOSPC.  e4defrag iterates ioctl per 64MB.  If the specified 64MB
> range has only one fragment(extent), the kernel returns ENOSPC
> at the current implement.
> So I'll change this behaviour to realize whether there was actual
> error.  I intend to update my patches in early December.
> 
Thanks for responding and for the scan_ext3 program.
I did further testing, i checked if the file is fragmented or not :

[root@metis e4defrag]# ./scan_ext3 /mnt/test2/root/file3
Extents of /mnt/test2/root/file3:
start = 117919 len = 11316 block = 0
start = 136356 len = 2 block = 11316
start = 165920 len = 24 block = 11318
start = 165913 len = 7 block = 11342
start = 221200 len = 48 block = 11349
start = 221282 len = 1 block = 11397
start = 221295 len = 12 block = 11398
start = 221328 len = 1 block = 11410
start = 221381 len = 3 block = 11411
start = 221496 len = 1 block = 11414
start = 221517 len = 57 block = 11415
start = 221585 len = 53 block = 11472
start = 221673 len = 6 block = 11525 
start = 221681 len = 4 block = 11531
start = 221707 len = 1 block = 11535
start = 221711 len = 5 block = 11536
start = 221725 len = 25 block = 11541

>From the test the file seems to be pretty fragmented, still the defrag
utility gives ENOSPC error.

[root@metis e4defrag]# strace -e
trace=ioctl ./defrag /mnt/test2/root/file3
Start defragment for /mnt/test2/root/file3
ioctl(3, 0x4010660a, 0xbf8747c0)        = -1 ENOSPC (No space left on
device) 
        e4defrag  : defrag fail.: No space left on device
                    "/mnt/test2/root/file3"
[root@metis ~]# ll -h /mnt/test2/root/file3
-rw-r--r--  1 root root 159M Sep  2 10:34 /mnt/test2/root/file3

Most probably Rupesh(cc'ed him) will be looking into it further, really
appreciate if you can add something to it.

Thanks & Regards,
Girish.
