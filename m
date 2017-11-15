From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 4.15
Date: Tue, 14 Nov 2017 19:56:56 -0500
Message-ID: <20171115005656.6znjpa3ktqdre6dp@thunk.org>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org>
 <20171113162534.5xta72w2boeaxk3s@thunk.org>
 <CA+55aFxbTtsf-WUhH0uY2=dzrn7BjsNuqFT0POD+pViyMwQBfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45838 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753282AbdKOA5D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 14 Nov 2017 19:57:03 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFxbTtsf-WUhH0uY2=dzrn7BjsNuqFT0POD+pViyMwQBfg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 14, 2017 at 12:59:17PM -0800, Linus Torvalds wrote:
> Of course,
> 
>         (flags & EXT4_ENCRYPT_FL)
> 
> _should_ be the same as
> 
>         ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT);

And in the second is the preferred way to do things, actually.

> I'll do that suggested resolution, but I have to say that the ext4 bit
> testing is incredibly broken and non-obvious. Just as an example:
> 
>   fs/ext4/ext4.h:#define EXT4_ENCRYPT_FL                  0x00000800
> /* encrypted file */
>   fs/ext4/ext4.h: EXT4_INODE_ENCRYPT      = 11,   /* Encrypted file */
> 
> yeah, it's the same bit, but it sure as hell isn't obvious. Why the
> two totally different ways to define that data?

Yes, it's non-obvious and ugly.  Sorry about that.

We originally used EXT4_*_FL, and we needed to use the bit number
encoding so we could use test_bit().  We just never converted all the
way over.

We do have a way to make sure the two ways of defining a bit position
are in sync; see ext4_check_flag_values() and CHECK_FLAG_VALUE in
ext4.h.  It's a bit gross, and we probably should clean this up, at
least in the kernel.  The e2fsprogs user space libraries all use
EXT4_*_FL, and we can't change that without breaking applications
depending on userspace, but we can keep things consistent in the
kernel, and that probably means completely converting away from
EXT4_*_FL, if possible.

       	   	      	 	  - Ted
