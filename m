From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Fri, 11 Jul 2014 07:43:59 -0400
Message-ID: <20140711114359.GA433@thunk.org>
References: <20140704184539.GA11103@thunk.org>
 <20140707141701.2f9529af@archvile>
 <20140707155310.GB8254@thunk.org>
 <20140707225619.GD8254@thunk.org>
 <20140710185748.GA26636@wallace>
 <20140710200126.GE10417@birch.djwong.org>
 <CAFnufp2yDsbHby6Ye-Ldjz=qGWyxOJUMv8JZJa-5+f6CUFSpYw@mail.gmail.com>
 <20140710223245.GB12018@thunk.org>
 <20140711001334.GF10417@birch.djwong.org>
 <20140711004507.GB26636@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Matteo Croce <technoboy85@gmail.com>,
	David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org, Azat Khuzhin <a3at.mail@gmail.com>
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57843 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaGKLoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2014 07:44:07 -0400
Content-Disposition: inline
In-Reply-To: <20140711004507.GB26636@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2014 at 08:45:08PM -0400, Eric Whitney wrote:
> 
> Reverting the suspect patch - 007649375f - on 3.16-rc3 and running on the
> Panda yielded 10 successive "successful" generic/068 failures (no block
> bitmap trouble on reboot).  So, it looks like that patch is all of it.

Thanks again Eric, for finding this!!

> Running the same test scenario on Darrick's patch (CONFIG_EXT4FS_DEBUG =>
> CONFIG_EXT4_DEBUG) applied to 3.16-rc3 lead to exactly the same result.
> No panics, BUGS, or other misbehavior whether generic/068 completed 
> successfully or failed (and that test used here simply because it was
> convenient) and no trouble on boot, etc.

I've been looking more closely at the changes in line, and I suspect
the real fix is that we should move these lines:

	ext4_free_blocks_count_set(sbi->s_es,
				   EXT4_C2B(sbi, ext4_count_free_clusters(sb)));
	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));

after the journal is run.  Not that it really matters since so very
little (and nothing for normal file system operation, including the
statfs(2) system call) actually depends on the free blocks count in
the superblock --- instead we the percpu "s_freeclusters_count" and
"s_dirtyclusters_counter" fields for scalability reasons --- but if we
*are* going to set these fields in the on-disk superblock, we should
wait until *after* we have updated the allocation bitmaps before we
start counting the free blocks in those bitmaps.

Cheers,

					- Ted
