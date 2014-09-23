From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: 23 Sep 2014 16:45:27 -0400
Message-ID: <20140923204527.20932.qmail@ns.horizon.com>
References: <0765A511-D5E2-4F00-8F2F-F5A8E76C0B03@dilger.ca>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: adilger@dilger.ca, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:44805 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756879AbaIWUp3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 16:45:29 -0400
In-Reply-To: <0765A511-D5E2-4F00-8F2F-F5A8E76C0B03@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the feedback!

> Simple, except that it introduces a serious bug in the code. It duplicates
> the previous on-disk encoding of:
>   DX_HASH_LEGACY | DX_HASH_UNSIGNED_DELTA =3D 3
> 
> with:
>   DX_HASH_SIPHASH24    3
> 
> and that will mean old filesystems would be considered corrupted.

Er... I'll let Ted tell me if I screwed up, but I went through
the code quite carefully figuring out what value to use, and
DX_HASH_LEGACY_UNSIGNED is *not* an on-disk encoding.

The only on-disk encodings are 0-2, with the "Unsigned delta" being an
internal-only way of representing EXT2_FLAGS_UNSIGNED_HASH.

You can see all that in patch 1/10, or even more clearly in the first
hunk of patch 9/10, where e2fsck pass 1 is modified to extend the range
of legal on-disk values:

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 4fc5311..a89e556 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2228,6 +2228,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 	if ((root->hash_version != EXT2_HASH_LEGACY) &&
 	    (root->hash_version != EXT2_HASH_HALF_MD4) &&
 	    (root->hash_version != EXT2_HASH_TEA) &&
+	    (root->hash_version != EXT2_HASH_SIPHASH24) &&
 	    fix_problem(ctx, PR_1_HTREE_HASHV, pctx))
 		return 1;
 
Looks to me like any other value (and in particular, the value 3)
appearing on disk is an error.

I didn't want to introduce a hole in the on-disk numbering, so
I bumped up the internal-only values.  Allowing that is what patches
1 and 6 of the series are for.

I can try clarify the comments if you find it confusing.

Alternatively, with Ted's permission, I can change DX_HASH_UNSIGNED_DELTA
to 256 (and rename it to show it's a bit flag) so it's obviously not
representable on disk.
-- 
	-Colin
