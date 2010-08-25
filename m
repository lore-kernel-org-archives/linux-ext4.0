From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Wed, 25 Aug 2010 00:08:26 -0600
Message-ID: <189719E5-70AB-4FA8-8DA1-B2E6F5CA1AE7@dilger.ca>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com> <1282326704-14838-4-git-send-email-lczerner@redhat.com> <1BF88ED4-1B61-4D6C-BD84-D8D28931D2C6@dilger.ca> <alpine.LFD.2.00.1008241013350.2714@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7784 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0HYGJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 02:09:16 -0400
In-Reply-To: <alpine.LFD.2.00.1008241013350.2714@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-24, at 03:01, Lukas Czerner wrote:
> On Mon, 23 Aug 2010, Andreas Dilger wrote:
>> 
>> On that related note, it may make sense to handle the itable zeroing for all filesystems from a single thread, instead of possibly starting multiple threads all writing to the same block device and causing a lot of seeking.  That means that at thread startup time it should verify that only a single thread is started, and all registered filesystems should put their zeroing tasks onto a list (under spinlock) that the one thread checks before it exits.
> 
> So you are suggesting filesystem independent threat which can be used by
> any filesystem on any block device ? I really do not know, if other file
> systems will be interested in it.

No, I just mean for ext4 filesystems, not other types of filesystems.  What I'm thinking about is that a system gets newly installed with 3 or 4 ext4 filesystems (/, /var, /home, /usr) in LVM or partitions on the same disk.  If we have multiple zeroing threads going on the same disk at one time it will be slow and seeking, and will significantly impact interactive performance.

> One problem that might emerge when we have one thread for multiple
> devices is, that it can be fairly complicated to control the thread
> according to device load. So it might be better to have one thread per
> device (disk). But it is just my first guess, since I need to look more
> into it.

While one thread per disk would possibly be faster, I don't think this is a critical performance issue, and determining the filesystem-to-disk mapping is complex and not easily done.  Having a single thread initialize the inode tables in series (one filesystem at a time) is fine, and it only needs to control the device load for a single filesystem.

Cheers, Andreas





