From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] test-appliance: add new test configuration:
 ext4/lustre_mds
Date: Fri, 23 Jun 2017 19:08:19 -0400
Message-ID: <20170623230819.r5j63cmdb5aafdc2@thunk.org>
References: <20170609035943.26447-1-tytso@mit.edu>
 <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
 <20170609175910.shwqocbi3npfmoid@thunk.org>
 <087C00FA-AF13-498F-8D6A-B67A115D8DCE@dilger.ca>
 <20170623214109.3kwtxj3owi4noxda@thunk.org>
 <3625058A-4B6D-4C28-B231-61DFED33F0B4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>, G@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38462 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdFWXIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 19:08:22 -0400
Content-Disposition: inline
In-Reply-To: <3625058A-4B6D-4C28-B231-61DFED33F0B4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:00:05PM -0600, Andreas Dilger wrote:
> > Are you really using large_dir on a file system that is using indirect
> > block mapped files?
> 
> Like I wrote above, we haven't been using large_dir in production yet.
> My plan was only to use it on the MDT, which is where the filesystem
> namespace is located.  Indeed, we don't use extents on the MDT because:
> a) ext4 MDTs are strictly less than 16TB in size (usually < 8TB, even with
>    4B inodes) because of using "-I 2048" to limit the space per inode,
>    so they never need more than 2^32 blocks
> b) the only files of any size on the MDT are directories or other log
>    files, which are rarely created with contiguous block allocations,
>    so extents usually take more space than indirect blocks (12 bytes vs 4).

OK, I'll try adding large_dir to the luster_mds configuration.  I'm
not sure we're actually going to end up creating a directory with 3
levels of htree nodes, though.  In order to force that we'll probably
need to create a new ext4-specific htree stress tester which creates a
large number of filenames that very long, preferably while using a 1k
block file system.

					- Ted
