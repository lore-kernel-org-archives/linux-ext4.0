From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/19] mke2fs: Allow specifying number of reserved inodes
Date: Wed, 26 Aug 2015 17:49:59 +0200
Message-ID: <20150826154959.GA14012@quack.suse.cz>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-12-git-send-email-jack@suse.com>
 <20150807153722.GB24988@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbbHZPuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 11:50:05 -0400
Content-Disposition: inline
In-Reply-To: <20150807153722.GB24988@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 07-08-15 08:37:22, Darrick J. Wong wrote:
> On Fri, Aug 07, 2015 at 12:51:21PM +0200, Jan Kara wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > Add option to specify number of reserved inodes in the created
> > filesystem.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  misc/mke2fs.8.in      |  6 ++++++
> >  misc/mke2fs.c         | 40 +++++++++++++++++++++++++++++++++++++++-
> >  misc/mke2fs.conf.5.in |  6 ++++++
> >  3 files changed, 51 insertions(+), 1 deletion(-)
> > 
> > diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> > index 40c40d3ed065..520a07185f9f 100644
> > --- a/misc/mke2fs.8.in
> > +++ b/misc/mke2fs.8.in
> > @@ -384,6 +384,12 @@ Do not attempt to discard blocks at mkfs time.
> >  @QUOTA_MAN_COMMENT@.B quota
> >  @QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default
> >  @QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
> > +.TP
> > +.BI reserved_inodes= number
> > +Specify the number of inodes reserved for system files. This number must be
> > +at least 10. Currently 10 is enough but future features may require additional
> > +reserved inodes. Reserving more inodes after file system is created requires
> > +full file system scan so it can take a long time.
> 
> Perhaps:
> 
> "...requires a full file system scan, which can take a long time."
> 
> The "it" in "it can take" could be confused as referring to the process of
> reserving more inodes (vs. moving inodes around after creation, which is what
> takes a long time).
> 
> Same comment applies to the manpage at the bottom of the patch.

OK, wording changed to what you suggested. Thanks!

								Honza

> >  .RE
> >  .TP
> >  .BI \-f " fragment-size"
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 78b1252d8519..d61d1a332e67 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1024,6 +1024,34 @@ static void parse_extended_opts(struct ext2_super_block *param,
> >  				r_usage++;
> >  				continue;
> >  			}
> > +		} else if (!strcmp(token, "reserved_inodes")) {
> > +			unsigned int reserved_inodes;
> > +
> > +			if (!arg) {
> > +				r_usage++;
> > +				badopt = token;
> > +				continue;
> > +			}
> > +			reserved_inodes = strtoul(arg, &p, 0);
> > +			if (*p) {
> > +				fprintf(stderr,
> > +					_("Invalid number of reserved inodes "
> > +					  "%s\n"),
> > +					arg);
> > +				r_usage++;
> > +				continue;
> > +			}
> > +			/* Ino 0 is invalid so bump by 1... */
> > +			reserved_inodes++;
> > +			if (reserved_inodes < EXT2_GOOD_OLD_FIRST_INO) {
> > +				fprintf(stderr,
> > +					_("Too few reserved inodes "
> > +					  "%s (must be at least %u)\n"),
> > +					arg, EXT2_GOOD_OLD_FIRST_INO - 1);
> > +				r_usage++;
> > +				continue;
> > +			}
> > +			param->s_first_ino = reserved_inodes;
> >  		} else {
> >  			r_usage++;
> >  			badopt = token;
> > @@ -1049,7 +1077,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
> >  			"\ttest_fs\n"
> >  			"\tdiscard\n"
> >  			"\tnodiscard\n"
> > -			"\tquotatype=<usr OR grp>\n\n"),
> > +			"\tquotatype=<usr OR grp>\n"
> > +			"\treserved_inodes=<number of reserved inodes>\n\n"),
> >  			badopt ? badopt : "");
> >  		free(buf);
> >  		exit(1);
> > @@ -2422,6 +2451,15 @@ profile_error:
> >  		exit(1);
> >  	}
> >  
> > +	/* Count with one more inode for lost+found */
> > +	if (fs_param.s_first_ino >= fs_param.s_inodes_count + 1) {
> > +		com_err(program_name, 0, _("asked for more reserved inodes than filesystem has "
> > +			"available (%u >= %u)\n"),
> > +			(unsigned int)fs_param.s_first_ino,
> > +			(unsigned int)fs_param.s_inodes_count + 1);
> > +		exit(1);
> > +	}
> > +
> >  	/*
> >  	 * Calculate number of blocks to reserve
> >  	 */
> > diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> > index ad6c11b3cb7b..06ca9e4eabc4 100644
> > --- a/misc/mke2fs.conf.5.in
> > +++ b/misc/mke2fs.conf.5.in
> > @@ -195,6 +195,12 @@ specify one on the command line, and the filesystem-type
> >  specific section of the configuration file does not specify a default
> >  reserved ratio. This value can be a floating point number.
> >  .TP
> > +.I reserved_inodes
> > +This relation specifies the default number of inodes reserved for system files.
> > +The number must be at least 10. Currently 10 is enough but future features may
> > +require additional reserved inodes. Reserving more inodes after file system is
> > +created requires full file system scan so it can take a long time.
> > +.TP
> >  .I undo_dir
> >  This relation specifies the directory where the undo file should be
> >  stored.  It can be overridden via the
> > -- 
> > 2.1.4
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
