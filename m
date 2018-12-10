Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44174 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbeLJVFx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 16:05:53 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH] e2p: Print encoding information in superblock dump
References: <20181204211609.27477-1-krisman@collabora.com>
        <20181208183637.GD20708@thunk.org>
Date: Mon, 10 Dec 2018 16:05:48 -0500
In-Reply-To: <20181208183637.GD20708@thunk.org> (Theodore Y. Ts'o's message of
        "Sat, 8 Dec 2018 13:36:37 -0500")
Message-ID: <87h8flf5xv.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Tue, Dec 04, 2018 at 04:16:09PM -0500, Gabriel Krisman Bertazi wrote:
>> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
>> index a7586e094da1..bb1fc8aa94da 100644
>> --- a/lib/e2p/ls.c
>> +++ b/lib/e2p/ls.c
>     ....
>> +	if (encoding == EXT4_ENC_UTF8_11_0) {
>> +		if (flags & EXT4_UTF8_NORMALIZATION_TYPE_NFKD)
>> +			fputs(" NFKD", f);
>> +		else
>> +			fputs(" Unnormalized", f);
>> +		flags_found++;
>> +
>> +		if (flags & EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)
>> +			fputs(" NFKDCF", f);
>> +		else
>> +			fputs(" toUpper", f);
>> +		flags_found++;
>> +	}
>
> I don't understand this.  Why is "toUpper" the opposite of
> "CASEFOLD_TYPE_NFKDCF"?  From what I can tell looking at the kernel
> patches, it appears that if CASEFOLD_TYPE_NFKDCF is not specified, no
> case folding is done at all.  And it appears the opposite of "toupper"
> is "tolower" --- for ASCII case folding.

In order to allow any NLS charset to benefit from the
nls_strcmp/strncasecmp API I specified some default
normalization/casefold operations that could be implemented using the
hooks we already have.  The default was toUpper.  That was my thinking.
utf8 was originally split between utf8 and utf8n, the former being the
original unnormalized behavior.  If we didn't have CASEFOLD_TYPE_NFKDCF,
it used the toUpper method.

> More generally, we don't have a way of setting these flags, and I'm
> wondering if we should just make a decision and be done with it.
> After all, without any way of changing the flags, there's only one
> code path that is going to be well tested, and realistically user
> programs will come to *expect* only one way file systems will do
> things.  The MacOS world has discovered the hard way what happens if
> they try to change normalization conventions from one to another,
> leading to all sorts of confusion for application programmers.
>
> So perhaps we should just remove these flags from the superblock, and
> only support one way of doing things.  We ask the opinion of various
> stake-holders --- the Samba folks, fsdevel, Steam, etc.  But whether
> we decide NFC, NFD, NFKC or NFKD, I suspect we'll be better off just
> picking one and only one way of doing things.   WDYT?

My approach is over-complex, just to support the existing NLS tables.
Since Linus seems ok to move the code into a separate module and not
support other encodings, I agree we can make things much simpler, define
a single normalization/casefold and be done with it.

So, I will revive the first versions of this charset/unicode module.  We drop
these flags from the superblock, but we still store the encoding and the
encoding version in it, since it is useful to maintain stability of name
sequences.  We also support ASCII, alongside with utf8 because that is a
safer and pretty trivial.  Finally, do we revisit the decision to
provide a strict mode to reject invalid sequences?  I still think that
flag is useful.  Do we also want a flag to specify if the default is +F for
newer directories?

Do you agree?

-- 
Gabriel Krisman Bertazi
