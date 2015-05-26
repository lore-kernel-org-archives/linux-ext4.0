From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] tune2fs: Add support for orphan_file feature
Date: Tue, 26 May 2015 09:24:35 +0200
Message-ID: <20150526072435.GB3307@quack.suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
 <1432294137-26078-5-git-send-email-jack@suse.cz>
 <20150522171842.GA830@birch.djwong.org>
 <20150525073831.GB2387@quack.suse.cz>
 <00D427E7-DF68-4934-87E2-10D34032883E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbbEZHYk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 03:24:40 -0400
Content-Disposition: inline
In-Reply-To: <00D427E7-DF68-4934-87E2-10D34032883E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-05-15 10:16:27, Andreas Dilger wrote:
> 
> > On May 25, 2015, at 1:38 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > On Fri 22-05-15 10:18:42, Darrick J. Wong wrote:
> >> On Fri, May 22, 2015 at 01:28:57PM +0200, Jan Kara wrote:
> >>> @@ -1970,6 +2011,31 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
> >>> 				continue;
> >>> 			}
> >>> 			ext_mount_opts = strdup(arg);
> >>> +		} else if (!strcmp(token, "orphan_file_size")) {
> >>> +			__u64 size;
> >>> +
> >>> +			if (!arg) {
> >>> +				r_usage++;
> >>> +				continue;
> >>> +			}
> >>> +			size = strtoul(arg, &p, 0);
> >> 
> >> Would be nice if I could supply units, e.g. orphan_file_size = 128K here.
> > 
> > I don't mind doing this but do we have precedens in any option? Because
> > e.g. journal size is just a number (in megabytes), stripe options are in fs
> > blocks. For orphan file megabytes are too coarse. I can make the unit
> > fs-blocks, or kbytes, or leave it at bytes, or allow specifying units but
> > some consistency would be good. Any opinion?
> 
> Use "parse_num_blocks2()" for this.  This is used to parse the filesystem size in mke2fs,
> blocksize, bigalloc cluster size, resize, etc.  You are right that the journal_size is
> NOT using this helper, but it probably should.
  Ah, thanks for the hint! Will do.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
