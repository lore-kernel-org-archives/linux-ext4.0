From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Wed, 7 Nov 2007 12:51:10 +0100
Message-ID: <20071107115110.GC22214@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106094056.3352a574@laptopd505.fenrus.org> <4730ACBF.6050606@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59289 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753241AbXKGLvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 06:51:13 -0500
Content-Disposition: inline
In-Reply-To: <4730ACBF.6050606@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 06-11-07 10:04:47, H. Peter Anvin wrote:
> Arjan van de Ven wrote:
> >On Tue, 6 Nov 2007 18:19:45 +0100
> >Jan Kara <jack@suse.cz> wrote:
> >
> >>Implement recursive mtime (rtime) feature for ext3. The feature works
> >>as follows: In each directory we keep a flag EXT3_RTIME_FL
> >>(modifiable by a user) whether rtime should be updated. In case a
> >>directory or a file in it is modified and when the flag is set,
> >>directory's rtime is updated, the flag is cleared, and we move to the
> >>parent. If the flag is set there, we clear it, update rtime and
> >>continue upwards upto the root of the filesystem. In case a regular
> >>file or symlink is modified, we pick arbitrary of its parents
> >>(actually the one that happens to be at the head of i_dentry list)
> >>and start the rtime update algorith there.
> >
> >Ok since mtime (and rtime) are part of the inode and not the dentry...
> >how do you deal with hardlinks? And with cases of files that have been
> >unlinked? (ok the later is a wash obviously other than not crashing)
  Unlinked files are easy - you just don't propagate the rtime anywhere.
For hardlinks see below.

> There is only one possible answer... he only updates the directory path 
> that was used to touch the particular file involved.  Thus, the 
> semantics gets grotty not just in the presence of hard links, but also 
> in the presence of bind- and other non-root mounts.
  Update of recursive mtime does not pass filesystem boundaries (i.e.
mountpoints) so bind mounts and such are non-issue (hmm, at least that was
my original idea but as I'm looking now I don't handle bind mounts properly
so that needs to be fixed). With hardlinks, you are right that the
behaviour is undeterministic - I tried to argue in the text of the mail
that this does not actually matter - there are not many hardlinks on usual
system and so the application can check hardlinked files in the old way -
i.e. look at mtime.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
