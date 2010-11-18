From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 5/7] mke2fs: Change -K option to discard/nodiscard
Date: Thu, 18 Nov 2010 11:00:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011181058230.15886@dhcp-lab-213.englab.brq.redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-6-git-send-email-lczerner@redhat.com> <4CE2F44E.1040807@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@dilger.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab0KRKvo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 05:51:44 -0500
In-Reply-To: <4CE2F44E.1040807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Nov 2010, Eric Sandeen wrote:

> On 10/26/10 12:54 PM, Lukas Czerner wrote:
> > It would be nice to have consistent "discard" options in every system
> > tool (mount, fsck, mkfs) taking advantage of discards. Also "discard"
> > and "nodiscard" is more descriptive instead of just "-K" and can be
> > easily defaulted and it is something we can not do with "-K".
> > 
> > With this commit you need to specify extended option like this:
> > 
> > ./mke2fs -T <fstype> -E nodiscard <device>
> > 
> > in order make a filesystem without discarding the device first. And
> > 
> > ./mke2fs -T <fstype> -E discard <device>
> > 
> > respectively.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  misc/mke2fs.8.in |   18 +++++++++++-------
> >  misc/mke2fs.c    |   13 ++++++++-----
> >  2 files changed, 19 insertions(+), 12 deletions(-)
> > 
> > diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> > index b46e7e2..6b437bc 100644
> > --- a/misc/mke2fs.8.in
> > +++ b/misc/mke2fs.8.in
> > @@ -45,9 +45,6 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
> >  .I journal-options
> >  ]
> >  [
> > -.B \-K
> > -]
> > -[
> >  .B \-N
> >  .I number-of-inodes
> >  ]
> > @@ -240,6 +237,17 @@ enable lazy inode table initialization.
> >  .B test_fs
> >  Set a flag in the filesystem superblock indicating that it may be
> >  mounted using experimental kernel code, such as the ext4dev filesystem.
> > +.TP
> > +.BI discard
> > +Attempt to discard blocks at mkfs time (discarding blocks initially is useful
> > +on solid state devices and sparse / thin-provisioned storage). When the device
> > +advertise that discard also zeroes data (any subsequent read after the discard
> 
> advertises
> 
> > +and before write returns zero), then mark all not-yet-zeroed inode table as
> 
> inode tables
> 
> > +zeroed. This significantly speeds up filesystem initialization. This is set
> > +as default.
> > +.TP
> > +.BI nodiscard
> > +Do not attempt to discard blocks at mkfs time.
> 
> "this is the default" perhaps.  (I'm not sure any other -E option has
> "no"-variants, so I'm not sure this is really needed, esp. for the
> default)
> 
> >  .RE
> >  .TP
> >  .BI \-f " fragment-size"
> > @@ -369,10 +377,6 @@ and may be no more than 102,400 filesystem blocks.
> >  @JDEV@.BR size " or " device
> >  @JDEV@options can be given for a filesystem.
> >  .TP
> > -.BI \-K
> > -Keep, do not attempt to discard blocks at mkfs time (discarding blocks initially
> > -is useful on solid state devices and sparse / thin-provisioned storage).
> > -.TP
> 
> maybe keep this and mark as deprecated?  Not sure how Ted handles deprecated
> options.  This one didn't live long ;)
> 
> >  .BI \-l " filename"
> >  Read the bad blocks list from
> >  .IR filename .
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 0980045..32e3a2b 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -753,6 +753,10 @@ static void parse_extended_opts(struct ext2_super_block *param,
> >  				lazy_itable_init = strtoul(arg, &p, 0);
> >  			else
> >  				lazy_itable_init = 1;
> > +		} else if (!strcmp(token, "discard")) {
> > +			discard = 1;
> > +		} else if (!strcmp(token, "nodiscard")) {
> > +			discard = 0;
> >  		} else {
> >  			r_usage++;
> >  			badopt = token;
> > @@ -768,7 +772,9 @@ static void parse_extended_opts(struct ext2_super_block *param,
> >  			"\tstripe-width=<RAID stride * data disks in blocks>\n"
> >  			"\tresize=<resize maximum size in blocks>\n"
> >  			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
> > -			"\ttest_fs\n\n"),
> > +			"\ttest_fs\n"
> > +			"\tdiscard\n"
> > +			"\tnodiscard\n\n"),
> >  			badopt ? badopt : "");
> >  		free(buf);
> >  		exit(1);
> > @@ -1168,7 +1174,7 @@ static void PRS(int argc, char *argv[])
> >  	}
> >  
> >  	while ((c = getopt (argc, argv,
> > -		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:KL:M:N:O:R:ST:U:V")) != EOF) {
> > +		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:L:M:N:O:R:ST:U:V")) != EOF) {
> 
> again, up to Ted whether we can drop an option like this.

This is a old version, I did send the new one "mke2fs: Deprecate -K
option, introduce discard/nodiscard" a while ago. Which removes -K
option from the man pages, and print out warning when it is used.

Thanks!
-Lukas

> 
> >  		switch (c) {
> >  		case 'b':
> >  			blocksize = strtol(optarg, &tmp, 0);
> > @@ -1247,9 +1253,6 @@ static void PRS(int argc, char *argv[])
> >  		case 'J':
> >  			parse_journal_opts(optarg);
> >  			break;
> > -		case 'K':
> > -			discard = 0;
> > -			break;
> >  		case 'j':
> >  			if (!journal_size)
> >  				journal_size = -1;
> 
> 
