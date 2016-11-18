From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: fix in-superblock mount options processing
Date: Fri, 18 Nov 2016 13:06:14 -0500
Message-ID: <20161118180614.ok62ycyzr7ampkzv@thunk.org>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
 <20161118042610.13464-2-tytso@mit.edu>
 <197771C1-1059-4516-B6AC-EA32A5057E66@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <197771C1-1059-4516-B6AC-EA32A5057E66@dilger.ca>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 02:38:41AM -0700, Andreas Dilger wrote:
> > @@ -3321,17 +3321,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > 	int err = 0;
> > 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
> > 	ext4_group_t first_not_zeroed;
> > +	char *s_mount_opts = kzalloc(sizeof(sbi->s_es->s_mount_opts)+1,
> > +				   GFP_KERNEL);
> 
> This doesn't check if "sbi" is non-NULL before dereferencing it.  While
> there isn't really any likelihood for this allocation to fail, I don't
> think there is any benefit to moving these allocations to the declaration.

This should be safe because sizeof(sbi->s_es->s_mount_opts) is a
constant, so it would be calculated at compile time.  You're right
that we can use kstrndup() below, so I'll do that, though, in which
case s_mount_opts can be initialized to NULL.

> > +	if (sbi->s_es->s_mount_opts[0]) {
> > +		strncpy(s_mount_opts, sbi->s_es->s_mount_opts,
> > +			sizeof(sbi->s_es->s_mount_opts));
> 
> This could use kstrndup()?  It always allocates an extra byte for the NUL.

Will do.

> > @@ -4162,7 +4166,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > 
> > 	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs mount"))
> > 		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> > -			 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> > +			 "Opts: %.*s%s%s", descr,
> > +			 sizeof(sbi->s_es->s_mount_opts),
> > +			 sbi->s_es->s_mount_opts,
> 
> This isn't really needed, since there is always a NUL terminator added
> to the string?

This is sbi->s_es->s_mount_opts, not mount_opts.  And the former is
not necessarily guaranteed to be NUL terminated.  And the reason why
we can't use mount_opts is because parse_options() destroys the
passed-in string as part of the parsing.

Cheers,

						- Ted
