Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397BE611E
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 01:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773451842; cv=none; b=YgEZCZjUMnHV9EqBccHiJ3sP1IXS3kYsdjE5sBNTaqFK4mVOD34c5dAbxE2Gddhg6vlkWjyA64dtVuVk1zHmknuHlVoCjoUnD+geNiCgukYS13HJiqLAUqu55n5v+qglDhOG28w3bwA0bSvTquApOjUNRQ/1kgLe4Km5ZrF1ZgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773451842; c=relaxed/simple;
	bh=u3mgh3Q5/rMpgPHt4oTtkzFSh8OjHgYltZkqBO29Xrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1E3pPZMTECLMexwyAf5hlcw0iyJttDONs90R3r57AMw4Q6JIP+QkKHB0ai40sN/MME4xQ+44pEQj2woKfTMSSknQWaZ/Eqj2lZPuSIjXIjVtg+miw3ksJGyHovsqYBOBLyQ90dTvkvrQO5Tw2e4Xq4vgzdDn8IuiGlYZat6DGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=p9uWVYgs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="p9uWVYgs"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62E1UVCv023306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 21:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773451834; bh=4zJNuU1e0F4TqMNhCdZwFGVEsKs4UaSaoO++/onsT9k=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=p9uWVYgstJhZqv0w+507u3l98qexPQHUrLpIVoyqeRtzYuGZ2w7skbKJHXS0HjLnt
	 pMpt6ty7tXLlxRGb3s8l11iBM2A4y2Z9OqF5c/KT95ikbS5MibzZ3PHrI4EV4sbSXd
	 1tdCGNcASIciJmbmvWizAvjZ9nAeJxKnsRioGZyTqd+T5K2H4ohT0Z5J0yzbLjSYt8
	 5YRkpTpT/LCWYQ03JXKA/JUdHZhRwwnmFjoCS2Pqj6SNstnxedGn34OTkB37XqkhLj
	 60nuilCjKh8LmWl5dbpPMyop+fWSv4jqzYPRWlvPWxEBL3C4P1+t4aNkKI4kQIiOLG
	 5bGCaA3tI4V5Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9ABEA5D373D5; Fri, 13 Mar 2026 21:29:30 -0400 (EDT)
Date: Fri, 13 Mar 2026 21:29:30 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Helen Koike <koike@igalia.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-dev@igalia.com,
        syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix bigalloc cluster arithmetic when
 s_first_data_block != 0
Message-ID: <20260314012930.GB38016@macsyma-wired.lan>
References: <20260313151835.1248953-1-koike@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313151835.1248953-1-koike@igalia.com>

On Fri, Mar 13, 2026 at 12:18:30PM -0300, Helen Koike wrote:
> On filesystems with bigalloc enabled and s_first_data_block != 0,

This is never supposed to happen; fsck already checks for this.  From
e2fsck/super.c:

	should_be = (sb->s_log_block_size == 0 &&
		     EXT2FS_CLUSTER_RATIO(fs) == 1) ? 1 : 0;
	if (sb->s_first_data_block != should_be) {
		pctx.blk = sb->s_first_data_block;
		pctx.blk2 = should_be;
		fix_problem(ctx, PR_0_FIRST_DATA_BLOCK, &pctx);
		ctx->flags |= E2F_FLAG_ABORT;
		return;
	}

You can also see evidence of this code path getting trigger by
clicking on "corrupt_fs" in the Syzkaller dashboard.

> Introduce four macros that subtract s_first_data_block before
> operating, matching the coordinate system used by mballoc:

This is *way* more complicated than it needs to be.  All you need to
do is just reject the mount if the file system is this insanely
corrupted.  For example:

	if (ext4_has_feature_bigalloc(sb) &&
	    es->s_first_data_block) {
		ext4_msg(sb, KERN_WARNING, "bad geometry: bigalloc "
			 "file system with non-zero first_data_block");
		return -EINVAL;
	}

> Regarding the issue reported by syzbot...

Yeah, this is why I generally don't pay that much attention to syzbot
reports that mount a corrupted file system.  Users are supposed to run
fsck on a file system before they blindly mount it.  If they don't, I
don't consider it a security vulnerability; it's just a stupid system
administrator trick, and he or she deserves everything that happens to
them.  Hence, such issues are not a security issue, but just a quality
of implementation issue.  I'll accept patches to addrese sorts of
things, but it doesn't rate a CVE or high priority processing.

Furthermore, any fix needs to as simple as possible, and avoids adding
extra overhead especially on hot paths.  In this particular case,
rejecting the mount is the simplest fix, since the file system
corruption is *easy* to detect.

Cheers,

					- Ted
