From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] jbd2: Always set journal superblock checksum when writing out superblock
Date: Fri, 10 May 2013 22:56:15 -0600
Message-ID: <328F41F9-3133-4742-9172-C7C3C79BD1CB@dilger.ca>
References: <20130510234013.GC5706@blackbox.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130510234013.GC5706@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-05-10, at 17:40, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> Add a few missing calls to jbd2_superblock_csum_set just prior to calling
> jbd2_write_superblock.  This fixes complaints about corrupt journals if
> metadata checksumming and journal checksumming are both enabled.

Why not just put this call inside jbd2_write_superblock()?

Cheers, Andreas

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/jbd2/journal.c |    2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index b6cdc57..a4c7678 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1348,6 +1348,7 @@ void jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
> 
>    sb->s_sequence = cpu_to_be32(tail_tid);
>    sb->s_start    = cpu_to_be32(tail_block);
> +    jbd2_superblock_csum_set(journal, sb);
> 
>    jbd2_write_superblock(journal, write_op);
> 
> @@ -1381,6 +1382,7 @@ static void jbd2_mark_journal_empty(journal_t *journal)
> 
>    sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
>    sb->s_start    = cpu_to_be32(0);
> +    jbd2_superblock_csum_set(journal, sb);
>    read_unlock(&journal->j_state_lock);
> 
>    jbd2_write_superblock(journal, WRITE_FUA);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
