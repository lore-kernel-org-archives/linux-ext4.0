From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Tue, 23 Oct 2012 19:57:09 -0500
Message-ID: <50873CE5.8090303@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <20121023221913.GC28626@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	=?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121023221913.GC28626@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/23/12 5:19 PM, Theodore Ts'o wrote:
> On Tue, Oct 23, 2012 at 09:57:08PM +0100, Nix wrote:
>>
>> It is now quite clear that this is a bug introduced by one or more of
>> the post-3.6.1 ext4 patches (which have all been backported at least to
>> 3.5, so the problem is probably there too).
>>
>> [   60.290844] EXT4-fs error (device dm-3): ext4_mb_generate_buddy:741: group 202, 1583 clusters in bitmap, 1675 in gd
>> [   60.291426] JBD2: Spotted dirty metadata buffer (dev = dm-3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
>>
> 
> I think I've found the problem.  I believe the commit at fault is commit
> 14b4ed22a6 (upstream commit eeecef0af5e):
> 
>     jbd2: don't write superblock when if its empty
> 
> which first appeared in v3.6.2.
> 
> The reason why the problem happens rarely is that the effect of the
> buggy commit is that if the journal's starting block is zero, we fail
> to truncate the journal when we unmount the file system.  This can
> happen if we mount and then unmount the file system fairly quickly,
> before the log has a chance to wrap.After the first time this has
> happened, it's not a disaster, since when we replay the journal, we'll
> just replay some extra transactions.  But if this happens twice, the
> oldest valid transaction will still not have gotten updated, but some
> of the newer transactions from the last mount session will have gotten
> written by the very latest transacitons, and when we then try to do
> the extra transaction replays, the metadata blocks can end up getting
> very scrambled indeed.

I'm stumped by this; maybe Ted can see if I'm missing something.

(and Nix, is there anything special about your fs?  Any nondefault
mkfs or mount options, external journal, inordinately large fs, or
anything like that?)

The suspect commit added this in jbd2_mark_journal_empty():

        /* Is it already empty? */
        if (sb->s_start == 0) {
                read_unlock(&journal->j_state_lock);
                return;
        }

thereby short circuiting the function.

But Ted's suggestion that mounting the fs, doing a little work, and
unmounting before we wrap would lead to this doesn't make sense to
me.  When I do a little work, s_start is at 1, not 0.  We start
the journal at s_first:

load_superblock()
	journal->j_first = be32_to_cpu(sb->s_first);

And when we wrap the journal, we wrap back to j_first:

jbd2_journal_next_log_block():
        if (journal->j_head == journal->j_last)
                journal->j_head = journal->j_first;

and j_first comes from s_first, which is set at journal creation
time to be "1" for an internal journal.

So s_start == 0 sure looks special to me; so far I can only see that
we get there if we've been through jbd2_mark_journal_empty() already,
though I'm eyeballing jbd2_journal_get_log_tail() as well.

Ted's proposed patch seems harmless but so far I don't understand
what problem it fixes, and I cannot recreate getting to
jbd2_mark_journal_empty() with a dirty log and s_start == 0.

-Eric

> *Sigh*.  My apologies for not catching this when I reviewed this
> patch.  I believe the following patch should fix the bug; once it's
> reviewed by other ext4 developers, I'll push this to Linus ASAP.
> 
> 						- Ted
> 
> commit 26de1ba5acc39f0ab57ce1ed523cb128e4ad73a4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Oct 23 18:15:22 2012 -0400
> 
>     jbd2: fix a potential fs corrupting bug in jbd2_mark_journal_empty
>     
>     Fix a potential file system corrupting bug which was introduced by
>     commit eeecef0af5ea4efd763c9554cf2bd80fc4a0efd3: jbd2: don't write
>     superblock when if its empty.
>     
>     We should only skip writing the journal superblock if there is nothing
>     to do --- not just when s_start is zero.
>     
>     This has caused users to report file system corruptions in ext4 that
>     look like this:
>     
>     EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 22901 in gd
>     JBD2: Spotted dirty metadata buffer (dev = sdb3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
>     
>     after the file system has been corrupted.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: stable@vger.kernel.org
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 0f16edd..0064181 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1351,18 +1351,20 @@ void jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
>  static void jbd2_mark_journal_empty(journal_t *journal)
>  {
>  	journal_superblock_t *sb = journal->j_superblock;
> +	__be32		new_tail_sequence;
>  
>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
>  	read_lock(&journal->j_state_lock);
> -	/* Is it already empty? */
> -	if (sb->s_start == 0) {
> +	new_tail_sequence = cpu_to_be32(journal->j_tail_sequence);
> +	/* Nothing to do? */
> +	if (sb->s_start == 0 && sb->s_sequence == new_tail_sequence) {
>  		read_unlock(&journal->j_state_lock);
>  		return;
>  	}
>  	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
>  		  journal->j_tail_sequence);
>  
> -	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
> +	sb->s_sequence = new_tail_sequence;
>  	sb->s_start    = cpu_to_be32(0);
>  	read_unlock(&journal->j_state_lock);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
