From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Crash after umount'ing a disconnected disk and JBD: recovery
 failed (Re: extfs reliability)
Date: Fri, 13 Aug 2010 23:04:55 +0400
Message-ID: <4C659757.5020308@vlnb.net>
References: <20100804180325.GL9453@thunk.org> <4C5B1137.1070001@vlnb.net> <20100805211758.GA12358@thunk.org> <4C5C0CE2.7030009@vlnb.net> <20100806181042.GB24583@thunk.org> <4C604CE0.9040808@vlnb.net> <20100809193243.GH3635@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0HMTEy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Aug 2010 15:04:54 -0400
In-Reply-To: <20100809193243.GH3635@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o, on 08/09/2010 11:32 PM wrote:
>>>> It's next to the message on which you originally replied. It was
>>>> about ext3, but this time I saw it with ext4.
>>>
>>> Can you resend, and with a new and specific subject line that is
>>> helpful for finding it, and just that one message?
>>
>> See http://lkml.org/lkml/2010/7/29/222 and
>> http://lkml.org/lkml/2010/7/29/325.
> 
> My bet the problem is that iSCSI driver and/or the buffer cache array
> doesn't do the right thing with data in the buffer cache which is
> didn't actually make it out to the disk (when the I/O finally timed
> out), so there is some old data in the buffer cache which doesn't
> reflect what is on the disk.
> 
> I suspect that if you run the following command after you umount the
> disk, and recover the disk, before you mount the disk again, you run
> this command (source attached) on the block device, the journal
> recovery should no longer fail.  Can you try this experiment?  If we
> see that this solves the problem, then we can force a buffer cache
> flush at mount-time, so that it happens automatically.

I ran the program just before the mount and it changed nothing:

[36630.781663] e1000: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
# ./a.out /dev/sdb
# mount -t ext4 /dev/sdb /mnt
[36640.487208] JBD: recovery failed
[36640.500639] EXT4-fs (sdb): error loading journal
# mount -t ext4 /dev/sdb /mnt
[36721.642852] EXT4-fs (sdb): ext4_orphan_cleanup: deleting unreferenced inode 128135
[36721.669780] EXT4-fs (sdb): ext4_orphan_cleanup: deleting unreferenced inode 128136
[36721.696432] EXT4-fs (sdb): 2 orphan inodes deleted
[36721.709978] EXT4-fs (sdb): recovery complete
[36721.730531] EXT4-fs (sdb): mounted filesystem with ordered data mode

Vlad
