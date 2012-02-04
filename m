From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: sane fsck default behavior for "Entry ... in ... has deleted/unused inode ....  Clear? yes"
Date: Sat, 4 Feb 2012 02:51:47 +0000 (GMT)
Message-ID: <1328323907.72548.YahooMailClassic@web29505.mail.ird.yahoo.com>
Reply-To: htl10@users.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-fsdevel@vger.kernel.org, tytso@users.sourceforge.net,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ird.yahoo.com ([77.238.189.203]:34797 "HELO
	nm8-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752488Ab2BDCvt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 21:51:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(I did subscribe to fs-devel, but it seems not to like @sf alias and unsubscribed me after a while - and did that circle a few times; please CC).

Have a rather broken hard disk at the moment - the bulk of it is ext3 on top of lvm2 - the default for fedora almost exactly 4 years ago. So been doing a lot of 'e2fsck -fv -y ...' lately.

Am a little surprised about what "Entry <file> in <dir> (<num>) has deleted/unused inode <num>  Clear? yes" does. it deletes the file.

I wonder should it be re-tried, or relocated to /lost+found, or anything else?

I also want to make a suggestion: when such a decision is made, I'd like to keep a record of what files are lost, etc. Can an option be added to e2fsck to log its decisions somewhere?

Thanks for all the hard-work to make fsck even possible - the hard disk has been well-used :-).

For those people who might come across this in the future - here is a tips, and may be another question/discussion about sane behavior on error:

it appears that some combination of SATA->USB enclosure plus usb-storage plus usb hci driver doesn't like read errors, and the kernel resets the usb device and reconnects whenever that happens. That has the unfortunate side effect of renaming /dev/sdb into /dev/sdc, etc, underneath lvm2, and causes lvm2 to get stuck. I suppose that's the sane behavior since one wants to stop I/O and further damage, but maybe the kernel should only reset usb storage devices on write-errors, rather than read-errors? And somehow limit the device to read-only access after a read-error?

In any case, I somehow found that I could persuade the kernel not to reset the usb device, if I disable read-ahead (i.e. hdparm -a0/-A0). I also tried disabling read-ahead on the lvm2 device itself (-A0 /dev/dm-X, where X is the logical volume), and "echo 128 > /sys/block/sdc/device/max_sectors" (or smaller number).

So it seems that slowing it down make it more reliable for an unreliable disk. Maybe this can be made automatic inside the kernel?



 


 








