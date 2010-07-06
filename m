From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH] OCFS2: Allow huge (> 16 TiB) volumes to
 mount
Date: Tue, 6 Jul 2010 13:04:38 -0700
Message-ID: <20100706200438.GF17961@mail.oracle.com>
References: <87mxud74tw.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <87mxud74tw.fsf@gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

[Added jbd2 Ccs.  Sorry about the whole-patch-quote, but I want jbd2
 folks to see what we're doing.]

On Tue, Jun 29, 2010 at 05:16:11PM -0700, Patrick J. LoPresti wrote:
> The OCFS2 developers have already done all of the hard work to allow
> volumes larger than 16 TiB.  But there is still a "sanity check" in
> fs/ocfs2/super.c that prevents the mounting of such volumes, even when
> the cluster size and journal options would allow it.
> 
> This patch replaces that sanity check with a more sophisticated one to
> mount a huge volume provided that (a) it is addressable by the raw
> word/address size of the system (borrowing a test from ext4); (b) the
> volume is using JBD2; and (c) the JBD2_FEATURE_INCOMPAT_64BIT flag is
> set on the journal.
> 
> I factored out the sanity check into its own function.  I also moved it
> from ocfs2_initialize_super() down to ocfs2_check_volume(); any earlier,
> and the journal's flags have not been read from disk yet.
> 
> I have tested this patch on small volumes, huge volumes, and huge
> volumes without 64-bit block support in the journal.  All of them appear
> to work or to fail gracefully, as appropriate.
> 
> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0eaa929..3db233d 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1991,6 +1991,47 @@ static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uu
>  	return 0;
>  }
>  
> +/* Check to make sure entire volume is addressable on this system.
> +   Requires osb_clusters_at_boot to be valid and for the journal to
> +   have been read by jbd2_journal_load(). */
> +static int ocfs2_check_addressable(struct ocfs2_super *osb)
> +{
> +	int status = 0;
> +	u64 max_block =
> +		ocfs2_clusters_to_blocks(osb->sb,
> +					 osb->osb_clusters_at_boot) - 1;
> +
> +	/* Absolute addressability check (borrowed from ext4/super.c) */
> +	if ((max_block >
> +	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
> +	    (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
> +					     osb->sb->s_blocksize_bits))) {
> +		mlog(ML_ERROR, "Volume too large "
> +		     "to mount safely on this system");
> +		status = -EFBIG;
> +		goto out;
> +	}
> +
> +	/* 32-bit block number is always OK. */
> +	if (max_block <= (u32)~0UL)
> +		goto out;
> +
> +	/* Volume is "huge", so see if our journal is new enough to
> +	   support it. */
> +	if (!(OCFS2_HAS_COMPAT_FEATURE(osb->sb,
> +				       OCFS2_FEATURE_COMPAT_JBD2_SB) &&
> +	      jbd2_journal_check_used_features(osb->journal->j_journal, 0, 0,
> +					       JBD2_FEATURE_INCOMPAT_64BIT))) {
> +		mlog(ML_ERROR, "The journal cannot address the entire volume. "
> +		     "Enable the 'block64' journal option with tunefs.ocfs2");
> +		status = -EFBIG;
> +		goto out;
> +	}
> +
> + out:
> +	return status;
> +}
> +
>  static int ocfs2_initialize_super(struct super_block *sb,
>  				  struct buffer_head *bh,
>  				  int sector_size,
> @@ -2215,14 +2256,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
> -	    > (u32)~0UL) {
> -		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
> -		     "what jbd can address in 32 bits.\n");
> -		status = -EINVAL;
> -		goto bail;
> -	}
> -
>  	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>  				 sizeof(di->id2.i_super.s_uuid))) {
>  		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
> @@ -2404,6 +2437,12 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>  		goto finally;
>  	}
>  
> +	/* Now that journal has been loaded, check to make sure entire
> +	   volume is addressable. */
> +	status = ocfs2_check_addressable(osb);
> +	if (status)
> +		goto finally;
> +
>  	if (dirty) {
>  		/* recover my local alloc if we didn't unmount cleanly. */
>  		status = ocfs2_begin_local_alloc_recovery(osb,

	This is completely unsafe.  Two reasons.  First, you're checking
the journal features after ocfs2_journal_load() has done recovery.  This
may or may not be safe; recovering a 32bit journal probably works even
on a 64bit filesystem, and we shouldn't see that combination in the
wild anyway.  That's not so bad.
	Far worse is that you might recover a 64bit journal before
you've checked the sector_t or pagecache limits.  That's not acceptable.
	I think the best solution is to check all the limits before you
load the journal.  However, jbd2 doesn't quite let you do that yet.
Thus, I propose the following jbd2 patch.  jbd2 people, what do you
think:

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bc2ff59..7922d87 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t
*journal, 
 
	if (!compat && !ro && !incompat)
		return 1;
+	if (journal_get_superblock(journal))
+		return 0
	if (journal->j_format_version == 1)
		return 0;

	If the jbd2 maintainers will allow this patch, you can put
together a two-change series that first modifies jbd2 and then adds
ocfs2_check_addressable() *before* ocfs2_journal_load().

Joel

-- 

Life's Little Instruction Book #314

	"Never underestimate the power of forgiveness."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
