From: Ming Lei <Ming.Lei@riverbed.com>
Subject: ext4 corruption during unexpected power cycle in the middle of
 writing
Date: Wed, 6 Jun 2012 05:24:16 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA392825CBF@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([208.70.196.44]:50785 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2FFFYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2012 01:24:17 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran the power cycle test during the middle of file writing and after =
bootup, I ran force fsck and found two errors (If I run fsck -p -v I do=
n't see the errors). From what I saw I think it is file system meta dat=
a corruption. Fsck can repair it but each time I ran the same test and =
I hit the same issue.=20

I don't think it is relevant but want to point out that sda6 shares the=
 same drive as another partition on sda(sda3) is used for the raid6 arr=
ay for /var.

The same issue was found whenever barrier is on or off, and the disk dr=
ive write cache is enabled or disabled. The test result shown below is =
when barrier is on and disk write cache is disabled.=20

I use kernel version 2.6.32SL6 version. I also see the same issue on 2.=
6.9 based kernel on the same hardware with ext3 file system.

My question is:
1) Is the issue caused from something unique in my box? Configuration e=
rror?
2) Is it possible my version of fsck reported false errors?
3) Is this a known issue? ? Is it a kernel bug?
4) How do I find what's wrong?
Thanks.

[admin@chief-csa81 ~]# uname -a
Linux chief-csa81 2.6.32 #1 SMP Tue May 29 00:36:37 PDT 2012 x86_64 x86=
_64 x86_64 GNU/Linux
[admin@chief-csa81 ~]# mount
/dev/md1 on /var type ext3 (rw,relatime,user_xattr,acl,barrier=3D1,data=
=3Dordered)
/dev/sda6 on /data type ext4 (rw,nodiratime,relatime,barrier=3D1,data=3D=
ordered)
[admin@chief-csa81 ~]# sdparm /dev/sda
=A0=A0=A0 /dev/sda: ATA=A0=A0=A0=A0=A0=A0 WDC WD5003ABYX-0=A0 1S01
Read write error recovery mode page:
=A0 AWRE=A0=A0=A0=A0=A0=A0=A0 1=A0 [cha: n]
=A0 ARRE=A0=A0=A0=A0=A0=A0=A0 0=A0 [cha: n]
=A0 PER=A0 =A0=A0=A0=A0=A0=A0=A00=A0 [cha: n]
Caching (SBC) mode page:
=A0 WCE=A0=A0=A0=A0=A0=A0=A0=A0 0=A0 [cha: y]
=A0 RCD=A0=A0=A0=A0=A0=A0=A0=A0 0=A0 [cha: n]
Control mode page:
=A0 SWP=A0=A0=A0=A0=A0=A0=A0=A0 0=A0 [cha: n]
Informational exceptions control mode page:
=A0 EWASC=A0=A0=A0=A0=A0=A0 0=A0 [cha: n]
=A0 DEXCPT=A0=A0=A0=A0=A0 0=A0 [cha: n]
=A0 MRIE=A0=A0=A0=A0=A0=A0=A0 6=A0 [cha: n]
[admin@chief-csa81 ~]# cbt -p /data -x 1337 -s 400GB
---------------------------------------------------
Build info
=A0=A0 Version: v2.2.5
=A0=A0 Time: May 29 2012 01:51:41
Runtime info
=A0=A0 Sysname:=A0 Linux
=A0=A0 Nodename: chief-csa81
=A0=A0 Release:=A0 2.6.32
=A0=A0 Version:=A0 #1 SMP Tue May 29 00:36:37 PDT 2012
=A0=A0 Machine:=A0 x86_64
=A0=A0 Time: Tue Jun=A0 5 15:02:55 2012
Invocation
=A0=A0=A0=A0=A0=A0=A0 cbt -p /data -x 1337 -s 400GB
Configuration
=A0 General Options:
=A0=A0=A0=A0=A0 -r,--report-after-bytes=A0=A0 =3D 500MB
=A0=A0=A0=A0=A0 -R,--report-after-seconds =3D 0
=A0 Output Size/Dimensions:
=A0=A0=A0=A0=A0 -p,--output-path=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D /data
=A0=A0=A0=A0=A0 -s,--output-size=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 400GB
=A0=A0=A0=A0=A0 -n,--max-streams=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1
=A0=A0=A0=A0=A0 -S,--output-file-size=A0=A0=A0=A0 =3D 18GB
=A0=A0=A0=A0=A0 -w,--write-size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D
=A0=A0=A0=A0=A0=A0=A0=A0 --oow-max-distance=A0=A0=A0=A0 =3D
=A0 Data Options:
=A0=A0=A0=A0=A0=A0=A0=A0 --data-mode=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
 s
