From: Tao Ma <tm@tao.ma>
Subject: Re: Quick EXT4 discard question
Date: Fri, 22 Apr 2011 10:53:37 +0800
Message-ID: <4DB0EDB1.2070506@tao.ma>
References: <1303433101.1389.132.camel@keith-laptop>	 <4DB0E7AA.6070007@tao.ma> <1303440294.1389.136.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:44891 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753464Ab1DVCxz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Apr 2011 22:53:55 -0400
In-Reply-To: <1303440294.1389.136.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/22/2011 10:44 AM, Keith Mannthey wrote:
> On Fri, 2011-04-22 at 10:27 +0800, Tao Ma wrote:
>> On 04/22/2011 08:45 AM, Keith Mannthey wrote:
>>> Hello,
>>>   I am using some Intel SSD drives with 2.6.38.2. 
>>>
>>>
>>> /proc/scsi/scsi identifies them as: 
>>>
>>> "
>>> Host: scsi4 Channel: 00 Id: 04 Lun: 00
>>>   Vendor: ATA      Model: INTEL SSDSA2M080 Rev: 02M3
>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>> "
>>>
>>> Sometimes I am see the following messages that indicate discard is
>>> disabled during runtime:  
>>>
>>> Relevant dmesg:
>>>
>>> ...
>>> EXT4-fs (sdw): mounted filesystem with ordered data mode. Opts: nobarrier,discard
>>> EXT4...... 
>>>
>>> .... (some time later) 
>>>
>>> EXT4-fs warning (device sdw): release_blocks_on_commit:2672: discard not supported, disabling
>>> EXT4-fs warning (device sds): release_blocks_on_commit:2672: discard not supported, disabling
>>> EXT4-fs warning (device sdt): release_blocks_on_commit:2672: discard not supported, disabling
>>> EXT4-fs warning (device sdu): release_blocks_on_commit:2672: discard not supported, disabling
>>> EXT4-fs warning (device sdv): release_blocks_on_commit:2672: discard not supported, disabling
>> Please check whether your ssd works with discard or whether your ssd
>> firmware has the ability to do so.
>> I used an SSDSA2M160(I guess you are using the same type as me except
>> the volume size is 80g, but you have to find it out from intel side) and
>> after I upgraded my firmware to the new version(you can download it from
>> intel site), it supports discard now.
> 
> 
> Firmware is up to date as of a few weeks ago.  It is 02M3 which still
> looks to be the current version. 
ok...
So please check whether your device supports discard or not.
Intel has a tool named Intel SSD Toolbox, and it can check the status of
your ssd, but the bad thing is that it seems to only have a windows
version...

Regards,
Tao
