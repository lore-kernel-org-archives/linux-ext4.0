From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Sat, 24 Mar 2012 08:37:56 +0000
Message-ID: <20120324083756.GJ6589@ZenIV.linux.org.uk>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala>
 <20120322162825.GA4028@thunk.org>
 <20120322173150.GY6589@ZenIV.linux.org.uk>
 <CAMjpGUdnisfawUNThOu_+kbH54SWXCf6PhZwyWrV=B8SNjMRNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab2CXIiH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 04:38:07 -0400
Content-Disposition: inline
In-Reply-To: <CAMjpGUdnisfawUNThOu_+kbH54SWXCf6PhZwyWrV=B8SNjMRNg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 24, 2012 at 02:50:38AM -0400, Mike Frysinger wrote:

> > and that's it. ??blackfin and do_mounts_rd are doing the same thing (blackfin -
> > buggy, AFAICS).
> 
> buggy how ?  they're not exactly the same as the Blackfin code is
> setting things up for the uClinux MTD map.  it isn't parsing the
> filesystem itself (ignoring the size extraction from the superblock).

Compare and you'll see...  Block size on ext2 may be bigger than 1Kb;
->s_log_block_size gives the shift (1Kb -> 0, 2Kb -> 1, etc.)  Offset
0x18 in superblock, __le32...

Anyway, I've pushed that into vfs.git#master along with other minor stuff
right now; the last 5 commits in there are handling of ext2 and ext3 headers,
starting with "ext2: No longer export ext2_fs.h to user space" by
Thierry Reding, with the next 3 after it doing the move and trimming...
Should propagate to git.kernel.org in a few.

I've left the nfsd mess alone for now; it's too ugly to live, but I don't
want to trigger the bikeshedding from hell that happens every time somebody
brings pathconf() up.  Not worth bothering with, just to move two macros to
fs/ext2/ext2.h where they really belong...
