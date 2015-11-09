From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Mon, 9 Nov 2015 17:22:56 +0100
Message-ID: <20151109162256.GH11149@quack.suse.cz>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
 <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
To: "Boylston, Brian" <brian.boylston@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbbKIQXB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 11:23:01 -0500
Content-Disposition: inline
In-Reply-To: <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 06-11-15 17:57:04, Boylston, Brian wrote:
> I've written a test tool (included below) that exercises page faults on
> hole-y portions of an mmapped file.  The file is created, sized using
> various methods, mmapped, and then two threads race to write a marker to
> different offsets within each mapped page.  Once the threads have
> finished marking each page, the pages are checked for the presence of
> the markers.
> 
> With vanilla 4.2 and 4.3 kernels, this test easily exposes corruption on
> pmem-backed, DAX-mounted xfs and ext4 file systems.
> 
> With 4.3 and this ext4 patch set, the data corruption is still seen:
> 
> $ ./holetest -f /pmem1/brian/holetest 1000
> holetest r207

Thanks for the test. I'll try to reproduce locally and have a look why
my block zeroing patch didn't work as expected.

								Honza
> 
> INFO: zero-filled test...
> INFO: sz = 3e800000, npages = 256000
> INFO: vastart = 00007f2ad0bd0000
> INFO: thread 0 is 7f2ad0bcf700
> INFO: thread 1 is 7f2ad03ce700
> INFO: 0 error(s) detected
> 
> INFO: posix_fallocate test...
> INFO: sz = 3e800000, npages = 256000
> INFO: vastart = 00007f2ad0bd0000
> INFO: thread 0 is 7f2ad03ce700
> INFO: thread 1 is 7f2ad0bcf700
> INFO: 0 error(s) detected
> 
> INFO: fallocate test...
> INFO: sz = 3e800000, npages = 256000
> INFO: vastart = 00007f2ad0bd0000
> INFO: thread 0 is 7f2ad0bcf700
> INFO: thread 1 is 7f2ad03ce700
> INFO: 0 error(s) detected
> 
> INFO: ftruncate test...
> INFO: sz = 3e800000, npages = 256000
> INFO: vastart = 00007f2ad0bd0000
> INFO: thread 0 is 7f2ad03ce700
> INFO: thread 1 is 7f2ad0bcf700
> ERROR: thread 0, offset 01001c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 01801c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 02001c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 02807c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 0281dc00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 03001c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 03023c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 03801c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 03804c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 04001c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 04801c00, 00000000 != 7f2ad03ce700
> ERROR: thread 0, offset 05001c00, 00000000 != 7f2ad03ce700
> ERROR: thread 1, offset 0e001400, 00000000 != 7f2ad0bcf700
> ERROR: thread 1, offset 16001400, 00000000 != 7f2ad0bcf700
> ERROR: thread 1, offset 1b001400, 00000000 != 7f2ad0bcf700
> ERROR: thread 1, offset 2a802400, 00000000 != 7f2ad0bcf700
> ERROR: thread 1, offset 31005400, 00000000 != 7f2ad0bcf700
> ERROR: thread 0, offset 3e6b3c00, 00000000 != 7f2ad03ce700
> INFO: 18 error(s) detected
> $
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
