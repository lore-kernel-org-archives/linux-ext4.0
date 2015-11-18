From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v4] ext4: Punch hole and DAX fixes
Date: Wed, 18 Nov 2015 16:13:02 +0100
Message-ID: <20151118151302.GF6097@quack.suse.cz>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
 <80B02B5F638F054B8B1358323FECDE0A5EA7097A@G2W2437.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
To: "Boylston, Brian" <brian.boylston@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbbKRPNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2015 10:13:05 -0500
Content-Disposition: inline
In-Reply-To: <80B02B5F638F054B8B1358323FECDE0A5EA7097A@G2W2437.americas.hpqcorp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-11-15 17:41:55, Boylston, Brian wrote:
> On Tue, Nov 10, 2015 at 2:51 PM, Jan Kara wrote:
> > submitted. Also note that testing with 1 KB blocksize on ramdisk is broken
> > since brd has buggy discard implementation - Jens has a fix queued.
> > 
> > Change since v3:
> > * Fixed ext4_dax_mmap_get_block() to not return buffer_new buffer and thus
> >   avoid racy zeroing in generic dax code
> > * Fixed ext4_map_blocks() to zeroout blocks before inserting entry into
> >   extent status tree to avoid racy lookups of blocks.
> > 
> > Changes since v2:
> > * Fixed collaps range to truncate pagecache properly with blocksize < pagesize
> > * Fixed assertion in ext4_get_blocks_overwrite
> > 
> > Patch set description
> > 
> > This series fixes a long standing problem of racing punch hole and page fault
> > resulting in possible filesystem corruption or stale data exposure. We fix the
> > problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
> > page faults with truncate and punch hole operations.
> > 
> > When having this exclusion, the only remaining problem with DAX implementation
> > are races between two page faults zeroing out same block concurrently (where
> > the data written after the first fault finishes are possibly overwritten by
> > the second fault still doing zeroing).
> 
> Is this still a problem for this version of the patch set?

No, the patch set fixes this problem. The paragraph meant to say that first
few patches fix hole punching issues and then a few patches fix this DAX
issue. But the wording is strange, I agree.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
