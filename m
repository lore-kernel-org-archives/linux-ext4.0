Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794838501;
	b=QrIm/T0+taT8RhHOUFUu1O5J5Z/Y7UAH8Jmlb4CDEXDls2pwzuWJEWcpFgvymSUqRgqs
	 UIYXiC42ucXBlBdzR2lcSIMgg2Y7GltUqoYVV6g4k55LY6IGN2R91SZK9RYRQFEMjkit3
	 3XgeNjhz7HiiS6BIu9mpaGaK2MCsLThr4Sz9GnvHCBsfrCohSRir38HFTgNXyPJKCwK0W
	 OiXj8oJWIc0wOd4ZBWFXeVvR6RTs7W0myBHHORoZogM7kDy4s0W0Je4pOY/vAXCNoSPPC
	 IAYLSSZ01WBlSJSH9ffb6+AXVd9fPxoyuIRBcKLe0mGVd+FANuDYl5Rt125T9yn5GKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838501;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Spam-Report:X-Spam-Score:X-Spam-Bar:
	 X-Rspamd-Score:X-Rspamd-Action:X-Rspamd-Bar;
	bh=2UkHVzyevf8mcT5oA3OyY73DOQDr9qNy1lyBRMiXQvc=;
	b=urB3K9nLrS3rxhsDkx3v6EIxMil9GNDSB4kwyNrQDdw2kROfR5zqYissC2Vn1aMZvJdP
	 IWuZg5dUR8XPG+1euGaEEuMoIBNvhpnYNjEs+R6sc6//tCn9EBugc2UpFnVBAIR7wS4a5
	 iNpexUGK/e9vlZvk0AGXOySQMv8mRfCgvxsSJMZAQA/4Q0hP6VvK/ZObWJKDNBneZrfJg
	 cEX6tx8XBqRD2HW4F75SuS53W8qKhF9QZ/I9Rm2GxqXZ0oYLgvZYwgDZElAPIyWCvdQ7b
	 z99Suy6OKTwZZp6je06fdICCJEd1fMFkppQ1lR3t16q+C3Fl6i54smhxi0AnXGriOmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=IyHsvvN+;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF62606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 14:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF62606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=IyHsvvN+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=2UkHVzyevf8mcT5oA3OyY73DOQDr9qNy1lyBRMiXQvc=; t=1794838499;
	x=2110198499; b=IyHsvvN+L+iz/STOUgkf2TRf32J/Thw3ftkI789r335RoweHcqJQEu/J6lk/n
	82jQ3CHZSRRUz3U/xGPyle6KXjqldSsmWLjaCQLw6vYwqK7+qrjvYeZWnu0m+aoZSfIzcRXoW+OSH
	hQtgPA2v3i2bGCSYdy9SItyCGAjj9Loj92FDi84dNqCGK6Eg32T03X8JqGNVVOCmZEVK8R/T4FFr1
	z6OSbJJxIftjW3nZXKL3+hgIH+V2Of7uVgT2SuxzYx/lGYKoB9cjOpXjZuR3Zoaju12lZPXHowyvx
	B5h5ZAEF7x1FVbrxHHzKpbFF0Hq9DMLV6/tRFe7uWD8P67Obew==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSxU0-00000000DmK-0DyG;
	Mon, 16 Nov 2026 15:14:56 +0100
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1xSxTz-0000000GWXT-0ySl;
	Mon, 16 Nov 2026 15:14:55 +0100
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1xSxTz-00FrZX-0U;
	Mon, 16 Nov 2026 14:14:55 +0000
Date: Mon, 16 Nov 2026 15:14:55 +0100
From: Alberto Garcia <berto@igalia.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <avsP3xlSwVjj3GJh@igalia.com>
References: <20261113162143.824544-1-berto@igalia.com>
 <20261113202745.GA29151@quark>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113202745.GA29151@quark>
X-Spam-Report: NO, Score=-4.9, Tests=ALL_TRUSTED=-3,BAYES_00=-1.9,KAM_DMARC_STATUS=0.007
X-Spam-Score: -48
X-Spam-Bar: ----
X-Rspamd-Score: -2.5
X-Rspamd-Action: no action
X-Rspamd-Bar: --

On Fri, Nov 13, 2026 at 12:27:45PM -0800, Eric Biggers wrote:
> A few comments on the diff:
> 
> >  tests/f_encrypt_feature_missing/image.gz   | Bin 0 -> 5566 bytes
> 
> This image has a 4096-byte block of incompressible ciphertext in it.
> An empty file would exercise this new code just as well and result
> in a filesystem image of around 1.5 KB.

Sounds good, I'll update the test.

> > @@ -389,6 +389,13 @@ int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
> >  		return 0;
> 
> The function comment of add_encrypted_file() should be updated to
> mention the new behavior.

Done.

> > +	/* The inode is encrypted, so the filesystem needs the encrypt feature */
> > +	if (!ext2fs_has_feature_encrypt(ctx->fs->super) &&
> > +	    fix_problem(ctx, PR_1_ENCRYPT_FEATURE, pctx)) {
> > +		ext2fs_set_feature_encrypt(ctx->fs->super);
> > +		ext2fs_mark_super_dirty(ctx->fs);
> > +	}
> 
> I'm a little surprised the fix is to set the feature flag, rather
> than clear the inode.  It looks like e2fsck does this for other
> feature flags though, so I guess this is consistent with that.

That's also what I understood from the previous conversation at
https://lore.kernel.org/linux-ext4/armU51iuvA9d7zvR@igalia.com/

So this patch assumes that the inode is correctly encrypted but the
feature flag is missing (because it was accidentally removed or
something).

A different situation would be if the inode has the encryption flag
when it shouldn't, but the basic case is already handled by e2fsck
(would we need an additional test for this?):

# dd if=/dev/zero of=image bs=4096 count=128
# mke2fs -b 4096 -N 128 image
# debugfs -w -R "mkdir edir" image
# debugfs -w -R "sif edir flags 0x800" image
# e2fsck -vf image
e2fsck 1.47.4 (6-Mar-2025)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 has encrypt flag but no encryption extended attribute.
Clear flag<y>?

Other possibilities:

- The flag is set, the xattr is corrupt: this is already checked
  (immediately before the code added by this patch).
- The flag is unset, the xattr is present: this situation is
  not detected, but I don't think it has any consequences?
- The flag is set, the xattr seems valid (or unknown) although the
  file is not supposed to be encrypted. This is the only problematic
  case, here e2fsck would suggest to set the feature flag. But this
  looks like a very unlikely scenario, or am I missing something?

> Given that it's done this way, though, let's consider the case
> where the user declines to fix this problem, either interactively
> or via 'e2fsck -n'.  In that case, the problem gets reported for
> all thousands/millions of inodes that could have the problem.
> Perhaps it should be reported only for the first, by checking
> 'info->file_ranges_count == 0'?

Yes, I think that's a good idea, thanks for the suggestion.

> > +	/*
> > +	 * Encrypted inode found but the filesystem is missing the
> > +	 * encrypt feature
> > +	 */
> > +	{ PR_1_ENCRYPT_FEATURE,
> > +	  N_("@i %i is encrypted but @S is missing ENCRYPT feature\n"),
> > +	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
> 
> Isn't this missing '/* xgettext:no-c-format */'?

Hmmm... I think you're right, and it looks like there are more strings
with this problem on the same file. I was using other entries as an
example and I didn't notice this.

Berto
