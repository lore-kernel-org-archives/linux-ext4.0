From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2 23/31] mbcache: make mbcache naming more generic
Date: Wed, 21 Jun 2017 14:39:35 -0700
Message-ID: <CAAeU0aNHS3yfMRm3aeTq2YHqg58oQTE48Pi32rgt0YKJv5EOYA@mail.gmail.com>
References: <20170619085026.GD11837@quack2.suse.cz> <20170620090113.6658-1-tahsin@google.com>
 <6A43096F-633E-4FBF-9827-6EC36D92B659@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6A43096F-633E-4FBF-9827-6EC36D92B659@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andreas, I have incorporated your suggestions into another patch
that renames things in ext2/ext4 ("[PATCH 24/32] ext2, ext4: make mb
block cache names more explicit").

> Since we now also have the ea_inode cache, it would be better to rename
> s_mb_cache to s_mb_block_cache to make it more clear what it is.  That
> isn't strictly needed for ext2, but better to keep it consistent with ext4.

Done

> Minor nit - having a function-local variable named "ext2_mb_cache" and
> "ext4_mb_cache" makes it look like this is a global variable.  I think
> this name is left over from when it _was_ actually a single global cache
> rather than a per-filesystem cache.  It would be better to use a name
> like "mb_block_cache" to make it clear that this is the local block cache.

Done

> This local variable should be named "mb_block_cache" or similar.

Done

> s/ext4_mb_cache/mb_block_cache/
Done

> (style) no space after typecast
Fixed
