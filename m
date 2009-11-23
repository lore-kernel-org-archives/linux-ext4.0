From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Mon, 23 Nov 2009 15:33:56 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911231533071.2958-100000@iolanthe.rowland.org>
References: <20091123200605.GA19446@roll>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, <linux-kernel@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	<linux-scsi@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: tmhikaru@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59361 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755791AbZKWUdu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 15:33:50 -0500
In-Reply-To: <20091123200605.GA19446@roll>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 Nov 2009 tmhikaru@gmail.com wrote:

> Uhh, this could be a problem. CONFIG_USB_MON=y is set in my .config BUT,
> although I followed the directions and debugfs is mounted,
> 
> root@roll:/home/tm# mount
> /dev/root on / type ext4 (rw,relatime,barrier=1,data=ordered,data_err=abort)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> usbfs on /proc/bus/usb type usbfs (rw)
> none_debugs on /sys/kernel/debug type debugfs (rw)
> 
> I receive this message when I test if usbmon's directory exists:
> 
> root@roll:/home/tm# ls /sys/kernel/debug/usbmon
> ls: cannot access /sys/kernel/debug/usbmon: No such file or directory
> 
> According to the kernel documentation usbmon should be loaded already. Help?

The documentation is slightly out of date.  The usbmon directory has 
been moved down a level, to /sys/kernel/debug/usb/usbmon.

Alan Stern

