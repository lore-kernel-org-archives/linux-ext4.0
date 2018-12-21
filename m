Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46133 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733119AbeLUTUj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2018 14:20:39 -0500
Received: by mail-lf1-f66.google.com with SMTP id f23so4632795lfc.13
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 11:20:37 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id n8-v6sm5271445lji.90.2018.12.21.11.20.36
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Dec 2018 11:20:36 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id t18-v6so5677768ljd.4
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 11:20:36 -0800 (PST)
MIME-Version: 1.0
References: <20181219071420.GC2628@infradead.org> <20181219021953.GD31274@dastard>
 <20181219193005.GB6889@mit.edu> <20181219213552.GO6311@dastard>
 <20181220220158.GC2360@mit.edu> <20181221070447.GA21687@infradead.org> <20181221154714.GA26547@mit.edu>
In-Reply-To: <20181221154714.GA26547@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Dec 2018 11:13:07 -0800
Message-ID: <CAHk-=wgdzWgoPSuHeVcqmGE1hB3Gan72r2_AhtC14e60=z45yg@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] fs-verity: add a documentation file
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-integrity@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2018 at 7:47 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Linus --- we're going round and round, and I don't think this is
> really a technical dispute at this point, but rather an aesthetics
> one.

Grr.

So honestly, I personally *like* the model of "the file contains its
own validation data" model. I think that's the right model, so that
you can then basically just do "enable verification on this file, and
verify that the root hash is this".

So that part I like. I think the people who argue for "let's have a
separate interface that writes the merkle tree data" are completely
wrong.

HOWEVER.

I do agree that your particular model is pretty damn broken in lots of ways.

Why is it filesystem specific? If the whole point is that the file
itself has its own verification data (which I like), then I don't see
why this is then documented as some filesystem-specific layout model.
That's complete and utter garbage.

In other words: either the model is that the file *itself* contains
its own merkle tree that validates the file, or it isn't. You can't
have it two ways. No silly "layout changes when you apply the hash"
garbage. That's just crazy talk and invalidates the whole model.

And honestly, I still think that it's very odd to add the merge data
to the end, when the filesystem already supports xattrs. It would have
made much more sense to just make one xattr contain the merkle tree
validation data.

So why is this sold as some unholy mess of "filesystem-specific" and
"generic"? That part just annoys the hell out of me. Why isn't this
sold as an *actual* generic model, where you just say "append the
merkle tree to the file, then enable verity testing of the end result
and validate the top-level hash".

That kind of thing could be done with absolutely _zero_ per-filesystem
code, and made 100% generic, and we'd just verify the merge data in
readpages().

So what's the excuse for doing the crazy odd "let's just support one
single filesystem" model?

                    Linus
