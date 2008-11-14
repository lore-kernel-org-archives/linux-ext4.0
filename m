From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 09/17] Add progress bar for allocating block tables	- takes forever on large
Date: Thu, 13 Nov 2008 21:45:14 -0500
Message-ID: <20081114024514.GE20637@shell>
References: <1226461390-5502-2-git-send-email-vaurora@redhat.com> <1226461390-5502-3-git-send-email-vaurora@redhat.com> <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <20081113195450.GU16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYKNCpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 21:45:16 -0500
Content-Disposition: inline
In-Reply-To: <20081113195450.GU16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 12:54:50PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> > +static errcode_t ext2fs_allocate_tables_with_progress(ext2_filsys fs)
> > +{
> > +	for (i = 0; i < fs->group_desc_count; i++) {
> > +		progress_update(&progress, i);
> > +		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
> > +		if (retval)
> > +			return retval;
> > +	}
> 
> Does it make sense to only update the progress periodically instead of for
> every group?  Since this is a memory operation, I suspect the console
> output slows it down noticably, and would spew a ton of garbage into
> console logs and such.  Something like:
> 
> 	for (i = 0; i < fs->group_desc_count; i++) {
> 		if (i & 256 == 255)
> 			progress_update(&progress, i);
> 		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
> 		if (retval)
> 			return retval;
> 	}
> 	progress_close(&progress);

Heh, I just assumed progress already did that.  How about making the
unit of progress proportional to the total number of tables?  Say,
update progress every thousandth.

Also, this is kind of obnoxious - I just cut and paste
ext2fs_allocate_tables() from its original home because the progress
routines aren't exported.  It may be smarter to export them (for
internal use only) and put the progress into ext2fs_allocate_tables().

-VAL
