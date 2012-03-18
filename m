From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Status of META_BG?
Date: Sun, 18 Mar 2012 16:41:53 -0400
Message-ID: <20120318204153.GA31682@thunk.org>
References: <4F620EDA.8030701@ubuntu.com>
 <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca>
 <4F622D18.3020805@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51859 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab2CRUlx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 16:41:53 -0400
Content-Disposition: inline
In-Reply-To: <4F622D18.3020805@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 01:55:36PM -0400, Phillip Susi wrote:
> >META_BG addresses both of these issues by distributing the group
> >descriptor blocks into the filesystem for each "meta group" (= the
> >number of groups whose descriptors fit into a single block).
> 
> So it puts one GD block at the start of every several block groups?
> Wouldn't that drastically slow down opening/mounting the fs since
> the disk has to seek to every block group?

Not necessarily; right now we pull in every single block group
descriptor at mount time because we need to update s_free_inodes_count
and s_free_blocks_count.  If we change things so that we only pull in
the block group descriptors at mount time after a journal replay (but
not after a clean umount, when the last inodes count and free blocks
count should be correctly updated), that would avoid seeking to every
16th block group at mount time.  

						- Ted
