From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Date: Thu, 16 Aug 2012 16:28:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1208161619440.2459@vpn-8-20.rdu.redhat.com>
References: <50238A29.3060808@redhat.com> <20120809170640.GA6607@thunk.org> <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185209864-1526929049-1345127291=:2459"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
	<linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab2HPPVa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2012 11:21:30 -0400
In-Reply-To: <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185209864-1526929049-1345127291=:2459
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 15 Aug 2012, Luká¨ Czerner wrote:

> Date: Wed, 15 Aug 2012 11:17:57 +0200 (CEST)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukas Czerner <lczerner@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
>     "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
>     <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
> Subject: Re: ext4fs error
>     "ext4_mb_generate_buddy:741:group 16, 8160 clusters in bitmap, 4064 in gd"
>      (with repro)
> 
> On Thu, 9 Aug 2012, Theodore Ts'o wrote:
> 
> > Date: Thu, 9 Aug 2012 13:06:40 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>,
> >     "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
> >     <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
> > Subject: Re: ext4fs error
> >     "ext4_mb_generate_buddy:741:group 16, 8160 clusters in bitmap, 4064 in gd"
> >      (with repro)
> > 
> > On Thu, Aug 09, 2012 at 12:00:09PM +0200, Paolo Bonzini wrote:
> > > Here is how to reproduce it.  It happens during fstrim.  I found other
> > > occurrences of the error in the mailing list, but they were not related
> > > to trim so they may be something different.
> > > 
> > > modprobe scsi_debug dev_size_mb=256 lbpws=1
> > > dd if=/dev/zero of=/dev/sdb bs=1M      
> > > fdisk /dev/sdb
> > >  >> create a new partition accepting all defaults
> > > fdisk -lu /dev/sdb|tail -1
> > >  >> should show: /dev/sdb1     57      524285      262114+  83  Linux
> > > 
> > > mkfs.ext4 /dev/sdb1
> > > mkdir test
> > > mount /dev/sdb1 test
> > > fstrim ./test
> > 
> > I can confirm that this accurately reproduces file system corruption
> > using a 3.5 kernel.  It looks like some block allocation bitmap blocks
> > is getting trimmed when it shouldn't have been.  Lukas, can you take a
> > look at this?
> > 
> > 					- Ted
> 
> Hi Ted,
> 
> sorry for the delay, I've just got back from my vacation. I'll take
> a look at it.
> 
> Thanks!
> -Lukas

This does not seem like an ext4 problem. The code seems unable to
actually discard blocks which are allocated. Moreover I was not able
to reproduce the problem on the loop device with the same setting as
the reported scsi_debug device (1024 bs file system on the 256MB image
residing on the 1024 bs filesystem) 

After a little bit of tracing with the systemtap and blktrace ext4
does not seem to be doing anything wrong and yet we get part of the
block bitmap trimmed. This lead me to the scsi_debug driver itself
and indeed it seems that we have off-by-one bug there in the
unamp_region() which is causing the problem.

Here is the patch which fixes the problem for me, I'll resend the
proper patch in a bit.

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..f4cc413 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2054,7 +2054,7 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end && block < map_size) {
+		if (rem == 0 && lba + granularity < end && block < map_size) {
 			clear_bit(block, map_storep);
 			if (scsi_debug_lbprz)
 				memset(fake_storep +


Thanks!
-Lukas
--185209864-1526929049-1345127291=:2459--
