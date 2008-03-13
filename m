From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Thu, 13 Mar 2008 00:37:33 -0500
Message-ID: <1205386653.17652.7.camel@norville.austin.ibm.com>
References: <n7xejaoynp9.fsf@sor.suse.de>
	 <1204813967.8679.28.camel@norville.austin.ibm.com>
	 <n7xzltbwzq3.fsf@sor.suse.de>
	 <1204824227.7964.4.camel@norville.austin.ibm.com>
	 <n7xiqzywr7u.fsf@sor.suse.de>
	 <1204903187.7975.10.camel@norville.austin.ibm.com>
	 <n7xr6egkk6w.fsf@sor.suse.de>  <20080312200236.GE15804@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54636 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYCMFPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 01:15:25 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2D5FNA9002217
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 01:15:23 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2D5FNsb249836
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 01:15:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2D5FM1l023326
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 01:15:22 -0400
In-Reply-To: <20080312200236.GE15804@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is just a nitpick that doesn't change your argument at all.

On Wed, 2008-03-12 at 16:02 -0400, Theodore Tso wrote:
> On Wed, Mar 12, 2008 at 04:59:03PM +0100, Matthias Koenig wrote:
> > 1. Do we agree that fstab fs_passno could be used besides fsck -A by a 
> >    separate script to decide if a filesystem (that could not be checked 
> >    in the fsck -A phase) should be checked?
> 
> Well, historically there have been /etc/fstab entries which look like
> this:
> 
> /dev/zipdrive       /media/zipdisk   ext3 default,noauto 0 0
> 
> This is because there might not be a zip disk in the drive at the time
> of the boot.  However, a root user could insert a zip disk, and then
> run the command "fsck /dev/zipdrive" and expect it to work, and the
> follow that up with "mount /dev/zipdrive".
> 
> So passno == 0 can't mean "don't mount the filesystem, ever".  All it
> means is "don't mount it at boot".  So I don't think trying to kludge
> new fields into fs_passno is the way to go.

s/mount/check/ in the above paragraph.  passno only tells fsck what to
do.  "noauto" tells mount what to mount at boot time.

-- 
David Kleikamp
IBM Linux Technology Center

