From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Thu, 25 Oct 2007 08:56:10 -0500
Message-ID: <1193320570.12664.19.camel@norville.austin.ibm.com>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
	 <1193279915.25351.18.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Bram Neijt <bneijt@gmail.com>, linux-ext4@vger.kernel.org
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46302 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXJYN42 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 09:56:28 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9PDuMZa014427
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 09:56:22 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9PDuL0M107688
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 07:56:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9PDuLNv026335
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 07:56:21 -0600
In-Reply-To: <1193279915.25351.18.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-24 at 19:38 -0700, Eric wrote:
> On Wed, 2007-10-24 at 20:10 +0200, Bram Neijt wrote:
> > One of the best solutions I can come up with is if the filesystem
> > would allow for a switch that would help ignore these permissions as
> > part of the filesystem.
> 
> Ignoring file permissions on removable, user-supplied media sounds like
> something that ought to be done above the level of individual
> filesystems, just like how we ignore device files and suid/sgid files in
> certain cases. Maybe this is something that ought to be one level up
> from the ext2/3/4 filesystem driver?

It would be a nice feature to implement at a higher level.  A lot of
file systems do something like this.

> In any case, this raises interesting questions. If we ignore permissions
> on removable media, then anyone logged into your work computer (to which
> you do not have root access) will be able to muck about with your files.
> Is that something you want?

Mount options should override on-media permissions, but those overriding
permissions could still deny access to others:

mount -o uid=1000,gid=1000,fmask=137,dmask=027 /dev/sdb1 /mnt/usbstick

-- 
David Kleikamp
IBM Linux Technology Center
