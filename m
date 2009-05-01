From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 1 May 2009 10:47:29 -0400
Message-ID: <20090501144729.GA1459@infradead.org>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <1241152637-11986-3-git-send-email-tytso@mit.edu> <20090501104253.GC3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764301AbZEAOra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 10:47:30 -0400
Content-Disposition: inline
In-Reply-To: <20090501104253.GC3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:42:53AM -0600, Andreas Dilger wrote:
> On May 01, 2009  00:37 -0400, Theodore Ts'o wrote:
> > @@ -3923,6 +3911,12 @@ static int __init init_ext4_fs(void)
> > +	ext4_nojournal_sops = ext4_sops;
> > +	ext4_nojournal_sops.write_super = ext4_write_super;
> > +	ext4_nojournal_sops.sync_fs = 0;
> > +	ext4_nojournal_sops.freeze_fs = 0;
> > +	ext4_nojournal_sops.unfreeze_fs = 0;
> 
> I thought the general policy these days was to make a static const
> ops struct so that it cannot be changed (correctly or incorrectly)?

Yeah.  Having the super ops in the normal style would be a lot more
readable.  We don't copy mostly the same inode or file operations
either.

And to be super-pedantic NULL pointer should be initialized as NULL, not
0.

