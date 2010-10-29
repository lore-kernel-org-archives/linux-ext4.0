From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4 fallocate+truncate not freeing up allocated space
Date: Fri, 29 Oct 2010 12:10:32 -0700
Message-ID: <AANLkTikygDP5HoZRNy5yUga-BPxNTZwKVd6chW1O-DUA@mail.gmail.com>
References: <007a01cb7796$d515da50$7f418ef0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: George Kola <georgekola@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0J2TKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 15:10:35 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id o9TJAYF1021271
	for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 12:10:34 -0700
Received: from qyk10 (qyk10.prod.google.com [10.241.83.138])
	by hpaq3.eem.corp.google.com with ESMTP id o9TJAW63003681
	for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 12:10:33 -0700
Received: by qyk10 with SMTP id 10so3410250qyk.12
        for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 12:10:32 -0700 (PDT)
In-Reply-To: <007a01cb7796$d515da50$7f418ef0$@com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Are you using FALLOC_FL_KEEP_SIZE?  If so, commit
a379cd1d6bb00f9f5d2759d4a5621a884df5914e fixed a bug with this (but I
don't know offhand which kernel this went into).

Curt

On Fri, Oct 29, 2010 at 11:26 AM, George Kola <georgekola@gmail.com> wr=
ote:
> I am using RHEL (CentOS) 5.5 with kernel=A0 2.6.18-194.17.4.el5=A0 an=
d ext4. I
> posted to RHEL bugzilla and they requested me to post it here.
>
> I wrote a program that fallocates space for a file. It does not know =
the
> file
> size apriori and uses a heuristic. If the final file size is less tha=
n the
> allocated space, I free up the extra space with truncate. I found tha=
t
> freeing
> up did not work so I ended up doing two truncates -- truncate(size+1)
> followed
> by truncate(size) as suggested in
> http://kerneltrap.org/mailarchive/linux-ext4/2009/7/21/6243463.
>
> I now find that the freed space is not given back till a unmount+ mou=
nt.
> I detected this by finding disks full even though the used space was =
lesser.
>
> I did the standard tests
> 1. Stopped all program having handles open to files on that partition
> 2. Verified with lsof that there are no open handles to files in that
> partition
> =A0=A0=A0=A0 Still there was a mismatch. e.g. see below
>
>
> e.g.
> bash-3.2# mount | grep hadoop_data
> /dev/mapper/vg0-data on /hadoop_data type ext4
> (rw,noatime,barrier=3D0,journal_checksum)
> bash-3.2# mount | grep hadoop_data
> /dev/mapper/vg0-data on /hadoop_data type ext4
> (rw,noatime,barrier=3D0,journal_checksum)
> bash-3.2# du -h /hadoop_data/ | tail -1
> 328G=A0=A0=A0 /hadoop_data/
> bash-3.2# df -h /hadoop_data/
> Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
> /dev/mapper/vg0-data=A0 745G=A0 592G=A0 117G=A0 84% /hadoop_data
>
> =A0=A0=A0=A0=A0=A0=A0=A0 After unmount + mount, I find this
>
> bash-3.2# umount /hadoop_data/
> bash-3.2# mount /hadoop_data/
> bash-3.2# df -h /hadoop_data/
> Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
> /dev/mapper/vg0-data=A0 745G=A0 328G=A0 380G=A0 47% /hadoop_data
>
>
>
>
>
> Version-Release number of selected component (if applicable):
>
> RHEL (CentOS) 5.5 with kernel=A0=A0 2.6.18-194.17.4.el5=A0 and ext4.
>
>
> How reproducible:
> =A0All the time.
>
>
>
> Steps to Reproduce:
> =A0 Have a program
> 1.=A0 Open a file on ext4 partition
> 2. Fallocate space for that file=A0 say 20 GB
> 3. Write data to the file=A0 (but less than the allocated space) say =
10 GB
> 4. Close the file
> 5. Call truncate(file-path, size+1), truncate(file-path,size) on that=
 file
> to
> give up the space (observed that the space is given up using filefrag=
)
> 6. Use du and df on that ext4 partition to find that the mismatch
>
>
> -George
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
