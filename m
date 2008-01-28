From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Mon, 28 Jan 2008 13:16:01 +0100
Message-ID: <20080128121600.GA14038@duck.suse.cz>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com> <20080123165307.GA32663@mit.edu> <20080123215029.GB18433@webber.adilger.int> <20080125100545.GB10202@atrey.karlin.mff.cuni.cz> <20080125105004.GW18433@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58274 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbYA1MQE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 07:16:04 -0500
Content-Disposition: inline
In-Reply-To: <20080125105004.GW18433@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 25-01-08 03:50:04, Andreas Dilger wrote:
> On Jan 25, 2008  11:05 +0100, Jan Kara wrote:
> > For example ext2 on fsync() just sync's a single inode
> > (and has to use private_list to track metadata buffers associated with
> > the inode) while ext3 flushes the whole journal.
> 
> As for fsync(), we definitely need to preserve correct behaviour for the
> file itself, but there isn't a requirement that ext2 behave exactly like
> ext3 (it of course cannot).  In the proposed ext4-mount-unjournaled-ext2
> case, the superblock would be marked dirty as it is today and an e2fsck
> would need to be run at boot time.  That is fine so long as the fsync()
> will cause the one file's data to be on disk before it returns.
  Well, you have to also make sure that all indirect blocks are on disk
before fsync() returns. Otherwise there's not much point in the fact that
data itself reached the disk. And for that you need something like
private_list.

> > In ext2, directory
> > handling code is quite different. ext2 works in page cache of the
> > directory while ext3 uses page cache of the underlying device via buffer
> > heads - at least this second thing would be more or less mechanical
> > thing to change and would make sence (we wouldn't have to reimplement
> > readahead in ext3 directory handling code as we do now). I've looked at
> > it once but then more urgent things came and ... you know it.
> 
> I don't think it is a requirement that ext3 mounting a filesystem without
> a journal has to use page cache for directories.  I wouldn't object to
> that being fixed.  It definitely isn't a requirement for this to work,
> just an implementation difference.
  Yes, of course. I just wanted to point out that ext2 isn't a strict
subset of ext3 so there is some non-trivial work to be done before you can
safely mount ext2 as ext3-without-journal.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
