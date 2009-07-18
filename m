From: Theodore Tso <tytso@mit.edu>
Subject: Re: The flex_bg inode allocator
Date: Sat, 18 Jul 2009 08:36:08 -0400
Message-ID: <20090718123608.GD12744@mit.edu>
References: <d5ca277e0907172038x3dce5f8dx11d6ec4f7b0f3c52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38421 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZGRMgX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 08:36:23 -0400
Content-Disposition: inline
In-Reply-To: <d5ca277e0907172038x3dce5f8dx11d6ec4f7b0f3c52@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 17, 2009 at 08:38:18PM -0700, Xiang Wang wrote:
> 
> Recently I've found out that the flex_bg inode allocator(the
> find_group_flex function called by ext4_new_inode) is actually not in
> use unless we specify the "oldalloc" option on mount as well as
> setting the flex_bg size to be > 1.
> Currently, the default option on mount is "orlov".
> 

Actually, the "flex_bg inode allocator" is actually the older
allocator.  The newer allocator is still flex_bg based, but it uses
the orlov algorithms as well.  It has resulted is significant fsck
speedups as a result.  See:

http://thunk.org/tytso/blog/2009/02/26/fast-ext4-fsck-times-revisited/

> 1) What's the current status of the flex_bg inode allocator? Will it
> be set as a default soon?

It will probably be removed soon, actually...

> 2) If not, are there any particular reasons that it is held back? Is
> it all because of the worse performance numbers shown in the two
> metrics
> ("read tree total" and "read compiled tree total") in Compilebench?

I kept in case there were performance regressions with the orlov
allocator.  At least in theory for some workloads, the fact that we
are more aggressively spreading inodes from different directories into
different flex_bg's could potentially degrade performance; the reason
why we needed to do this, though, was to make the filesystem more
resistant to aging.

> 3) Are there any ongoing efforts and/or future plans to improve it? Or
> is there any work in similar directions?

Nothing at the moment.  I could imagine in the future wanting to play
with algorithms that are based on the filename (i.e., separating .o
files from .c files in build directories, etc. --- there's Usenix
paper that talks about other ideas long these lines), but in the
short-term, improving the block allocator, especially in the face of
heavy filesystem free space fragmentation, is probably the much higher
priority.  Nothing is immediately planned though.

If you're interested in trying to play with things along these lines,
I'd suggest starting with some set of benchmarks that test changes in
the inode and block allocators, both for pristine filesystems and
filesystems that have undergone significant aging.

Regards,

						- Ted
