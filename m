From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 10:02:14 -0500
Message-ID: <4BC87BF6.2040104@redhat.com>
References: <20100416123526.GW21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-driver@qlogic.com,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0DPPCg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:02:36 -0400
In-Reply-To: <20100416123526.GW21495@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/16/2010 07:35 AM, Andre Noll wrote:
> Hi
> 
> I'm seeing the following errors when writing to an ext4 file system:
> 
> 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
> 	end_request: I/O error, dev sda, sector 7812771880

Sounds like a hardware failure

> 	Aborting journal on device sda-8.
> 	EXT4-fs (sda): delayed block allocation failed for inode 752 at logical offset 1982464 with max blocks 17588 with error -30
> 
> 	This should not happen!!  Data will be lost

ext4 is just the messenger here, I think.

-Eric

> 	EXT4-fs error (device sda) in ext4_da_writepages: Journal has aborted
> 	EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journal
> 	EXT4-fs (sda): Remounting filesystem read-only
> 	EXT4-fs (sda): delayed block allocation failed for inode 756 at logical offset 177656 with max blocks 1205 with error -30
> 	EXT4-fs error (device sda) in ext4_da_write_end: IO failure
> 
> 	This should not happen!!  Data will be lost
> 	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 1205 pages, ino 756; err -30
> 
> 	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 17588 pages, ino 752; err -30
> 
> 	EXT4-fs (sda): delayed block allocation failed for inode 755 at logical offset 669696 with max blocks 3268 with error -30
> 
> 	This should not happen!!  Data will be lost
> 	EXT4-fs (sda): ext4_da_writepages: jbd2_start: 3268 pages, ino 755; err -30
> 
> This happened while stress-testing the machine [1] with
> 
> 	stress -d 5 --hdd-bytes 10G --hdd-noclean
> 
> This command is supposed to fill the disk and then exit with "no space
> left". Instead, the above errors occured when the fs was 100% full.
> There's nothing in the logs of the Raid system.
> 
> Is this a known issue? Who's to blame, qla2xxx or ext4?
> 
> Thanks
> Andre
> 
> [1] Vanilla 2.6.34-rc4, a 7.3T ext4 fs on a FC Infortrend hardware
> raid, connected to a qlogic hba. Let me know if you need more info.

