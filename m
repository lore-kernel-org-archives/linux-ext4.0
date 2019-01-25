Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42C8C282C3
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 00:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D047218D9
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 00:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="InXpXF9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfAYAf1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 19:35:27 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:40299 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYAf0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 19:35:26 -0500
Received: by mail-lf1-f44.google.com with SMTP id v5so5692213lfe.7
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 16:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BnVIWA/bqxaBN7mZRvqsnanUFf4GDlcibE52RUtQMjk=;
        b=InXpXF9+hhsBoLRbR4pMdXGqQe3cHhaCrz4rfHqoqarWQ5XUEL9rwAjAqHZD0K5YFT
         rm4qqmF2qtCn3M0LyRYl1EJu278USw4lDP0snNn8FEjpJ+Pj2uxxQHMbgFu3Fi9NLJ14
         wf07D97fgxquZ6Nlrt89ns54rxOFQsLPjHyxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BnVIWA/bqxaBN7mZRvqsnanUFf4GDlcibE52RUtQMjk=;
        b=mirA8QnOEXvEelZD5Ubj8cho6nNR8NNNrt2Dnn4kMHh9N1ecGOJyUzbm3xy1Zv+qB5
         pX2hBw8LDw+GLh2iaBFxi9YYqgi3UqRICOkaf22QhDCiDQvrXvaNT3mMhDR61D9WvHGP
         Dj0O4ySHJhpPmc5GKvhtdE/jjtNghpyR67I2iLRL8xQ0yLDG7PS5ra4ZIFNR+q1PO36L
         zSU41wM+2KZZVF/BymiT6WeDU4JcyVx9KoPGv4oO43wkNvYBPRaCP2MKt/G1FU2KQn2U
         CtBZ7h7NBfVHrCAzNMLfNwBLu5AHj5oaVF/IkArUp29Tndx67GSDzhYnrXYPtqp4QfNT
         jhNg==
X-Gm-Message-State: AJcUuke3WPn3o0UNZsfJDZuPtd2YdBZ/YEhPc+HKnZblBT1qvGetWVuC
        D1kShNTV2Rgw0pXG5CPSC2Bw6ZYdqZGsBw==
X-Google-Smtp-Source: ALg8bN7WXewMm0ynzzODLISJrGVBvtCqP0rXfKk7lh1nUzIxl8APFErOTEJQEKnB9VMDz9efj9hRvA==
X-Received: by 2002:a19:3fcf:: with SMTP id m198mr6283187lfa.106.1548376524184;
        Thu, 24 Jan 2019 16:35:24 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id h12-v6sm1213187ljb.80.2019.01.24.16.35.22
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 16:35:22 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id a16so5703652lfg.3
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2019 16:35:22 -0800 (PST)
X-Received: by 2002:a19:24c6:: with SMTP id k189mr6921466lfk.77.1548376522191;
 Thu, 24 Jan 2019 16:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20190110051500.GA32361@mit.edu> <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu> <20190124212544.GS6173@dastard>
 <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com> <20190124232237.GH8785@mit.edu>
In-Reply-To: <20190124232237.GH8785@mit.edu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Jan 2019 13:35:05 +1300
X-Gmail-Original-Message-ID: <CAHk-=wjw+tAKu7fM3GwUX9i7LBFuvB=ohqXj+KgQQaW3pCzfxg@mail.gmail.com>
Message-ID: <CAHk-=wjw+tAKu7fM3GwUX9i7LBFuvB=ohqXj+KgQQaW3pCzfxg@mail.gmail.com>
Subject: Re: Proposal: A new fs-verity interface
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 25, 2019 at 12:22 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
>
> > I understand that you don't want to load the whole merkle tree into
> > memory, and that is the reason that you want to point to some "stable
> > on disk" area, but the hole punching does seem to be a particularly
> > nasty part of it. It would be much better to have the merkle data in
> > some place where it doesn't then need to be hidden again, no?
>
> It's not really a "hole punch", but we are moving the data around.
> That's because Dave Chinner and Christoph demanded it.  The original
> approach was to put it at the end of the file, and then hide it.  If
> the question is "why hide the metadata", it's because it's metadata.
> We certainly don't want to make it be visible as part of the file
> stream.

But that's the whole hiding thing. Why do you feel you need to do
that? Why not just leave it alone, and leave it visible, and say "hey,
the merkle data for file X comes from here".

Punching a hole, or moving it somewhere else, or hiding or, or
whatever you want to do, all mean "you have to modify the filesystem".
They also mean "you can't back up the original sanely any more and
move it somewhere else".

Wouldn't it be much nicer to simple have a *separate* stream. If it's
not an xattr, then maybe just a separate file entirely. A file that
just contains the merkle data, and has no alignment things because
there's no "it's at the end of the file that it describes" issues,
it's just a standalone thing that is still visible so that you can
copy the original data and it's still valid (even if the merkle tree
then isn't _enabled_ in the copy, but now you could re-enable it in a
new location).

> We could store the metadata somewhere else --- for example, we could
> store it in another inode.  But inodes have overhead, and that would
> mean using two inodes for every fs-verity protected files --- and we
> don't need all of the other metadata (mtime, ctime, etc.) for the
> Merkle tree.

Well, if one of the issues is that the merkle data ends up being
megabytes, I don't see this as being  a huge issue. Particularly since
the alignemnt restrictions in the unified thing means that you still
aren't exactly "packing" the merkle data efficiently to begin with..

In fact, if you want to have merkle data for small files (where the
merkle data itself is just a  few words), then having it in a separate
file and as part of the inode inline data doesn't seem like it's
likely any worse (and might be *better*) than having it at some block
boundary due to alignment...

Hmm?

            Linus
