From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/5 resend] Adding support to freeze and unfreeze a
	journal
Date: Tue, 6 Dec 2011 07:25:34 -0700
Message-ID: <20111206142534.GV4387@parisc-linux.org>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com> <1323118489-16326-2-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323118489-16326-2-git-send-email-kamal@canonical.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 05, 2011 at 12:54:45PM -0800, Kamal Mostafa wrote:
> From: Surbhi Palande <surbhi.palande@canonical.com>
> @@ -4330,23 +4330,15 @@ static int ext4_freeze(struct super_block *sb)
>  
>  	journal = EXT4_SB(sb)->s_journal;
>  
> -	/* Now we set up the journal barrier. */
> -	jbd2_journal_lock_updates(journal);
> -
> +	error = jbd2_journal_freeze(journal);
>  	/*
> -	 * Don't clear the needs_recovery flag if we failed to flush
> +	 * Don't clear the needs_recovery flag if we failed to freeze
>  	 * the journal.
>  	 */
> -	error = jbd2_journal_flush(journal);
> -	if (error < 0)
> -		goto out;
> -
> -	/* Journal blocked and flushed, clear needs_recovery flag. */
> -	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> -	error = ext4_commit_super(sb, 1);
> -out:
> -	/* we rely on s_frozen to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	if (error >= 0) {
> +		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> +		error = ext4_commit_super(sb, 1);
> +	}
>  	return error;
>  }

A strange goto-avoidance fetish here?  Why not stick to the same style
as the function already had:

	error = jbd2_journal_freeze(journal);
	if (error)
		goto out;

	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
	error = ext4_commit_super(sb, 1);
 out:
	return error;

Easier to read the patch, easier to add new potential error cases to this
function later.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
