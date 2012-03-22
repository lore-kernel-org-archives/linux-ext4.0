From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 14:42:53 +0100
Message-ID: <20120322134253.GA19587@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
 <20120322103309.GA14484@quack.suse.cz>
 <1332415537.18717.21.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab2CVNm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:42:56 -0400
Content-Disposition: inline
In-Reply-To: <1332415537.18717.21.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-03-12 13:25:37, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
> > > However, if there is _no_ journal, the 'write_super' is initialized, and
> > > in many places the 's_dirt' flag is set, and thus VFS services seem to
> > > be actively used.
> >   Which many places are you speaking about? Grep shows 4 places with
> > sb->s_dirt = 1;
> 
> Well, with 'ext4_mark_super_dirty()' there are still 6 or something
> places.
> 
> >   You remove two of those in your cleanups so only
> > __ext4_handle_dirty_super() remains. That is called from 3 (4 after your
> > cleanups) places and they happen so rarely (during filesystem resize or
> > when we start using some feature on the filesystem) that if you use
> > sync_buffer() from all of them, it should be fine.
> 
> But AFAIKC, the whole '__ext4_handle_dirty_super()' also falls-back to
> marking the superblock as dirty if the file-system has no journal for
> some reasons, right?
  Yes. And I wrote that if you do sync_buffer(EXT4_SB(sb)->s_sbh) instead
of marking superblock dirty, it would be fine.

> But I do not really understand what
> 'ext4_handle_valid()' does. If I grep for 'ext4_handle_dirty_super()' -
> there are many places places where it is used, and a few are obviously
> for the superblocks.
  ext4_handle_valid() is false if and only if ext4 is in no-journal mode.
If I grep for ext4_handle_dirty_super() I see:
jack@quack:~/source/linux-fs/fs/ext4> grep "ext4_handle_dirty_super" *.c
ext4_jbd2.c:int __ext4_handle_dirty_super(const char *where, unsigned int line,
resize.c:	err = ext4_handle_dirty_super(handle, sb);
resize.c:	ext4_handle_dirty_super(handle, sb);
xattr.c:		ext4_handle_dirty_super(handle, sb);

  So not really many cases...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
