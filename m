From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: debuge2fs not displaying /dev folder
Date: Tue, 15 Jan 2013 11:31:53 +0530
Message-ID: <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54133 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AOGCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 01:02:14 -0500
Received: by mail-ea0-f179.google.com with SMTP id i12so1965659eaa.10
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 22:02:13 -0800 (PST)
In-Reply-To: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When using debuge2fs on a ext3 partition the /dev partition does not
show any entries at all. While running it on a ext4 partition only
part of entries are shown for /dev.

Below is the list of files and folder within /dev folder residing on a
ext4 partition. Using "debugfs" shows around 92 entries while "ls"
shows around 217 entries. A block level dump also shows the same
folders as "debugfs".

--------------------- debugfs --------------------
 3014659  (12) .    2  (12) ..    3014663  (12) fd    3014664  (16) mapper
 3014665  (12) pts    3014666  (12) shm    3014667  (16) agpgart
 3014668  (16) audio    3014669  (16) audio1    3014670  (16) audio2
 3014671  (16) audio3    3014672  (16) audioctl    3014673  (16) console
 3014674  (12) core    3014675  (12) dsp    3014676  (12) dsp1
 3014677  (12) dsp2    3014678  (12) dsp3    3014679  (12) full
 3014680  (12) fuse    3014681  (12) kmem    3014682  (16) loop0
 3014683  (16) loop1    3014684  (16) loop2    3014685  (16) loop3
 3014686  (16) loop4    3014687  (16) loop5    3014688  (16) loop6
 3014689  (16) loop7    3014690  (12) mem    3014691  (16) midi0
 3014692  (16) midi00    3014693  (16) midi01    3014694  (16) midi02
 3014695  (16) midi03    3014696  (16) midi1    3014697  (16) midi2
 3014698  (16) midi3    3014699  (16) mixer    3014700  (16) mixer1
 3014701  (16) mixer2    3014702  (16) mixer3    3014703  (20) mpu401data
 3014704  (20) mpu401stat    3014705  (12) null    3014706  (12) port
 3014707  (12) ptmx    3014708  (12) ram    3014709  (12) ram0
 3014710  (12) ram1    3014711  (16) ram10    3014712  (16) ram11
 3014713  (16) ram12    3014714  (16) ram13    3014715  (16) ram14
 3014716  (16) ram15    3014717  (16) ram16    3014718  (12) ram2
 3014719  (12) ram3    3014720  (12) ram4    3014721  (12) ram5
 3014722  (12) ram6    3014723  (12) ram7    3014724  (12) ram8
 3014725  (12) ram9    3014726  (16) random    3014727  (16) rmidi0
 3014728  (16) rmidi1    3014729  (16) rmidi2    3014730  (16) rmidi3
 3014731  (20) sequencer    3014732  (16) smpte0    3014733  (16) smpte1
 3014734  (16) smpte2    3014735  (16) smpte3    3014736  (16) sndstat
 3014737  (16) stderr    3014738  (16) stdin    3014739  (16) stdout
 3014740  (12) tty    3014741  (12) tty0    3014742  (12) tty1
 3014743  (12) tty2    3014744  (12) tty3    3014745  (12) tty4
 3014746  (12) tty5    3014747  (12) tty6    3014748  (12) tty7
 3014749  (12) tty8    3014750  (12) tty9    3014751  (16) urandom
 3014752  (2784) zero

--------- from ls -----------
autofs           ecryptfs  loop6               pts    random    sr0
 tty2   tty35  tty50  tty9       ttyS22  uinput      vcsa2
block            fb0       loop7               ram0   rfkill    stderr
 tty20  tty36  tty51  ttyprintk  ttyS23  urandom     vcsa3
bsg              fd        loop-control        ram1   rtc       stdin
 tty21  tty37  tty52  ttyS0      ttyS24  usbmon0     vcsa4
btrfs-control    full      lp0                 ram10  rtc0      stdout
 tty22  tty38  tty53  ttyS1      ttyS25  usbmon1     vcsa5
bus              fuse      mapper              ram11  sda       tty
 tty23  tty39  tty54  ttyS10     ttyS26  usbmon2     vcsa6
cdrom            hidraw0   mcelog              ram12  sda1      tty0
 tty24  tty4   tty55  ttyS11     ttyS27  vboxdrv     vg
cdrw             hpet      mem                 ram13  sda2      tty1
 tty25  tty40  tty56  ttyS12     ttyS28  vboxnetctl  vga_arbiter
char             input     net                 ram14  sda3      tty10
 tty26  tty41  tty57  ttyS13     ttyS29  vboxusb     zero
console          kmsg      network_latency     ram15  sda4      tty11
 tty27  tty42  tty58  ttyS14     ttyS3   vcs
core             kvm       network_throughput  ram2   sda5      tty12
 tty28  tty43  tty59  ttyS15     ttyS30  vcs1
cpu              log       null                ram3   sda6      tty13
 tty29  tty44  tty6   ttyS16     ttyS31  vcs2
cpu_dma_latency  loop0     oldmem              ram4   sda7      tty14
 tty3   tty45  tty60  ttyS17     ttyS4   vcs3
disk             loop1     parport0            ram5   sg0       tty15
 tty30  tty46  tty61  ttyS18     ttyS5   vcs4
dm-0             loop2     port                ram6   sg1       tty16
 tty31  tty47  tty62  ttyS19     ttyS6   vcs5
dri              loop3     ppp                 ram7   shm       tty17
 tty32  tty48  tty63  ttyS2      ttyS7   vcs6
dvd              loop4     psaux               ram8   snapshot  tty18
 tty33  tty49  tty7   ttyS20     ttyS8   vcsa
dvdrw            loop5     ptmx                ram9   snd       tty19
 tty34  tty5   tty8   ttyS21     ttyS9   vcsa1

Regards.
