From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Fri, 25 Jan 2008 03:50:04 -0700
Message-ID: <20080125105004.GW18433@webber.adilger.int>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com>
 <20080123165307.GA32663@mit.edu> <20080123215029.GB18433@webber.adilger.int>
 <20080125100545.GB10202@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49237 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbYAYUYZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 15:24:25 -0500
Received: from pd4mr2so.prod.shaw.ca
 (pd4mr2so-qfe3.prod.shaw.ca [10.0.141.213]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JV7009L5V9VUI60@l-daemon> for linux-ext4@vger.kernel.org; Fri,
 25 Jan 2008 13:22:43 -0700 (MST)
Received: from pn2ml10so.prod.shaw.ca ([10.0.121.80])
 by pd4mr2so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JV700A1SV9UYSA0@pd4mr2so.prod.shaw.ca> for
 linux-ext4@vger.kernel.org; Fri, 25 Jan 2008 13:22:43 -0700 (MST)
Received: from webber.adilger.int ([68.147.251.212])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JV700BR1V9T0J20@l-daemon> for linux-ext4@vger.kernel.org; Fri,
 25 Jan 2008 13:22:42 -0700 (MST)
In-reply-to: <20080125100545.GB10202@atrey.karlin.mff.cuni.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 25, 2008  11:05 +0100, Jan Kara wrote:
> For example ext2 on fsync() just sync's a single inode
> (and has to use private_list to track metadata buffers associated with
> the inode) while ext3 flushes the whole journal.

As for fsync(), we definitely need to preserve correct behaviour for the
file itself, but there isn't a requirement that ext2 behave exactly like
ext3 (it of course cannot).  In the proposed ext4-mount-unjournaled-ext2
case, the superblock would be marked dirty as it is today and an e2fsck
would need to be run at boot time.  That is fine so long as the fsync()
will cause the one file's data to be on disk before it returns.

> In ext2, directory
> handling code is quite different. ext2 works in page cache of the
> directory while ext3 uses page cache of the underlying device via buffer
> heads - at least this second thing would be more or less mechanical
> thing to change and would make sence (we wouldn't have to reimplement
> readahead in ext3 directory handling code as we do now). I've looked at
> it once but then more urgent things came and ... you know it.

I don't think it is a requirement that ext3 mounting a filesystem without
a journal has to use page cache for directories.  I wouldn't object to
that being fixed.  It definitely isn't a requirement for this to work,
just an implementation difference.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
