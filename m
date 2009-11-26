From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Report metadata errors during fsync
Date: Thu, 26 Nov 2009 14:29:01 +0100
Message-ID: <20091126132901.GA4834@quack.suse.cz>
References: <1259144693-6732-1-git-send-email-jack@suse.cz>
 <20091125134858.97ca863d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	chris.mason@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36160 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759518AbZKZN3B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Nov 2009 08:29:01 -0500
Content-Disposition: inline
In-Reply-To: <20091125134858.97ca863d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-11-09 13:48:58, Andrew Morton wrote:
> On Wed, 25 Nov 2009 11:24:53 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > When an IO error happens while writing metadata buffers, we should better
> > report it and call ext2_error since the filesystem is probably no longer
> > consistent. Sometimes such IO errors happen while flushing thread does
> > background writeback, the buffer gets later evicted from memory, and thus
> > the only trace of the error remains as AS_EIO bit set in blockdevice's
> > mapping. So we check this bit in ext2_fsync and report the error although
> > we cannot be really sure which buffer we failed to write.
> 
> So this doesn't cause significant changes in runtime behaviour unless
> the operator specified errors=remount-ro or errors=panic?
  Yes, only log message in case errors=continue. OTOH errors=remount-ro is
IMHO more common. But in case we detect metadata IO error (which is what
I've added), calling ext2_error is desirable regardless of what it ends up
doing.

								Honza
