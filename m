From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Thu, 10 Sep 2009 08:55:14 -0700
Message-ID: <6601abe90909100855h6ef60d32vfbbf23fa15fc66aa@mail.gmail.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
	 <20090909225429.GB24951@mit.edu>
	 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
	 <20090910013540.GF24951@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:3957 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZIJPzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 11:55:15 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n8AFtHiR024317
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 16:55:17 +0100
Received: from pzk14 (pzk14.prod.google.com [10.243.19.142])
	by zps35.corp.google.com with ESMTP id n8AFsU2G028081
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 08:55:14 -0700
Received: by pzk14 with SMTP id 14so183404pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 08:55:14 -0700 (PDT)
In-Reply-To: <20090910013540.GF24951@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 9, 2009 at 6:35 PM, Theodore Tso<tytso@mit.edu> wrote:
> On Wed, Sep 09, 2009 at 05:07:28PM -0700, Curt Wohlgemuth wrote:
>>
>> First, ext4_journal_forget() is called from ext4_forget() only when
>> we're journalling; without a journal, ext4_journal_forget() is only
>> called for various non-extent paths. =A0ext4_forget() could be chang=
ed,
>> of course...
>
> Ext4_forget() calls either ext4_journal_forget() or
> ext4_journal_revoke(). =A0So we need to fix up both functions.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0- Ted
>
> commit 4afdf0958f6f7b878e6d85cb4e0c0c12a0bd74e2
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Wed Sep 9 21:32:41 2009 -0400
>
> =A0 =A0ext4: Use bforget() in no journal mode for ext4_journal_{forge=
t,revoke}()
>
> =A0 =A0When ext4 is using a journal, a metadata block which is deallo=
cated
> =A0 =A0must be passed into the journal layer so it can be dropped fro=
m the
> =A0 =A0current transaction and/or revoked. =A0This is done by calling=
 the
> =A0 =A0functions ext4_journal_forget() and ext4_journal_revoke(), whi=
ch call
> =A0 =A0jbd2_journal_forget(), and jbd2_journal_revoke(), respectively=
=2E
>
> =A0 =A0Since the jbd2_journal_forget() and jbd2_journal_revoke() call
> =A0 =A0bforget(), if ext4 is not using a journal, ext4_journal_forget=
() and
> =A0 =A0ext4_journal_revoke() must call bforget() to avoid a dirty met=
adata
> =A0 =A0block overwriting a block after it has been reallocated and re=
used for
> =A0 =A0another inode's data block.
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index eb27fd0..ecb9ca4 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -44,7 +44,7 @@ int __ext4_journal_forget(const char *where, handle=
_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle, err);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bforget(bh);
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> @@ -60,7 +60,7 @@ int __ext4_journal_revoke(const char *where, handle=
_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle, err);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bforget(bh);
> =A0 =A0 =A0 =A0return err;
> =A0}

This looks quite reasonable to me.  And of course, your patch fixes
the brelse() calls that I added back in July.

Of course, validating this patch on my end will be tough; I need at
least a week of no corruptions to convince myself that the problem is
fixed, to the same degree that my call to sync_dirty_buffer() works.

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
