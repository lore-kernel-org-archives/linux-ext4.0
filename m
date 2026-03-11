Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0432C2D3ECF
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250088; cv=none; b=dgTb2xOjg/hl0V6tpSjTW1GuOI8xhnQb4cN/qk680nTaDcFSnfWG9zCj17XecHTFo0mnchjdgUcW73X4HD/c0wkwI26Yo35KB590+/R7B99EBnYrNnnvmu2+1AYUXJbUwqXlJfp03WNkbM4+E4mDgpu8SNhqgHNCw/iHpD7EZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250088; c=relaxed/simple;
	bh=gqzSGSSd3yfyFfUK1NDsc6qhKFKAqcEliRBZbJiduzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFP/FNMoHCIZbhin5qaBSakAoxg6VMuDF1e6B7OEz6Ly3M4BV97qACiHMLP1Ahxdo8vpIcDAGQHUeIPw7NHeTOOZV0JvC08zPvwFCSho065YDrhFVxJCrcUtfc0jXPs2Ii9WzLzUlwkdpYRzmBOAH4CvmRX0tBhvO0Y8uiqEAa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=G2KdIGEf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="G2KdIGEf"
Received: from macsyma.thunk.org (pool-173-48-111-151.bstnma.fios.verizon.net [173.48.111.151])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62BHRtaD026642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 13:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773250077; bh=P/eUmh/qmdQMrTW1SANMr5bb1UVvOEpqm959TzZf0Xs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=G2KdIGEf6S4UquF2twD4QgLz7eOxF4Hn1Ry7QwzJ9+kVOreHnYzsT4PtDamw1CPR+
	 4EAvhl/fOzqjsQBCa/UXBBZzjfrzBK5MiVwp2ohEfd0TtP91cMWcLUfQ9Iapnq5xLv
	 FW5+m4ej7VVReXrp635oJ4jVeqZmpuZjkDiJ6F1LmmF4a+88IZO9Z2HYl0260XJktA
	 TEDvxGILe8Ip4IkrpTqZQ35OvpjIsqh72ZZxe45NGertkOzljwk3bk6607Jm/M9ZVC
	 zN3z1sVS0KAqabMQJE6PV/naqTDsD+BTu62rwdxSKaL+7wiNhpH7CNWvUUQtwVnG0g
	 qTqMzaxYnvhSQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 3F76D5C77D7B; Wed, 11 Mar 2026 13:27:55 -0400 (EDT)
Date: Wed, 11 Mar 2026 13:27:55 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Fix default orphan file size calculations
Message-ID: <20260311172755.GA74864@macsyma-wired.lan>
References: <20260311141150.120724-1-tytso@mit.edu>
 <d4d64000-6b55-449e-83bb-be438aaa5146@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4d64000-6b55-449e-83bb-be438aaa5146@linux.alibaba.com>

On Thu, Mar 12, 2026 at 12:27:07AM +0800, Baokun Li wrote:
> 
> In fact, the patch that introduced it was not the latest version —
> there was a later v3 that is consistent with the upstream kernel:

Hmm, I wonder why b4 didn't pick up the newer version of the patch.
Maybe I screwed up and missed the -c option to "b4 am -c".

The main difference between my proposed fix and your v3 patch is that
if the user doesn't specify an explicit orphan file size, with the v3
patch, it might max out to 8MB when the block size is 64k.  With my
fix, it will max out to 2MB in those situations.  The user can
explicitly specify a orphan file size as 8MB, but it makes the default
to be 2MB.

In retrospect, I think we went wrong when we capped the orphan file in
terms of bytes instead of blocks in the kernel.  When the block size
is 64k, 8MB is only 32 blocks.  When the block size is 4k, the orphan
file size can be up to 512 blocks.  And the scalability is really a
function of the number of blocks, not the number of bytes, since with
the orphan file, we use a hash that maps the cpu number to a logical
block number in orphan size.

Now, most of the time, I suspect 32 blocks is plenty most of the time,
since it's unlikely we'll have that many running processes trying to
truncate files or something else that requires adding the inode to the
oprhan file.

So I thought about just using a default orphan inode size of 32 file
system blocks.  I also thought about changing the kernel to allow size
of the orphan file to be say, up to 256 blocks.  And also maybe
allowing mke2fs and tune2fs to accept an extended options
orphan_file_blocks which takes an argument denominated in blocks.

Ultimately, though, *most* of the time, consuming 512MB on the orphan
file inode if the file system is say, 2TB.  So I decided it wasn't
worth the effort to change how things worked.  But if we were starting
from scratch, I think we would have been better of doing things in
terms of blocks, instead of bytes.

But maybe we should go and make that change.  What do folks think?

    	     	       	   	     	      - Ted
