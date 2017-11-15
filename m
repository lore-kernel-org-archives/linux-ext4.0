From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for 4.15
Date: Tue, 14 Nov 2017 17:11:47 -0800
Message-ID: <CA+55aFw99_LwZNsUe3Nep=Gf+N5fj7eOSAr7s2vRDC+N1Yz6Mg@mail.gmail.com>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org> <20171113162534.5xta72w2boeaxk3s@thunk.org>
 <CA+55aFxbTtsf-WUhH0uY2=dzrn7BjsNuqFT0POD+pViyMwQBfg@mail.gmail.com> <20171115005656.6znjpa3ktqdre6dp@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35872 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbdKOBLt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 20:11:49 -0500
In-Reply-To: <20171115005656.6znjpa3ktqdre6dp@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 14, 2017 at 4:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
>    The e2fsprogs user space libraries all use
> EXT4_*_FL, and we can't change that without breaking applications
> depending on userspace, but we can keep things consistent in the
> kernel, and that probably means completely converting away from
> EXT4_*_FL, if possible.

So I don't think you'd necessarily need to convert from one to the
other, but wouldn't it be nice if you at least defined one in terms of
the other, ie something like

  #define EXT4_ENCRYPT_FL (1u << EXT4_INODE_ENCRYPT)

so that when you grep for one you see how they are directly related.

Now it was much less obvious, and I was nervous because that whole
series did introduce _different_ bits that were not in the same space
at all, and encoded the same thing (ie that S_ENCRYPTED bit).

Maybe this normally doesn't come up, but it was not all that obvious,
particularly since there was a lot of indirection:

 ext4_encrypted_inode() ->
    ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT) ->
        EXT4_INODE_BIT_FNS()

That EXT4_INODE_BIT_FNS thing was really fascinating to see.

So just confirming that yes,

   ext4_encrypted_inode()

is the same thing as

   EXT4_I(inode)->i_flags & EXT4_ENCRYPT_FL

was a real adventure.

Making it clear that EXT4_ENCRYPT_FL and EXT4_INODE_ENCRYPT are the
same bit would maybe have lessened the confusion at least a tiny bit.

Of course, not having five different ways to test the same bit would
have been even better.

Ok, I'm exaggerating.

But there really does seem to be a lot of different ways to check
i_flags bits, with some uses checking it directly, the places
_setting_ it using ext4_set_inode_flag(), and then other testers using
bit-specific helper.

And that somewhat confusing model seems to be true of pretty much all the bits.

As long as you can keep track of it, I guess it's fine.

            Linus
