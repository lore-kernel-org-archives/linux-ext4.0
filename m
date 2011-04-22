From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: Quick EXT4 discard question
Date: Thu, 21 Apr 2011 19:44:54 -0700
Message-ID: <1303440294.1389.136.camel@keith-laptop>
References: <1303433101.1389.132.camel@keith-laptop>
	 <4DB0E7AA.6070007@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53893 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1DVCo4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 22:44:56 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3M2YE01026811
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 22:34:14 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3M2isNx553200
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 22:44:55 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3M2isYS025773
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 22:44:54 -0400
In-Reply-To: <4DB0E7AA.6070007@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-04-22 at 10:27 +0800, Tao Ma wrote:
> On 04/22/2011 08:45 AM, Keith Mannthey wrote:
> > Hello,
> >   I am using some Intel SSD drives with 2.6.38.2. 
> > 
> > 
> > /proc/scsi/scsi identifies them as: 
> > 
> > "
> > Host: scsi4 Channel: 00 Id: 04 Lun: 00
> >   Vendor: ATA      Model: INTEL SSDSA2M080 Rev: 02M3
> >   Type:   Direct-Access                    ANSI  SCSI revision: 05
> > "
> > 
> > Sometimes I am see the following messages that indicate discard is
> > disabled during runtime:  
> > 
> > Relevant dmesg:
> > 
> > ...
> > EXT4-fs (sdw): mounted filesystem with ordered data mode. Opts: nobarrier,discard
> > EXT4...... 
> > 
> > .... (some time later) 
> > 
> > EXT4-fs warning (device sdw): release_blocks_on_commit:2672: discard not supported, disabling
> > EXT4-fs warning (device sds): release_blocks_on_commit:2672: discard not supported, disabling
> > EXT4-fs warning (device sdt): release_blocks_on_commit:2672: discard not supported, disabling
> > EXT4-fs warning (device sdu): release_blocks_on_commit:2672: discard not supported, disabling
> > EXT4-fs warning (device sdv): release_blocks_on_commit:2672: discard not supported, disabling
> Please check whether your ssd works with discard or whether your ssd
> firmware has the ability to do so.
> I used an SSDSA2M160(I guess you are using the same type as me except
> the volume size is 80g, but you have to find it out from intel side) and
> after I upgraded my firmware to the new version(you can download it from
> intel site), it supports discard now.


Firmware is up to date as of a few weeks ago.  It is 02M3 which still
looks to be the current version. 

Thanks,
  Keith 

