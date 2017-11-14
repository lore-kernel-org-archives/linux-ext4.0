From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for 4.15
Date: Tue, 14 Nov 2017 12:59:17 -0800
Message-ID: <CA+55aFxbTtsf-WUhH0uY2=dzrn7BjsNuqFT0POD+pViyMwQBfg@mail.gmail.com>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org> <20171113162534.5xta72w2boeaxk3s@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:50404 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756615AbdKNU7T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 15:59:19 -0500
In-Reply-To: <20171113162534.5xta72w2boeaxk3s@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 13, 2017 at 8:25 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> I forgot to mention, there's a merge conflict when pulling the ext4
> and fscrypt trees.  The fixup is relatively straightforward:

It doesn't actually look all that straightforward, and in particular,
the resolution you sent me doesn't actually seem correct:

>                 new_fl |= S_NOATIME;
>         if (flags & EXT4_DIRSYNC_FL)
>                 new_fl |= S_DIRSYNC;
> -       if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
> -           !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
> -           !(flags & EXT4_ENCRYPT_FL))
> +       if (ext4_should_use_dax(inode))
>                 new_fl |= S_DAX;

This now loses the "!(flags & EXT4_ENCRYPT_FL)" test when it sets S_DAX.

Yes, in ext4_should_use_dax(), it has this code

        if (ext4_encrypted_inode(inode))
                return false;

but that test was what commit 2ee6a576be56 changed in favor of just
checking !(flags & EXT4_ENCRYPT_FL).

So that suggested merge resolkution actually undoes some of that
commit 2ee6a576be56.

Of course,

        (flags & EXT4_ENCRYPT_FL)

_should_ be the same as

        ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT);

so It does seem to be harmless, but it's a bit dodgy.

I'll do that suggested resolution, but I have to say that the ext4 bit
testing is incredibly broken and non-obvious. Just as an example:

  fs/ext4/ext4.h:#define EXT4_ENCRYPT_FL                  0x00000800
/* encrypted file */
  fs/ext4/ext4.h: EXT4_INODE_ENCRYPT      = 11,   /* Encrypted file */

yeah, it's the same bit, but it sure as hell isn't obvious. Why the
two totally different ways to define that data?

            Linus
