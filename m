Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from shells.gnugeneration.com ([66.240.222.126]:51858 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbeK1NIC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2018 08:08:02 -0500
Date: Tue, 27 Nov 2018 17:57:58 -0800
From: Vito Caputo <vcaputo@pengaru.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Rainer Fiebig <jrf@mailbox.org>, linux-kernel@vger.kernel.org,
        grendel@twistedcode.net, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Message-ID: <20181128015758.ay62cpghjakh4i46@shells.gnugeneration.com>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <5d94f857-b31d-a02c-5a20-2796076f447e@twistedcode.net>
 <2157925.3ZPi3Rj3bs@siriux>
 <20181127212255.GA2987@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127212255.GA2987@roeck-us.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2018 at 01:22:55PM -0800, Guenter Roeck wrote:
> On Tue, Nov 27, 2018 at 07:55:01PM +0100, Rainer Fiebig wrote:
> > Am Dienstag, 27. November 2018, 15:48:19 schrieb Marek Habersack:
> > > On 27/11/2018 15:32, Guenter Roeck wrote:
> > > Hi,
> > > 
> > > You might try to see if you have CONFIG_SCSI_MQ_DEFAULT=yes in your kernel
> > > config. Starting with 4.19.1 it somehow interferes with ext4 and causes
> > > problems similar to the ones you list below. Ever since I disabled MQ
> > > (either recompile your kernel or add `scsi_mod.use_blk_mq=0` to the kernel
> > > command line) none of those errors came back.
> > > 
> > > hope it helps,
> > > 
> > > marek
> > 
> > Unfortunately, this doesn't seem to work in every case: 
> > https://bugzilla.kernel.org/show_bug.cgi?id=201685#c54
> > 
> > And I'm using a defconfig-4.19.3 (meaning: CONFIG_SCSI_MQ_DEFAULT=yes) in a VM 
> > and I'm not seeing those errors there. OK, it's a VM - but anyway.
> > 
> 
> Agreed. I disabled CONFIG_SCSI_MQ_DEFAULT, but the problem is still seen
> at least on one of my servers, so disabling it does not help, at least not
> in my case.
> 
> If the problem is somehow related to CONFIG_SCSI_MQ_DEFAULT, you might
> have to explicitly use a scsi drive (virtio-scsi-pci or similar) to
> trigger its use in a VM.
> 
> Guenter
> 
> > The definite cause of this can only be found by bisecting, IMO. And it needs 
> > to be pinned down because else some feeling of insecurity will remain.
> > 
> > So long!
> > 
> > Rainer Fiebig
> > 
> > > 
> > > > [trying again, this time with correct kernel.org address]
> > > > 
> > > > Hi,
> > > > 
> > > > I have seen the following and similar problems several times,
> > > > with both v4.19.3 and v4.19.4:
> > > > 
> > > > Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device sdb1):
> > > > ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (inode
> > > > size 256)
> > > > Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on device
> > > > sdb1-8. Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1):
> > > > Remounting filesystem read-only Nov 23 04:32:25 mars kernel:
> > > > [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode
> > > > #12602881: comm rm: bad extra_isize 33685 (inode size 256)
> > > > ...
> > > > 
> > > > Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device sda1):
> > > > ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted inode
> > > > referenced: 238160407
> > > > Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on device
> > > > sda1-8. Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1):
> > > > Remounting filesystem read-only ...
> > > > 
> > > > Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device
> > > > sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode
> > > > referenced: 52043796
> > > > Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on device
> > > > sda1-8. Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda1):
> > > > Remounting filesystem read-only
> > > > 
> > > > 
> > > > The same systems running v4.18.6 never experienced a problem.
> > > > 
> > > > Has anyone else seen similar problems ? Is there anything I can do
> > > > to help tracking down the problem ?
> > > > 
> > > > Thanks,
> > > > Guenter
> > 


Not sure how relevant this is, but I had emailed the list earlier in the
month reporting totally bogus fs/SATA errors following an fstrim in
4.19.  I didn't have much information to add, as the logs were all lost,
and I didn't have any interest in trying to reproduce it on my daily
driven laptop.

I've just been running 4.17 since then (4.18 has some annoying i915 drm
bugs), and things have been perfectly fine in the storage/filesystem
department.

What I had noticed as being suspect back then was the following:

$ git tag --contains 744889b7cbb56a6
v4.19
v4.19.1
v4.19.2
v4.19.3
v4.19.4
v4.19.5
v4.20-rc1
v4.20-rc2
v4.20-rc3
v4.20-rc4
$ git tag --contains 1adfc5e4136f5967
v4.20-rc2
v4.20-rc3
v4.20-rc4
$

Since the 744889b7 commit message talks specifically about discard, and
1adfc5e4 claims to fix 744889b7, I assumed it was probably responsible
considering the tags profile, but did not try understand the commits or
bisect.

FYI the machine I observed this on is a SATA-attached SSD (Samsung 840
EVO 250G) X61s.  I only run fstrim manually, but of course with discard
enabled all the way down the lvm+dmcrypt stack.

Maybe that's of use in hunting down this bug.  If nobody else bisects in
the coming weeks I'll have to reconsider the rigamarole of backups,
repro, and attempting a bisect.

Regards,
Vito Caputo
