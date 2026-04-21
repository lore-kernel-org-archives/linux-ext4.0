Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4EC3BFE31
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776774101; cv=none; b=PgpBhdcUEbpFcqOQdF3UFgqvm8EgjRTVNbHWKZ8f2pOMD9jk89wN8oQKe2iNTIaF9hatHkzKYHYexdDDodGzozpSU1PuvWqXrKJlWYRvl2uCqAK0TIcuCHZNrtf4US0U0+HUyqD78vRbIVXTQvtY36Ndywisl4tRTIvfNR+yFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776774101; c=relaxed/simple;
	bh=ir2qpLEF9W/4SbJljtNFdjZqkj2uu7qHraFGp05BARs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZttwIQELxOFpRT82kH1VqixFDE2nH/Gm3P28+JLW+Inx/Bwf4qRfcpt9uLWXAn1IicUlOfIs7w8I1oDZ53QXkbmWlPur69FJRhi5MPc+z/h4etrfJ4kc7AHLA8oJ8fO1Yi3Lm1/uRud+ApPT67Lank+KEeI0A4I2eEsT9XF5Ptc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=pkdlZa6w; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="pkdlZa6w"
Received: from macsyma.thunk.org ([104.135.218.88])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63LCKxLM008615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 08:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776774063; bh=cCP/GiLV4jgKJUj1O8CpU0vvNekS1awqY3MHTI7mxpA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=pkdlZa6wh5ceiiWyd9egWE8yHLR9kUtWJQlAwcysBxuBaR32O8MZkQTZ8TtMb2UoR
	 8ocNQbfRrPSO/+UTd3IZjl5kTdqcYLU/nfz0uJJmc3UM84YgaV+qXNzGlWaALiYmrC
	 COLKnuXGvcXLJSU4mhmxX39U+DA33taeEcadr+c/wIBMG5dKQcaCUzlhPDuNRF35wd
	 /mlXAX5af5LDHZGZpKixSgZK8APFsJa3uQxOXVMLVOwLHh6H0JNqscFovjHTDdhnWf
	 PehsPFmDDNFbzY3IUmCk5tAL6yhrF0bhnuiNf60UfwqVZqTKvkXwECJCMmGApJfQkR
	 F/5qgFKiijvDQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 53178646F56A; Tue, 21 Apr 2026 08:20:59 -0400 (EDT)
Date: Tue, 21 Apr 2026 08:20:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zw Tang <shicenci@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, libaokun@linux.alibaba.com,
        jack@suse.cz, ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] ext4: BUG_ON in ext4_write_inline_data
 (fs/ext4/inline.c:240)
Message-ID: <20260421122059.GA86221@macsyma.local>
References: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>

On Tue, Apr 21, 2026 at 07:32:43PM +0800, Zw Tang wrote:
> This looks like an ext4 inline-data boundary/state inconsistency triggered
> while writing to an ext4 image crafted by syzkaller. The later
> KASAN: slab-use-after-free in rwsem_down_write_slowpath() appears to be a
> secondary effect after the primary ext4 BUG, likely during teardown/unlink
> after the filesystem failure.

Writing to a mounted image is not something that we consider a valid
threat model.  If you can write to a mounted image, there are a
zillion different ways that you can creash the kernel, or you can
create a setuid shell, etc.

The upstream syzkaller bot makes sure that CONFIG_BLK_DEV_WRITE_MOUNTED
is not defined to avoid syzkaller noise.

Out of curiosity, why are you running your own syzkaller instance?  To
the extent that you duplicate findings done by the upstream syzkaller,
or use bad configurations that waste the time of upstream maintainers,
you are simply accelerating the time when we consider all syzkaller
reports as a denial of service attack on upstream maintainers.

To the upstream syzkaller folkers, can you fix syzkaller so that
disabling CONFIG_BLK_DEV_WRITE_MOUNTED is hard-coded so that the many
people who insist on duplicating syzkaller instances without enabling
the syzkaller dashboard functionality don't make this configuration
mistake?

Thanks, regards,

					- Ted
