From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Quick EXT4 discard question
Date: Thu, 21 Apr 2011 17:45:01 -0700
Message-ID: <1303433101.1389.132.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55937 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1DVApC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 20:45:02 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3M0MlmK002609
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 20:22:47 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3M0j1RS1151200
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 20:45:01 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3M0j00X007924
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 18:45:00 -0600
Received: from [9.76.192.28] (sig-9-76-192-28.mts.ibm.com [9.76.192.28])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3M0j0Q7007902
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 18:45:00 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
  I am using some Intel SSD drives with 2.6.38.2. 


/proc/scsi/scsi identifies them as: 

"
Host: scsi4 Channel: 00 Id: 04 Lun: 00
  Vendor: ATA      Model: INTEL SSDSA2M080 Rev: 02M3
  Type:   Direct-Access                    ANSI  SCSI revision: 05
"

Sometimes I am see the following messages that indicate discard is
disabled during runtime:  

Relevant dmesg:

...
EXT4-fs (sdw): mounted filesystem with ordered data mode. Opts: nobarrier,discard
EXT4...... 

.... (some time later) 

EXT4-fs warning (device sdw): release_blocks_on_commit:2672: discard not supported, disabling
EXT4-fs warning (device sds): release_blocks_on_commit:2672: discard not supported, disabling
EXT4-fs warning (device sdt): release_blocks_on_commit:2672: discard not supported, disabling
EXT4-fs warning (device sdu): release_blocks_on_commit:2672: discard not supported, disabling
EXT4-fs warning (device sdv): release_blocks_on_commit:2672: discard not supported, disabling

I am new to SSDs and discard is there something else I need to do to
make these drives work as expected? 


Thanks,
  Keith Mannthey 
  LTC Local Filesystem 

