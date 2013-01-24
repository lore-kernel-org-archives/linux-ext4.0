From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: allow for fs-specific objects to be pruned as part
 of pruning inodes
Date: Thu, 24 Jan 2013 00:58:16 -0800
Message-ID: <20130124005816.bce599de.akpm@linux-foundation.org>
References: <20130121170937.GB15473@gmail.com>
	<1358921168-30921-1-git-send-email-tytso@mit.edu>
	<20130123133231.GS2498@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AXI5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 03:57:17 -0500
In-Reply-To: <20130123133231.GS2498@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 24 Jan 2013 00:32:31 +1100 Dave Chinner <david@fromorbit.com> wrote:

> Also, the superblock shrinker is designed around a direct 1:1:1
> dependency relationship between the superblock dentry, inode and "fs
> cache" objects. i.e. dentry pins inode pins fs cache object.  It is
> designed to keep a direct balance of the three caches by ensuring
> they get scanned in amounts directly proportional to the relative
> differences in their object counts.  That can't be done with
> separate shrinkers, hence the use of the superblock shrinker to
> define the dependent relationship between the caches.

I was staring at the code and at the 0e1fdafd9 changelog trying to work
out why prune_super() does its weird shrinker-in-a-shrinker thing.  And
failing.

IOW it needs a code comment, please.  Ideally one which explains *why*
"It is designed to keep a direct balance of the three caches...".  What
would go wrong if the fs were to just register its own shrinker in the
expected manner?

