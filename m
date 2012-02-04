From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: sane fsck default behavior for "Entry ... in ... has deleted/unused inode ....  Clear? yes"
Date: Sat, 4 Feb 2012 09:03:43 -0500
Message-ID: <1AB9AC11-F9E9-4F52-8CBC-D050B056D013@mit.edu>
References: <1328323907.72548.YahooMailClassic@web29505.mail.ird.yahoo.com>
Reply-To: Theodore Tso <tytso@MIT.EDU>, tytso@users.sourceforge.net,
	  Ext4 Developers List <linux-ext4@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	tytso@users.sourceforge.net,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: htl10@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:47932 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab2BDQAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Feb 2012 11:00:05 -0500
In-Reply-To: <1328323907.72548.YahooMailClassic@web29505.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 3, 2012, at 9:51 PM, Hin-Tak Leung wrote:

> (I did subscribe to fs-devel, but it seems not to like @sf alias and unsubscribed me after a while - and did that circle a few times; please CC).

Most of this message isn't appropriate for fs-devel.   The ext4 bits are
germane to the ext4 list, and the USB read errors should be taken to
the usb folks.    I've removed fs-devel from the reply-to header, and
I'll ask people who are replying to further edit the cc list if appropriate.

> Have a rather broken hard disk at the moment - the bulk of it is ext3 on top of lvm2 - the default for fedora almost exactly 4 years ago. So been doing a lot of 'e2fsck -fv -y ...' lately.
> 
> Am a little surprised about what "Entry <file> in <dir> (<num>) has deleted/unused inode <num>  Clear? yes" does. it deletes the file.
> 
> I wonder should it be re-tried, or relocated to /lost+found, or anything else?

This error means the inode entry (and perhaps the entire inode table
block in your case) has been zapped.  So all that's left is the directory
entry, containing the file name and inode number.   There's nothing
really left to save.

> I also want to make a suggestion: when such a decision is made, I'd like to keep a record of what files are lost, etc. Can an option be added to e2fsck to log its decisions somewhere?

I suggest that you look at using the "script" program if you are running
e2fsck manually, or if you are interested in saving the output of fsck
during the boot sequence, if your distro isn't already using logsave,
consider using that binary.

> it appears that some combination of SATA->USB enclosure plus usb-storage plus usb hci driver doesn't like read errors, and the kernel resets the usb device and reconnects whenever that happens. That has the unfortunate side effect of renaming /dev/sdb into /dev/sdc, etc, underneath lvm2, and causes lvm2 to get stuck. I suppose that's the sane behavior since one wants to stop I/O and further damage, but maybe the kernel should only reset usb storage devices on write-errors, rather than read-errors? And somehow limit the device to read-only access after a read-error?

I'd suggest that you send your dmesg output to the USB folks.
That might give them more of an idea which portion of the
stack is causing the stack is causing the reset.   It may very
well be the SATA->USB enclosure is reporting some error
much worse than a read error as a result of the error. 

Regards,

-- Ted


