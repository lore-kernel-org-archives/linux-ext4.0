Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49892 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728990AbeKVGJL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2018 01:09:11 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 3/9] libe2p: Helpers for configuring the encoding superblock fields
References: <20181015211220.27370-1-krisman@collabora.co.uk>
        <20181015211220.27370-4-krisman@collabora.co.uk>
        <20181119042727.GH32299@thunk.org> <87efbht7bj.fsf@collabora.com>
        <20181121043216.GA14968@thunk.org>
Date: Wed, 21 Nov 2018 14:33:30 -0500
In-Reply-To: <20181121043216.GA14968@thunk.org> (Theodore Y. Ts'o's message of
        "Tue, 20 Nov 2018 23:32:16 -0500")
Message-ID: <87pnuydy45.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Nov 19, 2018 at 10:28:48AM -0500, Gabriel Krisman Bertazi wrote:
>> 
>> >> +#define UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
>> >> +#define UTF8_CASEFOLD_TYPE_NFKDCF	(1 << 4)
>
> Where do these values come from?  And why are they (1 << 1) and (1 << 4),
> respectively?
>
> I just noticed that these are used in utf8's default flags, when then
> end up getting set in the superblock.  So if these are official ext4
> code points, they should have a EXT4_ prefix, not a UTF8_ prefix.  It
> also seems that it's not possible to set them in mke2fs (only the
> "strict" flag can be set or unset in e2p_str2encoding_flags).

Hi,

They come from the nls.h kernel header.  These flags are passed to the
NLS system to describe the behavior of normalization/casefold functions.

In order to maintain compatibility to previous kernel users, the utf8
module (and others, eventually), still support the "no
normalization/casefold" policy (which I call 'plain' in the kernel).
When I merged utf8n into utf8, it became up to a flag set when loading
the nls table to decide what kind of normalization, if any, should be
done.

> So are we going to support something other than NFKD, or not?  If it's
> in the superblock, then we need to make sure the kernel does something
> sane if they are something other than the default.  And if we are just
> going to make it be a rule that all ext4 file systems with encoding
> type utf8 v10 will be NFKD, then we should let it be configurable in
> the superblock.

The NLS code in the kernel supports PLAIN and NFKD, but there is no real
reason for ext4 users to request PLAIN at all, which is only for
backward compatibility with filesystems that used the utf8 module
beforehand, so it can't be configured in e2fsprogs.  It still makes
sense to store the normalization type in the superblock though, in case
we support other normalization forms in the future and need to do some
conversion.

That said, I am not planning to support other normalization forms in
ext4 in the future.

If the kernel (nls_load_version) finds any value other than TYPE_PLAIN
(0x0) or TYPE_NFKD in the superblock when loading the NLS table, it will
fail the table creation, which, in turn,  fails the mount operation.

If you agree with the design above, I will just fix the EXT4_ prefix.

>
>> >> +
>> >> +static const struct ext4_sb_encoding_map {
>> >> +	char *name;
>> >> +	__u16 default_flags;
>> >> +} ext4_encoding_map[] = {
>> >> +	/* 0x0 */ { "ascii", 0x0},
>> >> +	/* 0x1 */ {"utf8-10.0.0", UTF8_NORMALIZATION_TYPE_NFKD|UTF8_CASEFOLD_TYPE_NFKDCF},
>
> It might be enough to just use "utf8-10.0".  Internally in the Unicode
> standard, they only use the X.Y notation, and given that we're already
> using the utf8 short-name, as opposed to something like "UTF-8
> encoding of Unicode 10.0.0", it might be better to shorten it to utf-8.
>
> I also noticed that Unicode 11.0 has been released in June 2018.  For
> poeple interested in scripts like Georgian Mtavruli (which has new
> case folding rules, so it's not just academic on our part), Hanifi
> Rohingya, Mayan Numberals, Historic Sanskrit etc., in their ext4 file
> names, I'm sure they'll appreciate it.  :-)
>
> Oh, and I think the FSF will be happier if we use Unicode 11.0, since
> it also features (in addition to a number of new emoji's), the
> Copyleft Symbol.  :-)

I can do the update!


-- 
Gabriel Krisman Bertazi
