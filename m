From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Fri, 25 Jan 2008 11:05:45 +0100
Message-ID: <20080125100545.GB10202@atrey.karlin.mff.cuni.cz>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com> <20080123165307.GA32663@mit.edu> <20080123215029.GB18433@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52610 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYAYKFq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 05:05:46 -0500
Content-Disposition: inline
In-Reply-To: <20080123215029.GB18433@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> On Jan 23, 2008  11:53 -0500, Theodore Tso wrote:
> > Since I'm still hoping that
> > some point in the future, fs/ext4 could subsume fs/ext3 so we don't
> > have to worry about bug fixes going into fs/ext2 AND fs/ext3 AND
> > fs/ext4, I have my own reasons for wanting that.
> 
> If any newbie kernel hacker wants a filesystem project, allowing ext4
> to mount ext2 filesystems w/o a journal would be very useful.  I
> suspect that a simple flag check in the ext4_journal_* wrappers of the
> jbd2 functions would be enough in many cases.
> 
> One of the reasons to keep ext2 around is that ext3 cannot mount the
> filesystem without a journal, and removing that limitation for ext4
> would bring us one step closer to removing a ton of duplicate code.
> Another reason for ext2 vs. ext3 was overhead from journaling, and
> that could also be removed by allowing ext4 to mount ext2 filesystems
> w/o a journal.
  Actually, folding ext2 into ext3/4 isn't as easy as one would guess in
the beginning. For example ext2 on fsync() just sync's a single inode
(and has to use private_list to track metadata buffers associated with
the inode) while ext3 flushes the whole journal. Also in ext2, directory
handling code is quite different. ext2 works in page cache of the
directory while ext3 uses page cache of the underlying device via buffer
heads - at least this second thing would be more or less mechanical
thing to change and would make sence (we wouldn't have to reimplement
readahead in ext3 directory handling code as we do now). I've looked at
it once but then more urgent things came and ... you know it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
