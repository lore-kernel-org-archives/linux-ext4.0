From: Andreas Dilger <adilger@sun.com>
Subject: Re: RFC: "file" magic for ext4
Date: Wed, 30 Jan 2008 17:34:42 -0700
Message-ID: <20080131003442.GL23836@webber.adilger.int>
References: <47A0B1BF.4010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46953 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbYAaAep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2008 19:34:45 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m0V0YjdN009138
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 16:34:45 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVH00801G8AKD00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 30 Jan 2008 16:34:45 -0800 (PST)
In-reply-to: <47A0B1BF.4010109@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 30, 2008  11:19 -0600, Eric Sandeen wrote:
> This seems to work fine; any comments, either about
> the logic, or the text descriptions, or the various
> options I've shown/not shown?
> 
> To test, copy your "magic" file somewhere local, 
> replace the ext2/3 section with the following,
> and do something like:
> 
> # file -C -m magic; file -m ./magic -s /dev/sda1
> 
> -Eric
> 
> # ext2/ext3 filesystems - Andreas Dilger <adilger@turbolabs.com>

Lol, you may as well fix up the email....  adilger@dilger.ca will
probably be the least transient.

> 0x438   leshort         0xEF53          Linux
> >0x44c  lelong          x               rev %d
> >0x43e  leshort         x               \b.%d
> # No journal?  ext2
> >0x45c  lelong          ^0x0000004      ext2 filesystem data
> >>0x43a leshort         ^0x0000001      (mounted or unclean)
> # Has a journal?  ext3 or ext4
> >0x45c  lelong          &0x0000004
> #  and small INCOMPAT?
> >>0x460 lelong          <0x0000040
> #   and small RO_COMPAT?
> >>>0x464 lelong         <0x0000008      ext3 filesystem data
> #   else large RO_COMPAT?
> >>>0x464 lelong         >0x0000007      ext4 filesystem data
> #  else large INCOMPAT?
> >>0x460 lelong          >0x000003f      ext4 filesystem data
> # General flags for any ext* fs
> >0x460  lelong          &0x0000004      (needs journal recovery)
> >0x43a  leshort         &0x0000002      (errors)
> # INCOMPAT flags
> >0x460  lelong          &0x0000001      (compressed)
> #>0x460 lelong          &0x0000002      (filetype)
> #>0x460 lelong          &0x0000010      (meta bg)
> >0x460  lelong          &0x0000040      (extents)
> >0x460  lelong          &0x0000080      (64bit)
> #>0x460 lelong          &0x0000100      (mmp)
> #>0x460 lelong          &0x0000200      (flex bg)
> # RO_INCOMPAT flags
> #>0x464 lelong          &0x0000001      (sparse super)
> >0x464  lelong          &0x0000002      (large files)
> >0x464  lelong          &0x0000008      (huge files)
> #>0x464 lelong          &0x0000010      (gdt checksum)
> #>0x464 lelong          &0x0000020      (many subdirs)
> #>0x463 lelong          &0x0000040      (extra isize)

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
