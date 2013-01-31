From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Thu, 31 Jan 2013 13:39:30 +0100
Message-ID: <20130131123930.GA4612@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
 <87a9rpssj8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab3AaMjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 07:39:42 -0500
Content-Disposition: inline
In-Reply-To: <87a9rpssj8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-01-13 11:47:23, Dmitry Monakhov wrote:
> On Thu, 24 Jan 2013 13:49:45 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > On Fri, 18 Jan 2013 13:00:38 +0100, Jan Kara <jack@suse.cz> wrote:
> > > Merging of uninitialized extents creates all sorts of interesting race
> > > possibilities when writeback / DIO races with fallocate. Thus
> > > ext4_convert_unwritten_extents_endio() has to deal with a case where
> > > extent to be converted needs to be split out first. That isn't nice
> > > for two reasons:
> > > 
> > > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > > 2) It complicates end_io handling code
> > As we already discussed your idea is 100% correct, but even with
> > what patch I still able to trigger situation where split it required.
> > I've got following error with this patch applied on top of 7f5118629f7
> > EXT4-fs error (device dm-3): ext4_convert_unwritten_extents_endio:3411:
> > inode #12: comm kworker/u:4: Written extent modified before IO finished:
> > extent logical block 1379787, len 64; IO logical block 1379787, len 21
> > 
> > ------------[ cut here ]------------
> > WARNING: at fs/ext4/extents.c:4518
> > ext4_convert_unwritten_extents+0x149/0x210 [ext4]()
> OK I've found it. I'm a bit disappointed, it is even not a race
> condition, but simple corruption.
> Patch is available here: http://article.gmane.org/gmane.comp.file-systems.ext4/36762
> link for sain mailer client: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
> After this bug was fixed it is safe to apply both Jan's patches:
> [PATCH 04/12] ext4: Disable merging of uninitialized extents
> [PATCH 05/12] ext4: Remove unnecessary wait for extent conversion in ext4_fallocate()
> At least it survives after all my tests.
  Thanks for debugging this. I was looking into the code but it didn't come
to my mind what happens when ext4_ext_split() fails.
 
> BTW: It is appeared that ext4_debug() infrastructure is almost unusable
> because based on printk() instead of light-wait event tracing infrastructure.
> I'm now work on patch-set which fix that.
  That would be certainly welcome. ext4_debug() infrastructure comes from
times when tracing didn't exist so we used what we could. These days it's
cumbersome...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
