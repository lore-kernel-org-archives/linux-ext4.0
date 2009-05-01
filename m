From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 1 May 2009 09:49:12 -0400
Message-ID: <20090501134912.GD7681@mit.edu>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <1241152637-11986-3-git-send-email-tytso@mit.edu> <20090501104253.GC3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58992 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZEANtN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 09:49:13 -0400
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

The tradeoff is this makes it much easier from a maintenance point of
view to see what the differences are between ext4_nojournal_sops and
ext4_journal_sops.

						- Ted
