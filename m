Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34035 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbeK1IWK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2018 03:22:10 -0500
Date: Tue, 27 Nov 2018 13:22:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Rainer Fiebig <jrf@mailbox.org>
Cc: linux-kernel@vger.kernel.org, grendel@twistedcode.net,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Message-ID: <20181127212255.GA2987@roeck-us.net>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
 <2157925.3ZPi3Rj3bs@siriux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2157925.3ZPi3Rj3bs@siriux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 07:55:01PM +0100, Rainer Fiebig wrote:
> Am Dienstag, 27. November 2018, 15:48:19 schrieb Marek Habersack:
> > On 27/11/2018 15:32, Guenter Roeck wrote:
> > Hi,
> > 
> > You might try to see if you have CONFIG_SCSI_MQ_DEFAULT=yes in your kernel
> > config. Starting with 4.19.1 it somehow interferes with ext4 and causes
> > problems similar to the ones you list below. Ever since I disabled MQ
> > (either recompile your kernel or add `scsi_mod.use_blk_mq=0` to the kernel
> > command line) none of those errors came back.
> > 
> > hope it helps,
> > 
> > marek
> 
> Unfortunately, this doesn't seem to work in every case: 
> https://bugzilla.kernel.org/show_bug.cgi?id=201685#c54
> 
> And I'm using a defconfig-4.19.3 (meaning: CONFIG_SCSI_MQ_DEFAULT=yes) in a VM 
> and I'm not seeing those errors there. OK, it's a VM - but anyway.
> 

Agreed. I disabled CONFIG_SCSI_MQ_DEFAULT, but the problem is still seen
at least on one of my servers, so disabling it does not help, at least not
in my case.

If the problem is somehow related to CONFIG_SCSI_MQ_DEFAULT, you might
have to explicitly use a scsi drive (virtio-scsi-pci or similar) to
trigger its use in a VM.

Guenter

> The definite cause of this can only be found by bisecting, IMO. And it needs 
> to be pinned down because else some feeling of insecurity will remain.
> 
> So long!
> 
> Rainer Fiebig
> 
> > 
> > > [trying again, this time with correct kernel.org address]
> > > 
> > > Hi,
> > > 
> > > I have seen the following and similar problems several times,
> > > with both v4.19.3 and v4.19.4:
> > > 
> > > Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device sdb1):
> > > ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (inode
> > > size 256)
> > > Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on device
> > > sdb1-8. Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1):
> > > Remounting filesystem read-only Nov 23 04:32:25 mars kernel:
> > > [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode
> > > #12602881: comm rm: bad extra_isize 33685 (inode size 256)
> > > ...
> > > 
> > > Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device sda1):
> > > ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted inode
> > > referenced: 238160407
> > > Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on device
> > > sda1-8. Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1):
> > > Remounting filesystem read-only ...
> > > 
> > > Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device
> > > sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode
> > > referenced: 52043796
> > > Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on device
> > > sda1-8. Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda1):
> > > Remounting filesystem read-only
> > > 
> > > 
> > > The same systems running v4.18.6 never experienced a problem.
> > > 
> > > Has anyone else seen similar problems ? Is there anything I can do
> > > to help tracking down the problem ?
> > > 
> > > Thanks,
> > > Guenter
> 
> -- 
> The truth always turns out to be simpler than you thought.
> Richard Feynman
