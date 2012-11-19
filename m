From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 09:18:01 -0600
Message-ID: <50AA4DA9.5090602@redhat.com>
References: <CAPAnFc9ziuDdFV=4u2jcaGFTBV4M6xnkqbatOB0azgSShDYxTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2KSPSC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 10:18:02 -0500
In-Reply-To: <CAPAnFc9ziuDdFV=4u2jcaGFTBV4M6xnkqbatOB0azgSShDYxTQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/18/12 10:46 PM, Drew Reusser wrote:
> Hello all,
> 
> I am having an issue with a ext4 file system which I cannot get to
> come back up.  There were no changes that I know of, but I rebooted,
> and when the system came back up it was not able to read from the hard
> drives.  I have it setup in a raid 10 configuration, and can mount the
> raid array with no issues.  However when I mount the file system, I
> get the following error "EXT4-fs (md0): VFS: Can't find ext4
> filesystem" from the log files.
> 
> Is there anyone that can help as I have to get this data back and I
> prefer not to have to go to a professional to get it back and spend
> the money.
> 
> -Drew
> 
> Basic Info:  4x1TB disks, raid 10 equaling 2TB total.  All four disks
> are just one giant partition starting at the 2MB mark so I could boot
> and put mdadm in the boot sector and get into linux.
> 
> Some basic commands below:
> 
> 
> mint mnt # mount -t ext4 /dev/md0 /mnt/raid
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 

Ok, at this point you need to do what it says:

# dmesg | tail

so we can see for ourselves why the kernel rejected it (is there 
anything other than "EXT4-fs (md0): VFS: Can't find ext4
filesystem" ?

does /proc/mdstat look right?  This is more likely an md config
issue than an ext4 problem.  What does file -s /dev/md0 or
blkid /dev/md0 say?

-Eric

> 
> 
> C is the pen-drive I am booting from currently and F is the 2TB disk I
> was using to backup to.
> 
> mint dev # cat /proc/partitions
> major minor  #blocks  name
> 
>    7        0     939820 loop0
>    8        0  976762584 sda
>    8        1  976760832 sda1
>    8       16  976762584 sdb
>    8       17  976237568 sdb1
>    8       32    1985024 sdc
>    8       33    1984960 sdc1
>    8       48  976762584 sdd
>    8       49  976760832 sdd1
>    8       64  976762584 sde
>    8       65  976237568 sde1
>   11        0    1048575 sr0
>    8       80 1953514584 sdf
>    8       81 1953512448 sdf1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

