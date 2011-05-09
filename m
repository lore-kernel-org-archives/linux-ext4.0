From: Jan Kara <jack@suse.cz>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 16:08:39 +0200
Message-ID: <20110509140839.GO4122@quack.suse.cz>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
 <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
 <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
 <20110509120608.GK4122@quack.suse.cz>
 <1304945969.11788.14.camel@heisenberg.scientia.net>
 <20110509131027.GM4122@quack.suse.cz>
 <bc77e9fddac46b6a67f715a458190205@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48725 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1EIOIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:08:40 -0400
Content-Disposition: inline
In-Reply-To: <bc77e9fddac46b6a67f715a458190205@imap.dd24.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-05-11 13:47:41, Christoph Anton Mitterer wrote:
> On Mon, 9 May 2011 15:10:27 +0200, Jan Kara <jack@suse.cz> wrote:
> >   Well, the block size is most likely the same (4 KB) in both the old
> and
> > the new fs (unless you tinkered with it but I don't expect that). That
> > defines size of a block group and thus position of inodes, bitmaps, etc.
> > Another variable is a number of inodes (per group). If you have an old
> > superblock you can compare the old and the new number of inodes and you
> > can be sure. Otherwise you rely on whether the math in the mkfs with
> which
> > you've originally created the fs is the same as the math in your current
> > mkfs (and you didn't specify any special options regarding this)...
> 
> Well I didn't change them but maybe Debian has modified the defaults in
> mke2fs.conf since I created the fs initially.
> inode_size = 256 could be a candidate. Unfortunately I don't remember
> which Debian/e2fsprogs I've used to create the fs originally.
> 
> Was this ever set to 128 (i mean as a default for e2fsprogs itself, when
> it was not set in mke2fs.conf)?
  Yes it was although relatively long time ago (several years).

> If the values would have actually changed, wouldn't this mean that all
> data was then gone?
  Not really because we store extended attributes in the additional 128
bytes of inode space and unless we see proper magic value we ignore the
contents. So you'd just silently loose every second inode I think.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
