From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Date: Tue, 25 Nov 2014 17:32:11 +0200
Message-ID: <5474A0FB.1000504@gmail.com>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu> <1416599964-21892-3-git-send-email-tytso@mit.edu> <20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62961 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYPcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2014 10:32:18 -0500
In-Reply-To: <20141125043335.GF31339@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/25/2014 06:33 AM, Theodore Ts'o wrote:
<>
> 
> I was concerned about putting them on the dirty inode list because it
> would be extra inodes for the writeback threads would have to skip
> over and ignore (since they would not be dirty in the inde or data
> pages sense).
> 
> Another solution would be to use a separate linked list for dirtytime
> inodes, but that means adding some extra fields to the inode
> structure, which some might view as bloat.  

You could use the same list-head for both lists. 

If the inode is on the dirty-inode-list then no need to add it
to the list-for-dirtytime, it will be written soon anyway.
else you add it to the list-for-dirtytime.

If you (real)dirty an inode then you first remove it from the
list-for-dirtytime first, and then add it to the dirty-inode-list.

So at each given time it is only on one list

<>

Cheers
Boaz
