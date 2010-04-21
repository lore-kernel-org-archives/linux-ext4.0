From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Wed, 21 Apr 2010 12:57:56 +0400
Message-ID: <87ljch5giz.fsf@openvz.org>
References: <20100416123526.GW21495@skl-net.de>
	<20100416163654.GD58339@plapa.qlogic.org>
	<20100416170707.GB25507@skl-net.de>
	<201004171855.36874.bernd.schubert@fastmail.fm>
	<4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de>
	<20100420153723.GE25507@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:51197 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0DUI6C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 04:58:02 -0400
Received: by bwz25 with SMTP id 25so7794304bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 01:58:00 -0700 (PDT)
In-Reply-To: <20100420153723.GE25507@skl-net.de> (Andre Noll's message of
	"Tue, 20 Apr 2010 17:37:23 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andre Noll <maan@systemlinux.org> writes:

> On 00:38, Andre Noll wrote:
>> > I still don't think it's likely a filesystem problem but maybe you can
>> > pinpoint the fs behavior that triggers it.
>> 
>> I'll try to reproduce the problem using different timeout values and the
>> ext4 options you suggest. If I can find a reliable reproducer, I'll run
>> blktrace and post the results.
>
> Here are some results. Prior to running the tests I wrote a bunch of
> 10G files and then filled the fs completely with 2T files containing
> zeros.  Each of the tests below consisted of three runs of
>
> 	- remove 5 of the above 10G files to make 50G space available
> 	- run stress -d 5 --hdd-bytes 10G --hdd-noclean until it dies
what 'stress' process do?  was it posted already?
> 	- run fsck if any fs errors occured
>
> Summary: Increasing the device timeout to 60s _or_ disabling barriers
> makes the problem go away. Deactivating delayed allocation makes the
> problem worse.
2Gb cache is really huge.
barriers=0 , result in less disk wcache activity, but more real IO
And nodelaloc result in more real IO due, so imho this is looks like
device issue.
about nodelalloc: It is unlikely to see "This should not happen!! 
Data will be lost" because this message appear from writepage
so may happens only when you rewrite an existing file(below i_size).
BTW, you already noted that you have performed some stress on the device
without filesystem. What was they doing?
IMHO you will able to reproduce the issue without fs by performing
random writes/reads to the device from several tasks in parallel.
>
> - device timeout 60s, default ext4 parameters
> 	No problems at all, all three runs OK
>
> - device timeout 30s, default ext4 parameters
> 	1. OK
> 	2. dmesg:
> 		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ea270b 2002.
> 		end_request: I/O error, dev sda, sector 7812889640
> 		Aborting journal on device sda-8.
> 		EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journal
> 		EXT4-fs (sda): Remounting filesystem read-only
>
> 	fsck:
> 			Inode 287, i_blocks is 4294918568, should be 416.  Fix? yes
> 			Inode 288, i_size is 2198897426432, should be 2199023251456.  Fix? yes
> 			Inode 288, i_blocks is 4294721960, should be 416.  Fix? yes
>
> 	3.
> 		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ece6a8 2002.
> 		qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 2ece6dc 2002.
> 		end_request: I/O error, dev sda, sector 7812690136
> 		Aborting journal on device sda-8.
> 		EXT4-fs error (device sda) in ext4_free_blocks: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_ext_remove_space: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_ext_truncate: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_orphan_del: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_reserve_inode_write: Journal has aborted
> 		EXT4-fs error (device sda) in ext4_delete_inode: Journal has aborted
> 		EXT4-fs error (device sda): ext4_journal_start_sb: Detected aborted journal
> 		EXT4-fs (sda): Remounting filesystem read-only
>
> 		fsck:
> 			e2fsck 1.41.10 (10-Feb-2009)
> 			/dev/sda: recovering journal
> 			Clearing orphaned inode 179 (uid=0, gid=0, mode=0100600, size=0)
> 			/dev/sda: clean, 301/244158464 files, 1935004235/1953247232 blocks
>
>
> - device timeout 30s, nodelalloc
>
> 	This seems to trigger the problem more reliably:
>
> 	1.
> 		dmesg: same qla, ext4 errors as above
> 		fsck: orphaned inodes as above
> 	2. and 3.
> 		errors already while removing files:
> 			rm: cannot remove `stress.98q1gG': Read-only file system
> 		dmesg: same qla/ext4 errors, but also
> 			JBD2: Detected IO errors while flushing file data on sda-8
> 		fsck: clean
>
> - device timeout 30s, nobarrier
> 	No problem at all, all three runs OK.
>
> Eric, are you still interested in seeing the blktrace output? Suppose,
> I should use a 30s timeout, nodealloc and barriers=1 as this triggers
> the problem within minutes.
>
>
> Regards
> Andre
