From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext2: Do not update mtime of a move directory when
 parent has not changed
Date: Thu, 9 Apr 2009 13:20:44 -0700
Message-ID: <20090409132044.052b40ab.akpm@linux-foundation.org>
References: <1239302492-10455-1-git-send-email-jack@suse.cz>
	<20090409115132.9f7ccaf0.akpm@linux-foundation.org>
	<20090409191515.GB3886@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ronny.pretzsch@dfs.de, hare@suse.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759944AbZDIUXn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 16:23:43 -0400
In-Reply-To: <20090409191515.GB3886@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 9 Apr 2009 21:15:15 +0200
Jan Kara <jack@suse.cz> wrote:

> On Thu 09-04-09 11:51:32, Andrew Morton wrote:
> > On Thu,  9 Apr 2009 20:41:32 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > If the parent of the moved directory has not changed, there's no real
> > > reason to change mtime. Specs doesn't seem to say anything about this
> > > particular case and e.g. ext3 does not change mtime in this case.
> > > So we become a tiny bit more consistent.
> > > 
> > > Spotted by ronny.pretzsch@dfs.de, initial fix by J__rn Engel <joern@logfs.org>.
> > > 
> > > CC: ronny.pretzsch@dfs.de
> > > CC: hare@suse.de
> > > Acked-by: J__rn Engel <joern@logfs.org>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/ext2/namei.c |    5 ++++-
> > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> > > index 90ea179..556f258 100644
> > > --- a/fs/ext2/namei.c
> > > +++ b/fs/ext2/namei.c
> > > @@ -352,7 +352,10 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
> > >  	inode_dec_link_count(old_inode);
> > >  
> > >  	if (dir_de) {
> > > -		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
> > > +		/* Set link only if parent has changed and thus avoid setting
> > > +		 * of mtime of the moved directory on a pure rename. */
> > > +		if (old_dir != new_dir)
> > > +			ext2_set_link(old_inode, dir_de, dir_page, new_dir);
> > >  		inode_dec_link_count(old_dir);
> > >  	}
> > >  	return 0;
> > 
> > hm, what do other filesystems do?  We risk breaking things in either case.
> > Probably changing ext2 is safer than changing ext3/4, given that ext2 is
> > used less.
>   Yes, I think so as well. Looking more into what other filesystems do, it
> seems that FAT, UDF, reiserfs, ext3, ext4 actually never update mtime of
> the moved directory, even if the parent has changed. So maybe it would make
> more sence to change ext2 in this way as well. What do you think?

urgh, stop asking difficult questions.

Given that our behaviour here is basically random, I guess that nobody
is depending on it much.

Probably bringing everything into line with ext3 behaviour is safest. 
otoh we want the behaviour to a) be standards compiant and b) make
sense.

What _is_ the behaviour?

mkdir ./foo
mv ./foo ./bar

will update .'s mtime?  If so, that seems correct?

