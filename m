From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Weird jbd2 I/O load
Date: Wed, 16 Oct 2013 00:41:13 +0300
Message-ID: <525DB679.4070008@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gts6.roserve.net ([128.140.230.209]:42519 "EHLO
	gts6.roserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622Ab3JOWSA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Oct 2013 18:18:00 -0400
Received: from 5-13-211-235.residential.rdsnet.ro ([5.13.211.235]:52932 helo=[127.0.0.1])
	by gts6.roserve.net with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <andrei.banu@redhost.ro>)
	id 1VWCMb-0006Vv-M5
	for linux-ext4@vger.kernel.org; Wed, 16 Oct 2013 00:41:13 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

First off let me state that my level of knowledge and expertise is in no 
way a match for that of the people on this list. I am not even sure if 
what I want to ask is in any way related to my problem or it's just a 
side effect (or even plain irrelevant).

I am trying to identify the source of the problems I face with an 
mdraid-1 built with 2 Samsung 840 Pro SSDs. The filesystem is ext-4. I 
face many problems with this array:

- write speeds around 10MB/s and serious server overloads (loads of 20 
to 100 - this is a quad core CPU) when copying larger files (100+ MBs):
root [~]# time dd if=arch.tar.gz of=test4 bs=2M oflag=sync
146+1 records in
146+1 records out
307191761 bytes (307 MB) copied, 23.6788 s, 13.0 MB/s
real    0m23.680s
user    0m0.000s
sys     0m0.932s

- asymmetrical wear on the 2 SSDs (one SSD has a wear of 6% while the 
other has a wear of 30%):
root [~]# smartctl --attributes /dev/sda | grep -i wear
177 Wear_Leveling_Count     0x0013   094%   094   000    Pre-fail 
Always       -       196
root [~]# smartctl --attributes /dev/sdb | grep -i wear
177 Wear_Leveling_Count     0x0013   070%   070   000    Pre-fail 
Always       -       1073

- very asymmetrical await, svctm and %util in iostat when copying larger 
files (100+ MB):
Device:         rrqm/s   wrqm/s     r/s     w/s         rsec/s 
wsec/s       avgrq-sz   avgqu-sz   await        svctm   %util
sda               0.00        1589.50    0.00   54.00     0.00 
13148.00   243.48     0.60           11.17       0.46      2.50
sdb               0.00        1627.50    0.00   16.50     0.00 
9524.00     577.21     144.25       1439.33  60.61   100.00
md1             0.00        0.00           0.00    0.00 0.00     
0.00             0.00        0.00            0.00 0.00      0.00
md2             0.00        0.00           0.00    1602     0.00 
12816.00     8.00        0.00            0.00         0.00      0.00
md0             0.00        0.00           0.00    0.00      0.00 
0.00             0.00        0.00             0.00         0.00 0.00

- asymmetrical total LBA written but much lower than the above:
root [~]# smartctl --attributes /dev/sda | grep "Total_LBAs_Written"
241 Total_LBAs_Written      0x0032   099   099   000    Old_age 
Always       -       23628284668
root [~]# smartctl --attributes /dev/sdb | grep "Total_LBAs_Written"
241 Total_LBAs_Written      0x0032   099   099   000    Old_age 
Always       -       25437073579
(the gap seems to be getting narrower and narrower here though - it 
seems some event in the past caused this)


And the number one reason I am trying for help on this list:
root # iotop -o
Total DISK READ: 247.78 K/s | Total DISK WRITE: 495.56 K/s
TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
534 be/3 root        0.00 B/s   55.06 K/s  0.00 % 99.99 % [jbd2/md2-8]
....

When there are problems, jbd2 seems to do 99.9%  I/O without doing any 
apparent significant reads or writes. It seems like jbd2 just keeps the 
devices busy.

What could be the reason of some of the above anomalies? Especially why 
is jbd2 keeping the raid members busy while not doing any reads or 
writes? Why the abysmal write speed?

So far I have updated the SSDs firmware, checked the alignment which 
seems ok (1MB boundary), checked with all 3 schedulers, the swap is on 
an md device (so the asymmetrical use and wear again can't be 
explained), I have looked for "hard resetting link" in dmesg but found 
nothing so I guess it's not a cable or back plane issue). What else can 
I check? What else can I try?

Kind regards!
