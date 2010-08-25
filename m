From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Wed, 25 Aug 2010 15:00:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008251444590.2840@dhcp-lab-213.englab.brq.redhat.com>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com> <1282326704-14838-4-git-send-email-lczerner@redhat.com> <1BF88ED4-1B61-4D6C-BD84-D8D28931D2C6@dilger.ca> <alpine.LFD.2.00.1008241013350.2714@dhcp-lab-213.englab.brq.redhat.com>
 <189719E5-70AB-4FA8-8DA1-B2E6F5CA1AE7@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0HYNA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 09:00:56 -0400
In-Reply-To: <189719E5-70AB-4FA8-8DA1-B2E6F5CA1AE7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Aug 2010, Andreas Dilger wrote:

> On 2010-08-24, at 03:01, Lukas Czerner wrote:
> > On Mon, 23 Aug 2010, Andreas Dilger wrote:
> >> 
> >> On that related note, it may make sense to handle the itable zeroing for all filesystems from a single thread, instead of possibly starting multiple threads all writing to the same block device and causing a lot of seeking.  That means that at thread startup time it should verify that only a single thread is started, and all registered filesystems should put their zeroing tasks onto a list (under spinlock) that the one thread checks before it exits.

I Agree.

> > 
> > So you are suggesting filesystem independent threat which can be used by
> > any filesystem on any block device ? I really do not know, if other file
> > systems will be interested in it.
> 
> No, I just mean for ext4 filesystems, not other types of filesystems.  What I'm thinking about is that a system gets newly installed with 3 or 4 ext4 filesystems (/, /var, /home, /usr) in LVM or partitions on the same disk.  If we have multiple zeroing threads going on the same disk at one time it will be slow and seeking, and will significantly impact interactive performance.

That sounds good to me. Thanks.

> 
> > One problem that might emerge when we have one thread for multiple
> > devices is, that it can be fairly complicated to control the thread
> > according to device load. So it might be better to have one thread per
> > device (disk). But it is just my first guess, since I need to look more
> > into it.
> 
> While one thread per disk would possibly be faster, I don't think this is a critical performance issue, and determining the filesystem-to-disk mapping is complex and not easily done.  Having a single thread initialize the inode tables in series (one filesystem at a time) is fine, and it only needs to control the device load for a single filesystem.
> 
> Cheers, Andreas

Ok, doing one file system at a time seems reasonable, but in this case
mkfs should really zero out at least some of the inode tables, so we
have some reserve before the thread reach the next file system.

However, I think we might have a problem when there are more really big
filesystems, so at the end we will surely need to do some optimization
like "when there is too much traffic on one device, try another", or
"round-robin".

Regards.
-Lukas
