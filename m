From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't allow encrypted operations without keys
Date: Sun, 5 Feb 2017 20:13:55 -0500
Message-ID: <20170206011355.lebtlbu7b4xzskve@thunk.org>
References: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
 <20161228052252.10314-1-tytso@mit.edu>
 <20170204214428.GC5621@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Filesystem Development List
        <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
        richard@nod.at, ebiggers@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170204214428.GC5621@zzz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 04, 2017 at 01:44:28PM -0800, Eric Biggers wrote:
> 
> Hi Ted, this commit shows up twice in the ext4 tree, as 173b8439e1ba3 and
> a7ede371cb821, but the second actually adds the check two *more* times to
> ext4_cross_rename(), such that there are now a total of three checks in that
> function, all the same.  Do you want to revert the second, unnecessary, commit?

Yeah, it (and a few other fixes) was on the dev branch, and then when
they were cherry picked to the stable branch, and then I rebased the
dev branch on top of 4.10-rc3 to pick up a few other commits, I forgot
drop it.

Thanks for pointing it out; I've dropped it.

						- Ted
