From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Tue, 7 Apr 2009 11:18:01 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
 <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu>
 <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <49D8E71F.6000703@rtr.ca> <49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org> <49D99775.9030104@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205AbZDGSXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 14:23:53 -0400
In-Reply-To: <49D99775.9030104@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 6 Apr 2009, Jeff Garzik wrote:

> Arjan van de Ven wrote:
> > On Sun, 05 Apr 2009 16:57:21 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > > We set it in libata-scsi.c:ata_scsi_dev_config() based on
> > > ata_id_is_ssd()
> > > 
> > > That hueristic probably assumes Intel SSDs or something :/
> > 
> > you mean the "rpm" set to '1' ?
> > I was pretty sure that that was industry standard...
> 
> A -new- industry standard.  You can certainly create a compliant SSD while
> only conforming to ATA-7, for example.  Some older IDE flash devices pretend
> they are normal hard drives in almost every respect, too.

Something like this might be a good idea. 

I've seen several SSD's that do _not_ do that whole RPM == 1 thing, but 
they have "SSD" in their names. 

I forget how the ID is stored (I have this memory of it being big-endian 
16-bit words or something crazy like that?), but aside from fixing up that 
kind of crazyness, maybe something like this is worth it?

And making it non-inline, of course. And maybe it should use 'strstr()' 
instead of checking whether the name ends in 'SSD'. You get the idea..

		Linus

---
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -769,7 +769,14 @@ static inline int ata_id_is_cfa(const u16 *id)
 
 static inline int ata_id_is_ssd(const u16 *id)
 {
-	return id[ATA_ID_ROT_SPEED] == 0x01;
+	int len;
+	const char *model;
+
+	if (id[ATA_ID_ROT_SPEED] == 0x01)
+		return 1;
+	model = (const char *)&id[ATA_ID_PROD];
+	len = strnlen(model, ATA_ID_PROD_LEN);
+	return len > 3 && !memcmp(model+len-3, "SSD", 3);
 }
 
 static inline int ata_drive_40wire(const u16 *dev_id)
