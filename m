From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 23 Jan 2008 14:50:29 -0700
Message-ID: <20080123215029.GB18433@webber.adilger.int>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com>
 <20080123165307.GA32663@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4280 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYAWVvz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 16:51:55 -0500
Received: from pd3mr5so.prod.shaw.ca (pd3mr5so-qfe3.prod.shaw.ca [10.0.141.12])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JV4008V2A07PBC0@l-daemon> for linux-ext4@vger.kernel.org; Wed,
 23 Jan 2008 14:50:31 -0700 (MST)
Received: from pn2ml5so.prod.shaw.ca ([10.0.121.149])
 by pd3mr5so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JV40066FA072K40@pd3mr5so.prod.shaw.ca> for
 linux-ext4@vger.kernel.org; Wed, 23 Jan 2008 14:50:32 -0700 (MST)
Received: from webber.adilger.int ([68.147.251.212])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with SMTP id <0JV400HFOA05AE20@l-daemon> for linux-ext4@vger.kernel.org; Wed,
 23 Jan 2008 14:50:30 -0700 (MST)
In-reply-to: <20080123165307.GA32663@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 23, 2008  11:53 -0500, Theodore Tso wrote:
> Since I'm still hoping that
> some point in the future, fs/ext4 could subsume fs/ext3 so we don't
> have to worry about bug fixes going into fs/ext2 AND fs/ext3 AND
> fs/ext4, I have my own reasons for wanting that.

If any newbie kernel hacker wants a filesystem project, allowing ext4
to mount ext2 filesystems w/o a journal would be very useful.  I
suspect that a simple flag check in the ext4_journal_* wrappers of the
jbd2 functions would be enough in many cases.

One of the reasons to keep ext2 around is that ext3 cannot mount the
filesystem without a journal, and removing that limitation for ext4
would bring us one step closer to removing a ton of duplicate code.
Another reason for ext2 vs. ext3 was overhead from journaling, and
that could also be removed by allowing ext4 to mount ext2 filesystems
w/o a journal.

Maybe a good proposal for a Google Summer-of-Code project.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
