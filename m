From: Andreas Dilger <adilger@sun.com>
Subject: Re: Kernel thread to zero itables for lazy_itable_init?
Date: Wed, 10 Jun 2009 23:37:56 -0600
Message-ID: <20090611053756.GQ9002@webber.adilger.int>
References: <4A303692.3010104@lpdev.prtdev.lexmark.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Howard Cochran <hcochran@lexmark.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65112 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZFKFiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2009 01:38:15 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5B5cBZY009129
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 22:38:14 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KL2007007LPLW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 10 Jun 2009 22:38:11 -0700 (PDT)
In-reply-to: <4A303692.3010104@lpdev.prtdev.lexmark.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 10, 2009  18:41 -0400, Howard Cochran wrote:
> What is the status of the code to start a background kernel thread to  
> zero the inode tables when filesystem that was created with mke2fs -E  
> lazy_itable_init is mounted?  All I have found is a patch set posted to  
> this mailing list back on November 21, 2008 and some discussion of the  
> implementation, but nothing after that.
>
> Is this effort still alive?

I don't think anyone is currently working on it.

> On a related note, from what I have read here, and from looking at the  
> ext4 kernel code, the filesystem itself never really requires the inode  
> tables to be zeroed out.  The only reason one might want to do that is  
> so that fsck does not detect false errors. 

Correct, but the risk is that the whole filesystem could become corrupted
by the old data in the inode table.

> So, I am wondering whether we really need the complexity of a kernel  
> thread to zero out the itable (or the long delay of doing it during  
> mke2fs).  Instead, would it not be better to modify fsck to ignore  
> garbage in unallocated inodes, at least for filesystems that have a 
> journal.

Sure, e2fsck already does that, but this is not totally robust.  If
the marker for unallocated inodes itself becomes corrupted (which
will happen eventually, or e2fsck wouldn't ever be needed) then the
aforementioned filesystem-wide corruption could ensue.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

