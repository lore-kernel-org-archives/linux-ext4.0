Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36752 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729715AbeKTBws (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2018 20:52:48 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 3/9] libe2p: Helpers for configuring the encoding superblock fields
References: <20181015211220.27370-1-krisman@collabora.co.uk>
        <20181015211220.27370-4-krisman@collabora.co.uk>
        <20181119042727.GH32299@thunk.org>
Date: Mon, 19 Nov 2018 10:28:48 -0500
In-Reply-To: <20181119042727.GH32299@thunk.org> (Theodore Y. Ts'o's message of
        "Sun, 18 Nov 2018 23:27:27 -0500")
Message-ID: <87efbht7bj.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Oct 15, 2018 at 05:12:14PM -0400, Gabriel Krisman Bertazi wrote:
>> +#define EXT4_ENC_STRICT_MODE_FL		(1 << 0) /* Reject invalid sequences? */
>
> Why the question mark?

Hi Ted,

The question mark is very redundant for a flag, I admit :).  It meant to
say "Whether to reject invalid sequences" or something like that.  Will
fix in the v2.

>> +#define UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
>> +#define UTF8_CASEFOLD_TYPE_NFKDCF	(1 << 4)
>> +
>> +static const struct ext4_sb_encoding_map {
>> +	char *name;
>> +	__u16 default_flags;
>> +} ext4_encoding_map[] = {
>> +	/* 0x0 */ { "ascii", 0x0},
>> +	/* 0x1 */ {"utf8-10.0.0", UTF8_NORMALIZATION_TYPE_NFKD|UTF8_CASEFOLD_TYPE_NFKDCF},
>> +	{0x0, 0x0},
>> +};
>> +
>>  #endif	/* _LINUX_EXT2_FS_H */
>
> What uses this?  I can't find any other references in either the kernel or
> e2fsprogs patches.

Only the instance ext4_encoding_map, itself, is used in this patch and
in the next one, which modifies mkefs.  It stores the string for
comparison with what the user passed in the command line.

I guess naming the structure is unnecessary, since we have only this
single const static instance.  I will change that in the v2, as well.

The current series doesn't include the huge utf8 stuff, which makes use
of the rest of the flags, but I will add that in v2 as well.


Thanks!

-- 
Gabriel Krisman Bertazi
