From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Sun, 11 Feb 2007 22:11:18 -0500
Message-ID: <20070212031118.GB10424@thunk.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp> <20070205131204.GA15596@atrey.karlin.mff.cuni.cz> <20070206173520.7719a7de.akpm@linux-foundation.org> <20070207204657.GC6565@schatzie.adilger.int> <20070207125659.bc27404d.akpm@linux-foundation.org> <20070208092945.GA10973@duck.suse.cz> <20070208014529.d990b502.akpm@linux-foundation.org> <20070208102102.GC10973@duck.suse.cz> <20070208023213.902eed32.akpm@linux-foundation.org> <20070208104739.GA3674@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>, sho@tnes.nec.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35554 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbXBLGjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Feb 2007 01:39:25 -0500
Content-Disposition: inline
In-Reply-To: <20070208104739.GA3674@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 08, 2007 at 11:47:39AM +0100, Jan Kara wrote:
> > 
> > Well.  Do we really?  Are we looking for a 100% solution here, or a 90% one?
>   Umm, I think that for ext3 having data on one end of the disk and
> indirect blocks on the other end of the disk does not quite help (not
> mentioning that it can create bad free space fragmentation over the time).
> I have not measured it but I'd guess that it would erase the effect of
> moving data closer together. At least for sequential reads..

I don't think anyone is saying we can ignore the metadata; but the
fact is, the cleanest solution for 90% of the problem is to use the
page cache, and as far as the other 10%, Linus has been pushing us to
move at least the directories into the page cache, and it's not insane
to consider moving the rest of the metadata into page cache.  At least
it's something we should consider carefully.

						- Ted
