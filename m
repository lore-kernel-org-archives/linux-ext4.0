From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Status of META_BG?
Date: Sun, 18 Mar 2012 17:20:41 -0600
Message-ID: <A5C905B1-EC90-4C03-8157-4B2EBEEE5105@dilger.ca>
References: <4F620EDA.8030701@ubuntu.com> <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca> <4F622D18.3020805@ubuntu.com> <20120318204153.GA31682@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Phillip Susi <psusi@ubuntu.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35176 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2CRXT5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Mar 2012 19:19:57 -0400
Received: by gghe5 with SMTP id e5so5124003ggh.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Mar 2012 16:19:56 -0700 (PDT)
In-Reply-To: <20120318204153.GA31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-18, at 2:41 PM, Ted Ts'o wrote:
> On Thu, Mar 15, 2012 at 01:55:36PM -0400, Phillip Susi wrote:
>>> META_BG addresses both of these issues by distributing the group
>>> descriptor blocks into the filesystem for each "meta group" (= the
>>> number of groups whose descriptors fit into a single block).
>> 
>> So it puts one GD block at the start of every several block groups?
>> Wouldn't that drastically slow down opening/mounting the fs since
>> the disk has to seek to every block group?
> 
> Not necessarily; right now we pull in every single block group
> descriptor at mount time because we need to update s_free_inodes_count
> and s_free_blocks_count.  If we change things so that we only pull in
> the block group descriptors at mount time after a journal replay (but
> not after a clean umount, when the last inodes count and free blocks
> count should be correctly updated), that would avoid seeking to every
> 16th block group at mount time.  

The lazy init thread also walks all of the group descriptors in the
background after mount, so this could be handled asynchronously even
without any changes.

That is OK if there are free blocks and no user processes trying to
write files, but we've had slowdowns in the past due to block bitmap
lookups of every group looking for free space.  Loading the group
descriptors will be 32x or 16x faster than loading the bitmaps, but
we still saw delays of up to 10 minutes for filesystems under 16TB
due to seeking (before flex_bg) so I imagine this will also be an
issue with meta_bg.

It would be nice to retroactively define the semantics of flex_bg +
meta_bg to mean that 2^s_log_groups_per_flex group descriptors are
co-located.

Cheers, Andreas





