From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] jbd2: Always set journal superblock checksum when
 writing out superblock
Date: Mon, 13 May 2013 11:46:15 -0700
Message-ID: <20130513184615.GA8037@blackbox.djwong.org>
References: <20130510234013.GC5706@blackbox.djwong.org>
 <328F41F9-3133-4742-9172-C7C3C79BD1CB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <328F41F9-3133-4742-9172-C7C3C79BD1CB@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 10, 2013 at 10:56:15PM -0600, Andreas Dilger wrote:
> On 2013-05-10, at 17:40, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > Add a few missing calls to jbd2_superblock_csum_set just prior to calling
> > jbd2_write_superblock.  This fixes complaints about corrupt journals if
> > metadata checksumming and journal checksumming are both enabled.
> 
> Why not just put this call inside jbd2_write_superblock()?

You're right, I was confused and thought j_state_lock also protected the sb.
It doesn't, so we can avoid future programming errors by moving it.  I'll fix
the patch (and go see what mysteries 3.10 provides).

--D
> 
> Cheers, Andreas
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > fs/jbd2/journal.c |    2 ++
> > 1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index b6cdc57..a4c7678 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -1348,6 +1348,7 @@ void jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
> > 
> >    sb->s_sequence = cpu_to_be32(tail_tid);
> >    sb->s_start    = cpu_to_be32(tail_block);
> > +    jbd2_superblock_csum_set(journal, sb);
> > 
> >    jbd2_write_superblock(journal, write_op);
> > 
> > @@ -1381,6 +1382,7 @@ static void jbd2_mark_journal_empty(journal_t *journal)
> > 
> >    sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
> >    sb->s_start    = cpu_to_be32(0);
> > +    jbd2_superblock_csum_set(journal, sb);
> >    read_unlock(&journal->j_state_lock);
> > 
> >    jbd2_write_superblock(journal, WRITE_FUA);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