=A0=A0=A0=A0=A0 -x,--random-seed=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1337
=A0=A0=A0=A0=A0 -z,--lz-factor=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 3.5=
425
=A0=A0=A0=A0=A0 -D,--ddup-factor=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1.029
=A0=A0=A0=A0=A0 -c,--churn-pct=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0
=A0=A0=A0=A0=A0 -X,--churn-pct-rand-seed=A0 =3D 1338933774
=A0=A0=A0=A0=A0 -A,--ddup-fanout-algorithm =3D CLUSTERED_RUNS
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-mean-run-size-in-segments =3D 1.3
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-mean-unique-run-size-in-segments =3D 12=
00
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-run-size-multiple =3D 64
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-min-distance-from-last-ddup =3D 120KB
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-min-distance-from-cursor =3D 160MB
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-ave-dist-for-nearby-segs =3D 120KB
=A0=A0=A0=A0=A0=A0=A0=A0 --ddup-random-jump-every-n-ddup-runs =3D 12.63=
44
=A0 Segmentation Options:
=A0=A0=A0=A0=A0=A0=A0=A0 --type=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D rk
=A0=A0=A0=A0=A0=A0=A0=A0 --rk-seg-size-min=A0=A0=A0=A0=A0 =3D 512
=A0=A0=A0=A0=A0=A0=A0=A0 --rk-seg-size-max=A0=A0=A0=A0=A0 =3D 32KB
=A0=A0=A0=A0=A0=A0=A0=A0 --rk-seg-size-ave=A0=A0=A0=A0=A0 =3D 8KB
=A0=A0=A0=A0=A0=A0=A0=A0 --rk-seg-size-dist=A0=A0=A0=A0 =3D exponential
=A0=A0=A0 Number of cut points (-C) being used: 3045800
---------------------------------------------------
Number of files to write: 23

New_file: 0, stream 0,=A0=A0=A0 /data/cbt_output.0, size: 18GB
=A0 Total: 2.284 sec (0:00:02), 500.001 MB, 218.926 MBps - Curr: 2.284 =
sec, 500.001 MB, 218.926 MBps - Tue Jun=A0 5 15:02:57 2012
=A0 Total: 4.822 sec (0:00:04), 1000.002 MB, 207.397 MBps - Curr: 2.538=
 sec, 500.001 MB, 197.022 MBps - Tue Jun=A0 5 15:03:00 2012
=A0 Total: 8.275 sec (0:00:08), 1500.004 MB, 181.263 MBps - Curr: 3.454=
 sec, 500.002 MB, 144.776 MBps - Tue Jun=A0 5 15:03:03 2012
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =A0P=
ower cycle during the writing =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D on next boot, first fsck found 2 errors =
and then next fsck passed =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[admin@chief-csa81 ~]# fsck.ext4 -v -f -y /dev/sda6
e2fsck 1.42 (29-Nov-2011)
/dev/sda6: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
=46ree blocks count wrong (118366120, counted=3D76269471).
=46ix? yes

=46ree inodes count wrong (30081013, counted=3D30081004).
=46ix? yes

/dev/sda6: ***** FILE SYSTEM WAS MODIFIED *****

