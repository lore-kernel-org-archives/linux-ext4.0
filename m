From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Wed, 15 Apr 2009 14:10:08 -0500
Message-ID: <49E63110.60507@redhat.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753478AbZDOTLW@vger.kernel.org>
In-Reply-To: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason wrote:
> Hello everyone,
> 
> Here is another version of the data=guarded work for ext3.  The main
> difference between this code and yesterday's is the guarded writepage
> function now sends any newly allocated block through the old data=ordered code.
> 
> This is important because at the time we're walking the buffers, the page
> may be unlocked, so we can't trust anything inside the page.  In general,
> any allocation done by writepage is to fill a hole, so the old data=ordered
> is what we want anyway.
> 
> This passed a longer stress test and generally seems to be working.  I
> don't think anyone would recommend it as a default for 2.6.30, but it
> may be a good idea to have a review party and decide if it is safe enough
> to include so people can experiment with it.

Chris, thanks for getting this going.  I think this is a great idea, as
it gives us most of the performance benefits of writeback without the
security issues.

I'm under the gun on some other deadlines at the moment so will have to
do a detailed review later, but this seems like a very good approach,
and in my testing it does indeed solve the the security problem of
writeback mode.

-Eric

> Overall diffstat of the series:
> 
>  fs/buffer.c                 |   45 ++-
>  fs/ext3/Makefile            |    3
>  fs/ext3/fsync.c             |   12
>  fs/ext3/inode.c             |  546 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext3/namei.c             |    3
>  fs/ext3/ordered-data.c      |  318 +++++++++++++++++++++++++
>  fs/ext3/super.c             |   48 +++
>  fs/jbd/transaction.c        |    1
>  include/linux/buffer_head.h |    3
>  include/linux/ext3_fs.h     |   33 ++
>  include/linux/ext3_fs_i.h   |   44 +++
>  include/linux/ext3_fs_sb.h  |    6
>  include/linux/ext3_jbd.h    |   11
>  include/linux/jbd.h         |   10
>  mm/filemap.c                |    1
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
