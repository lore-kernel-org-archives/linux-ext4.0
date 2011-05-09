From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: mounting ext3 with another superblock doesn't =?UTF-8?Q?work=3F?=
Date: Mon, 09 May 2011 13:47:41 +0000
Message-ID: <bc77e9fddac46b6a67f715a458190205@imap.dd24.net>
References: <031c613316176c32f09748706a086be2@imap.dd24.net> <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca> <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net> <20110509120608.GK4122@quack.suse.cz> <1304945969.11788.14.camel@heisenberg.scientia.net> <20110509131027.GM4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw01.dd24.net ([193.46.215.41]:47160 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1EINsL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 09:48:11 -0400
In-Reply-To: <20110509131027.GM4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 May 2011 15:10:27 +0200, Jan Kara <jack@suse.cz> wrote:
>   Well, the block size is most likely the same (4 KB) in both the old
and
> the new fs (unless you tinkered with it but I don't expect that). That
> defines size of a block group and thus position of inodes, bitmaps, etc.
> Another variable is a number of inodes (per group). If you have an old
> superblock you can compare the old and the new number of inodes and you
> can be sure. Otherwise you rely on whether the math in the mkfs with
which
> you've originally created the fs is the same as the math in your current
> mkfs (and you didn't specify any special options regarding this)...

Well I didn't change them but maybe Debian has modified the defaults in
mke2fs.conf since I created the fs initially.
inode_size = 256 could be a candidate. Unfortunately I don't remember
which Debian/e2fsprogs I've used to create the fs originally.

Was this ever set to 128 (i mean as a default for e2fsprogs itself, when
it was not set in mke2fs.conf)?


If the values would have actually changed, wouldn't this mean that all
data was then gone?


Cheers,
Chris
