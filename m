From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Thu, 10 May 2012 11:30:23 -0400
Message-ID: <20120510153023.GE14975@thunk.org>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
 <20120510150024.GB8588@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120510150024.GB8588@quack.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 10, 2012 at 05:00:24PM +0200, Jan Kara wrote:
>   I've looked at this in more detail now. Although it would be nice to
> avoid duplicating the the functionality as others suggested, I agree it's
> not that simple and it seems to me we'd end up doing similar amount of work
> in the filesystems anyway (mount option parsing, writing to disk, printing
> mount options, ...). So I'm ok with the implementation as is and I'd be
> willing to take it for ext3 / ext2. But we really want to keep all ext?
> filesystems consistent so this also depends on Ted's approval of the change
> for ext4.  Ted?

Grumble.  I agree, reluctantly.  As much as I would like to make this
be generic, it looks like the amount of glue code to allow the VFS to
parse text-based mount options, and change the uid/gid fields after it
is read from disk and before writing to disk is probably more than the
code that we could be able to factor out.

>   What I'm missing in the changelog description is what i_diskuid/i_diskgid
> is good for. Although I can imagine some use case, I'm not sure I can see
> any sufficiently convicing one...

I'd much rather force diskuid and diskgid to 0 if the uid or gid is
specified, and if uid or gid option is in force, we force nosuid to be
on, to avoid the very obvious security problems if a sysadmin isn't
super careful.  The use case is going to be for things like USB sticks
where it's not likely that the sysadmin will be taking appropriate
care, so keeping things simple is probably a good thing.

>   Also please split the patch in three separate patches for ext2, ext3, and
> ext4. Thanks.

Yes, please.

							- Ted
