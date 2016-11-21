From: Wolfgang Walter <linux@stwm.de>
Subject: JBD2: Spotted dirty metadata buffer....
Date: Mon, 21 Nov 2016 16:28:03 +0100
Message-ID: <1744886.OgPgGFoXj7@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: LKML <linux-kernel@vger.kernel.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I'm testing EXT4 with an external journal (data=journal). When writing I rather often get

	JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1008028301). There's a risk of filesystem corruption in case of system crash.

Now other message is logged. If I unmount the filesystem an do an forced fsck, all seems fine.

The filesystem as it's journal are on a LV (which is again backed by DRBD). The journal, too.

Im using stable kernel 4.8.8.

I created the journal with:

	mkfs.ext4 -O journal_dev -v -b 4096  -L jdyn /dev/export/jdyn

I created the filesystem with:

	mkfs.ext4 -J device=UUID=625d871f-c278-4acb-916d-774dc78dbd8a -v -b 4096 -E stride=$((512/4)),stripe_width=$((512/4*3)),lazy_itable_init=0,nodiscard -O inline_data,mmp -L dyn /dev/export/dyn


I tested it also with data=writeback. I didn't see these errors then.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
