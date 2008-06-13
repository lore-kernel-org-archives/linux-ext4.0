From: Andreas Dilger <adilger@sun.com>
Subject: Re: why not allow checksumming of file contents, too?
Date: Thu, 12 Jun 2008 23:08:39 -0600
Message-ID: <20080613050839.GT3726@webber.adilger.int>
References: <loom.20080613T013006-144@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: iaw4 <ivo_welch@brown.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60379 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYFMFIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 01:08:42 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5D58f0G020237
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 22:08:41 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2D00J01Y5E0U00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 12 Jun 2008 22:08:41 -0700 (PDT)
In-reply-to: <loom.20080613T013006-144@post.gmane.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 13, 2008  01:33 +0000, iaw4 wrote:
> there is already checksumming of metadata.

There is only checksumming of the metadata in the journal and for the
group descriptor.  There is not yet checksumming of the rest of
metadata (bitmaps, inode table, superblock, etc).

> having a file-system option of
> checksumming every file's contents upon closing the write would be very
> convenient, too.  It would only take an extra few bytes in the file
> descriptor, wouldn't it?  It would be nice insurance against hardware
> corruption.  zfs has it, too, I believe.  just a suggestions from someone
> who is just an end user...

Sure, I don't think anyone objects to it, but it is a lot of work to
implement and nobody has yet made the effort to do so.  If someone is
looking to work on this, we've given a lot of thought to the design
of how to implement this.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

