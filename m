From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Mon, 9 Nov 2015 17:51:49 +0100
Message-ID: <20151109165149.GI11149@quack.suse.cz>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
 <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
 <20151109162256.GH11149@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	dchinner@redhat.com
To: "Boylston, Brian" <brian.boylston@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbbKIQvy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 11:51:54 -0500
Content-Disposition: inline
In-Reply-To: <20151109162256.GH11149@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-11-15 17:22:56, Jan Kara wrote:
>   Hi,
> 
> On Fri 06-11-15 17:57:04, Boylston, Brian wrote:
> > I've written a test tool (included below) that exercises page faults on
> > hole-y portions of an mmapped file.  The file is created, sized using
> > various methods, mmapped, and then two threads race to write a marker to
> > different offsets within each mapped page.  Once the threads have
> > finished marking each page, the pages are checked for the presence of
> > the markers.
> > 
> > With vanilla 4.2 and 4.3 kernels, this test easily exposes corruption on
> > pmem-backed, DAX-mounted xfs and ext4 file systems.
> > 
> > With 4.3 and this ext4 patch set, the data corruption is still seen:
> > 
> > $ ./holetest -f /pmem1/brian/holetest 1000
> > holetest r207
> 
> Thanks for the test. I'll try to reproduce locally and have a look why
> my block zeroing patch didn't work as expected.

Ah, OK, I see what's going on. So ext4 with my patches still returns
buffer_new buffer even though it is zeroed out and thus generic DAX code
still tries to zero out the buffer again which indeed causes the corrution
(will test everything tomorrow with that code disabled).  Now I have
decided that block mapping function should return buffer_new buffer even
though it is zeroed out because e.g. if block zeroing was used for page
cache writes, we'd still need code in fs/buffer.c to do proper zeroing of
parts of the block that are not written. And that happens based on
buffer_new flag.

The zeroing code in __dax_fault() needs to go away anyway so whether we
return buffer_new buffer is not really substantial but I'd like to get some
agreement and consistency among filesystems in with which flags zeroed
blocks are returned. Thoughts?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
