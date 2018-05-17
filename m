From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] ext4: pass -ESHUTDOWN code to jbd2 layer
Date: Thu, 17 May 2018 17:18:18 +0200
Message-ID: <20180517151818.chnwazjmyh4n24rb@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-6-tytso@mit.edu>
 <20180306171041.mz7qlpeikih6mtlg@quack2.suse.cz>
 <20180322152644.GE2852@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322152644.GE2852@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 22-03-18 11:26:45, Theodore Y. Ts'o wrote:
> On Tue, Mar 06, 2018 at 06:10:41PM +0100, Jan Kara wrote:
> > Is it really correct that once the filesystem gets shutdown you clear the
> > previous error from the journal? Because if we hit some real fs corruption,
> > the journal gets aborted, and then someone calls ext4_shutdown(), we'd
> > clear that error which looks like a bug to me because that shutdown hardly
> > fixes the fs corruption...
> 
> That's not what the code does.  If journal->j_errno is set, then we
> won't clear it, for precisely what concern you've articulated.

Sorry for not following up on this earlier but now I've returned to this
and I still cannot wrap my head around checks in __journal_abort_soft().
There's:

       if (!journal->j_errno || errno == -ESHUTDOWN)
               journal->j_errno = errno;

Due to this ESHUTDOWN will override anything in journal->j_errno. Why is
that?

And then:

       if (journal->j_flags & JBD2_ABORT) {
                write_unlock(&journal->j_state_lock);
                if (!old_errno && old_errno != -ESHUTDOWN &&
                    errno == -ESHUTDOWN)
                        jbd2_journal_update_sb_errno(journal);

And here can the test ever be true? Probably only if we hard-aborted the
journal. The test !old_errno && old_errno != -ESHUTDOWN definitely looks
weird and is equivalent to old_errno == 0. Furthermore the errno ==
-ESHUTDOWN part looks strange as well as in that case we'd only clear the
sb->s_errno field... So what was really the intention here?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
