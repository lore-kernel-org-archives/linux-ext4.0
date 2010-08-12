From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/3] JBD2: Allow feature checks before
 journal recovery
Date: Thu, 12 Aug 2010 10:43:19 -0700
Message-ID: <20100812174318.GD6561@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com>
 <8739vb2mxr.fsf@patl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
	"Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8739vb2mxr.fsf@patl.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 03:04:16PM -0700, Patrick J. LoPresti wrote:
> Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
> confirm that its journal supports 64-bit offsets.  In particular, we
> need to check the journal's feature bits before recovering the journal.
> 
> This is not possible with JBD2 at present, because the journal
> superblock (where the feature bits reside) is not loaded from disk until
> the journal is recovered.
> 
> This patch loads the journal superblock in
> jbd2_journal_check_used_features() if it has not already been loaded,
> allowing us to check the feature bits before journal recovery.
> 
> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

Dear jbd2 developers,
	I've pushed this patch to the merge-window branch of ocfs2.git.
I'm ready to send it to Linus, but I need your OK.

Joel

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index bc2ff59..5cfd8d4 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1365,6 +1365,10 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
>  
>  	if (!compat && !ro && !incompat)
>  		return 1;
> +	/* Load journal superblock if it is not loaded yet. */
> +	if (journal->j_format_version == 0 &&
> +	    journal_get_superblock(journal) != 0)
> +		return 0;
>  	if (journal->j_format_version == 1)
>  		return 0;
>  
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