=A0=A0=A0=A0=A0 20 inodes used (0.00%)
=A0=A0=A0=A0=A0 0 non-contiguous files (0.0%)
=A0=A0=A0=A0=A0=A0 0 non-contiguous directories (0.0%)
=A0=A0=A0=A0=A0=A0=A0=A0 # of inodes with ind/dind/tind blocks: 0/0/0
=A0=A0=A0=A0=A0=A0=A0=A0 Extent depth histogram: 3/9
44035281 blocks used (36.60%)
=A0=A0=A0=A0=A0=A0 0 bad blocks
=A0=A0=A0=A0=A0 10 large files

=A0=A0=A0=A0=A0=A0 9 regular files
=A0=A0=A0=A0=A0=A0 2 directories
=A0=A0=A0=A0=A0=A0 0 character device files
=A0=A0=A0=A0=A0=A0 0 block device files
=A0=A0=A0=A0=A0=A0 0 fifos
=A0=A0=A0=A0=A0=A0 0 links
=A0=A0=A0=A0=A0=A0 0 symbolic links (0 fast symbolic links)
=A0=A0=A0=A0=A0=A0 0 sockets
--------
=A0=A0=A0=A0=A0 11 files

[admin@chief-csa81 ~]# fsck.ext4 -v -f -y /dev/sda6
e2fsck 1.42 (29-Nov-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

=A0=A0=A0=A0=A0 20 inodes used (0.00%)
=A0=A0=A0=A0=A0=A0 0 non-contiguous files (0.0%)
=A0=A0=A0=A0=A0=A0 0 non-contiguous directories (0.0%)
=A0=A0=A0=A0=A0=A0=A0=A0 # of inodes with ind/dind/tind blocks: 0/0/0
=A0=A0=A0=A0=A0=A0=A0=A0 Extent depth histogram: 3/9
44035281 blocks used (36.60%)
=A0=A0=A0=A0=A0=A0 0 bad blocks
=A0=A0=A0=A0=A0 10 large files

=A0=A0=A0=A0=A0=A0 9 regular files
=A0=A0=A0=A0=A0=A0 2 directories
=A0=A0=A0=A0=A0=A0 0 character device files
=A0=A0=A0=A0=A0=A0 0 block device files
=A0=A0=A0=A0=A0=A0 0 fifos
=A0=A0=A0=A0=A0=A0 0 links
=A0=A0=A0=A0=A0=A0 0 symbolic links (0 fast symbolic links)
=A0=A0=A0=A0=A0=A0 0 sockets
--------
=A0=A0=A0=A0=A0 11 files


=3D=3D=3D=3D=3D=3D Hardware Info =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The box has 2 Quad-Core AMD Opteron(tm) Processor 2378 stepping 02 and =
LSI sata controller.

=46usion MPT base driver 4.28.00.00
Copyright (c) 1999-2010 LSI Corporation
=46usion MPT SPI Host driver 4.28.00.00
=46usion MPT SAS Host driver 4.28.00.00
ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 17
mptsas 0000:02:00.0: PCI INT A -> Link[LNEC] -> GSI 17 (level, low) -> =
IRQ 17
mptbase: ioc0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total memory =3D=
 8114680 kB
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1068E B2: Capabilities=3D{Initiator}
scsi0 : ioc0: LSISAS1068E B2, FwRev=3D011f0000h, Ports=3D1, MaxQ=3D277,=
 IRQ=3D17
mptsas: ioc0: add expander: num_phys 12, sas_addr (0x3000000403f)
mptsas: ioc0: add expander: num_phys 12, sas_addr (0x3000000427f)
mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 37, phy 0, sas=
_addr 0x30000004030
scsi target0:0:0: mptsas: ioc0: add device: fw_channel 0, fw_id 37, phy=
 0, sas_addr 0x30000004030scsi 0:0:0:0: Direct-Access=A0=A0=A0=A0 ATA=A0=
=A0=A0=A0=A0 WDC WD5003ABYX-0 1S01 PQ: 0 ANSI: 5
scsi 0:0:0:0: mptscsih: ioc0: qdepth=3D64, tagged=3D1, simple=3D1, orde=
red=3D0, scsi_level=3D6, cmd_que=3D1
sdev dma_alignment 511
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't su=
pport DPO or FUA
sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
