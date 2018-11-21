Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33540 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeKUPFF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 10:05:05 -0500
Date: Tue, 20 Nov 2018 23:32:16 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 3/9] libe2p: Helpers for configuring the
 encoding superblock fields
Message-ID: <20181121043216.GA14968@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-4-krisman@collabora.co.uk>
 <20181119042727.GH32299@thunk.org>
 <87efbht7bj.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87efbht7bj.fsf@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2018 at 10:28:48AM -0500, Gabriel Krisman Bertazi wrote:
> 
> >> +#define UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
> >> +#define UTF8_CASEFOLD_TYPE_NFKDCF	(1 << 4)

Where do these values come from?  And why are they (1 << 1) and (1 << 4),
respectively?

I just noticed that these are used in utf8's default flags, when then
end up getting set in the superblock.  So if these are official ext4
code points, they should have a EXT4_ prefix, not a UTF8_ prefix.  It
also seems that it's not possible to set them in mke2fs (only the
"strict" flag can be set or unset in e2p_str2encoding_flags).

So are we going to support something other than NFKD, or not?  If it's
in the superblock, then we need to make sure the kernel does something
sane if they are something other than the default.  And if we are just
going to make it be a rule that all ext4 file systems with encoding
type utf8 v10 will be NFKD, then we should let it be configurable in
the superblock.

> >> +
> >> +static const struct ext4_sb_encoding_map {
> >> +	char *name;
> >> +	__u16 default_flags;
> >> +} ext4_encoding_map[] = {
> >> +	/* 0x0 */ { "ascii", 0x0},
> >> +	/* 0x1 */ {"utf8-10.0.0", UTF8_NORMALIZATION_TYPE_NFKD|UTF8_CASEFOLD_TYPE_NFKDCF},
 
It might be enough to just use "utf8-10.0".  Internally in the Unicode
standard, they only use the X.Y notation, and given that we're already
using the utf8 short-name, as opposed to something like "UTF-8
encoding of Unicode 10.0.0", it might be better to shorten it to utf-8.

I also noticed that Unicode 11.0 has been released in June 2018.  For
poeple interested in scripts like Georgian Mtavruli (which has new
case folding rules, so it's not just academic on our part), Hanifi
Rohingya, Mayan Numberals, Historic Sanskrit etc., in their ext4 file
names, I'm sure they'll appreciate it.  :-)

Oh, and I think the FSF will be happier if we use Unicode 11.0, since
it also features (in addition to a number of new emoji's), the
Copyleft Symbol.  :-)

					- Ted
