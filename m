From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC -V2 1/4] ext4: Add configurable run-time mballoc
	debugging
Date: Tue, 11 Aug 2009 14:53:57 -0400
Message-ID: <20090811185357.GP1756@mit.edu>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu> <1249874635-24250-2-git-send-email-tytso@mit.edu> <d5ca277e0908111115g4274b419g490bc453eaf6e1bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>, Curt Wohlgemuth <curtw@google.com>
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbZHKSx6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 14:53:58 -0400
Content-Disposition: inline
In-Reply-To: <d5ca277e0908111115g4274b419g490bc453eaf6e1bd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 11:15:53AM -0700, Xiang Wang wrote:
> Hi Ted,
> 
> I tried to apply this patch to our kernel, but I encountered some
> problems in building the kernel:
> 
> FATAL: fs/ext4/ext4.o(.text+0x24f2d): Section mismatch in reference
> from the function exit_ext4_mballoc() to the function
> .exit.text:ext4_remove_debugfs_entry()
> 
> Looking at the code, the problem seems to be that, exit_ext4_mballoc
> calls ext4_remove_debugfs_entry. And ext4_remove_debugfs_entry has the
> "__exit" annotation while exit_ext4_mballoc does not. I tried removing
> the "__exit" annotation from ext4_remove_debugfs_entry and it builds
> well.

Good catch; I didn't notice because I wasn't compiling with
CONFIG_DEBUG_SECTION_MISMATCH=y.  Your fix is the right one.

				       	      	  - Ted
