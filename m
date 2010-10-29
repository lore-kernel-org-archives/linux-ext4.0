From: "George Kola" <georgekola@gmail.com>
Subject: ext4 fallocate+truncate not freeing up allocated space
Date: Fri, 29 Oct 2010 11:26:39 -0700
Message-ID: <007a01cb7796$d515da50$7f418ef0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0J2S0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 14:26:34 -0400
Received: by ywk9 with SMTP id 9so2182846ywk.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 11:26:33 -0700 (PDT)
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am using RHEL (CentOS) 5.5 with kernel=A0 2.6.18-194.17.4.el5=A0 and =
ext4. I
posted to RHEL bugzilla and they requested me to post it here.

I wrote a program that fallocates space for a file. It does not know th=
e
file
size apriori and uses a heuristic. If the final file size is less than =
the
allocated space, I free up the extra space with truncate. I found that
freeing
up did not work so I ended up doing two truncates -- truncate(size+1)
followed
by truncate(size) as suggested in
http://kerneltrap.org/mailarchive/linux-ext4/2009/7/21/6243463.=20

I now find that the freed space is not given back till a unmount+ mount=
=2E=20
I detected this by finding disks full even though the used space was le=
sser.

I did the standard tests
1. Stopped all program having handles open to files on that partition
2. Verified with lsof that there are no open handles to files in that
partition
=A0=A0=A0=A0 Still there was a mismatch. e.g. see below


e.g.=20
bash-3.2# mount | grep hadoop_data
/dev/mapper/vg0-data on /hadoop_data type ext4
(rw,noatime,barrier=3D0,journal_checksum)
bash-3.2# mount | grep hadoop_data
/dev/mapper/vg0-data on /hadoop_data type ext4
(rw,noatime,barrier=3D0,journal_checksum)
bash-3.2# du -h /hadoop_data/ | tail -1
328G=A0=A0=A0 /hadoop_data/
bash-3.2# df -h /hadoop_data/
=46ilesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
/dev/mapper/vg0-data=A0 745G=A0 592G=A0 117G=A0 84% /hadoop_data

=A0=A0=A0=A0=A0=A0=A0=A0 After unmount + mount, I find this

bash-3.2# umount /hadoop_data/
bash-3.2# mount /hadoop_data/
bash-3.2# df -h /hadoop_data/
=46ilesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
/dev/mapper/vg0-data=A0 745G=A0 328G=A0 380G=A0 47% /hadoop_data





Version-Release number of selected component (if applicable):

RHEL (CentOS) 5.5 with kernel=A0=A0 2.6.18-194.17.4.el5=A0 and ext4.


How reproducible:
 All the time.



Steps to Reproduce:
=A0 Have a program=20
1.=A0 Open a file on ext4 partition
2. Fallocate space for that file=A0 say 20 GB
3. Write data to the file=A0 (but less than the allocated space) say 10=
 GB
4. Close the file
5. Call truncate(file-path, size+1), truncate(file-path,size) on that f=
ile
to
give up the space (observed that the space is given up using filefrag)
6. Use du and df on that ext4 partition to find that the mismatch


-George



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
