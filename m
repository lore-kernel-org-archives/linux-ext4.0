From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 21:57:00 GMT
Message-ID: <201006022157.o52Lv0WV031337@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54344 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0FBV5B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 17:57:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52Lv0eV031339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 21:57:00 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #13 from lkolbe@techfak.uni-bielefeld.de  2010-06-02 21:56:56 ---
Funny thing is, dm-6 is the root-filesystem, and it's 4GB big. It lives on a VG
consisting of one 100GB RAID-50 over 24 disks. Some relevant data:

shepherd:~# lvm lvs -a -o+devices
  LV          VG     Attr   LSize   Origin Snap%  Move Log Copy%  Convert
Devices          
  badp1       data   -wi-ao   9.00T                                      
/dev/sdb(25600)  
  badp2       data   -wi-ao   9.00T                                      
/dev/sdb(2384896)
  baspool     data   -wi-ao   1.00T                                      
/dev/sdb(4769792)
  bawork      data   -wi-ao 100.00G                                      
/dev/sdb(0)      
  db1_srv     data   -wi-ao 100.00G                                      
/dev/sdb(4744192)
  dir1_bawork data   -wi-ao 100.00G                                      
/dev/sdb(5031936)
  db1_log     system -wi-ao   4.00G                                      
/dev/sda1(7168)  
  db1_root    system -wi-ao   4.00G                                      
/dev/sda1(6144)  
  db1_swap    system -wi-ao   4.00G                                      
/dev/sda1(8192)  
  dir1_log    system -wi-ao   4.00G                                      
/dev/sda1(4096)  
  dir1_root   system -wi-ao   4.00G                                      
/dev/sda1(3072)  
  dir1_swap   system -wi-ao   4.00G                                      
/dev/sda1(5120)  
  log         system -wi-ao   4.00G                                      
/dev/sda1(1024)  
  root        system -wi-ao   4.00G                                      
/dev/sda1(0)     
  swap        system -wi-ao   4.00G                                      
/dev/sda1(2048)  

The requested dmsetup table:
shepherd:~# dmsetup table
data-dir1_bawork: 0 209715200 linear 8:16 41221620096
system-db1_log: 0 8388608 linear 8:1 58720640
system-db1_swap: 0 8388608 linear 8:1 67109248
system-db1_root: 0 8388608 linear 8:1 50332032
data-bawork: 0 209715200 linear 8:16 384
data-db1_srv: 0 209715200 linear 8:16 38864421248
data-baspool: 0 2147483648 linear 8:16 39074136448
system-dir1_swap: 0 8388608 linear 8:1 41943424
system-dir1_root: 0 8388608 linear 8:1 25166208
data-badp2: 0 19327352832 linear 8:16 19537068416
data-badp1: 0 19327352832 linear 8:16 209715584
system-swap: 0 8388608 linear 8:1 16777600
system-root: 0 8388608 linear 8:1 384
system-dir1_log: 0 8388608 linear 8:1 33554816
system-log 0 8388608 linear 8:1 8388992

Adaptec version numbers are: BIOS, Firmware, Boot flash: 17899
aacraid driver: 2461 (the version shipped with 2.6.32)

I have (yet) no reason not to trust our storage - it's one 100GB RAID-50 and
one ~19TB RAID-50 on 24 Hitachi HDE721010SLA330 with firmware ST6OA3AA, if that
means anything to anyone.

Since the last crash bacula has written 3.2TiB to data-badp1 and it's still
running (when all backups are done, it should have written ~12TiB). We'll see
if it survives tomorrow.

If it crashes again, I'll try 8TiB-Filesystems.

Thanks for taking your time!
Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
