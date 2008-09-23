From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] Filesystem Journal Notifications
Date: Tue, 23 Sep 2008 16:26:26 -0600
Message-ID: <20080923222626.GP10950@webber.adilger.int>
References: <20080912220649.GB26999@apaithan-desktop.sanmateo.corp.akamai.com>
 <20080915023126.GF4090@webber.adilger.int>
 <20080915053937.GG4090@webber.adilger.int>
 <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
 <20080920051537.GC9633@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Abhijit Paithankar <apaithan@akamai.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jamie Lokier <jamie@shareable.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49429 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYIWW06 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2008 18:26:58 -0400
In-reply-to: <20080920051537.GC9633@atrey.karlin.mff.cuni.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 20, 2008  07:15 +0200, Jan Kara wrote:
>   1) At the first sight it seems to be a useful idea to send to
> userspace notifications when some change is safely on disk. But at the
> second sight, it's technically really not that simple as it may seem.
> Filesystems such as ext2 have no good way of providing such information,
> even ext4 with delayed allocation has no way of giving you such
> information for writes and I guess similar thing holds for xfs. Also log
> structured filesystems and similar can tell you when a change is safely
> on disk but have no concept of something like journal commit. So at this
> point one should really ask himself whether a feature having a chance to
> work only on a limited number of setups has a serious chance of being
> used by application developpers...
>   Also note that on ext3 and ext4 a single 'write' call from userspace
> can be split among several transactions but there's just one inotify
> event so this has to be taken care of.

I think the assumption is that this isn't an API used by "generic"
applications, but rather ones that are being optimized for the system
they are running on.  ext3/4 is common enough that this isn't a very
limiting optimization.  I don't think Akamai are going to care about
running on JFFS2 or VFAT.  Probably registering for such events on
filesystems that don't understand them should just return an error.

We'll be stuck in 1981 forever if we continue to limit interfaces to
what all filesystems understand.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

