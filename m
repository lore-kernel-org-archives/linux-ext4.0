Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33A63845A3
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775429712; cv=none; b=s6DsQnIHhUyMoSeyUlN99ZK41Tcb1JCj1zzrLrNyyEGVco4mqLlgotFlDD0lXTx3P8Vmaye6NqmkccdBXv4Lc6HD1nUB97Z/RzBTbSscSj+Ns0xV+ilbkqHhBDCRkNKztiDuYvr3AiExS5TWU6kTURxmJLnijvPrhn6Kx+8zNG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775429712; c=relaxed/simple;
	bh=Wlx2jjMrH0FxKcAR0UxoZkv28T0av6CJ3xlkfnli3zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXrywjeNJq5LJAiK75BS9fGUqZtDVhw1U+HifI05Cq8Hid152HIDFlclIAD9+e7iMhBGoXqRaAkRP/Zs8mzt8FWZilhYDppIgSlP/PVNfrMrjfbz88ntmy8exIU/SDLra81XPk2CUM7AlyDcUSpO8k7LpgpSiiY8mht1QLSQmTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=WXmTsZcX; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="WXmTsZcX"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 635Msg1r009981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 5 Apr 2026 18:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775429685; bh=is0uAhPmS8GmcK5xBjDF7hNxAIaVmzS7E4WlgjWx0y0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=WXmTsZcXjnAH+QijBhduXaathityRpjrZMCQnbtSjFw4ZMkBpj3bEOuOC6SUrSDhF
	 bnTz84oUXf/YsR6dOxEL3tMnKvWMGyK0a48Sl/KV8LpHpe66YvLfZFHv5gLcOnaepc
	 iU1F8v6KAwIpIvBi+O9khI4SLWOadDDq0yjMVVad4H26FjLuiP5+alUzL3Tg+UwUxM
	 tg7kfJbNXNYkZ4nGCcVnsFVL5JZdK3lQjfLoSQtZVLvPoqDI8/wUyRF6/jPs3BZg/p
	 Amo4XTccHxRfmoOZQ4JqAKdtLnqGf909H212R4yVlvaiLc75wwjy4oip7n1J27X0JZ
	 c+1a3ssusdr9Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A498F6197604; Sun,  5 Apr 2026 18:54:42 -0400 (EDT)
Date: Sun, 5 Apr 2026 18:54:42 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Sean Smith <defendthedisabled@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, david@fromorbit.com,
        brauner@kernel.org, osandov@osandov.com, almaz@kernel.org,
        hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260405225442.GA1763@macsyma-wired.lan>
References: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405195007.1306-1-DefendTheDisabled@gmail.com>

On Sun, Apr 05, 2026 at 02:49:56PM -0500, Sean Smith wrote:
> 
>   1. Application atomic saves destroy xattrs. Programs that save
>      via write-to-temp + rename() replace the inode, permanently
>      destroying all extended attributes. Only the VFS sees both
>      inodes during rename -- no userspace mechanism can intercept
>      this and copy metadata across.

The VFS could potentially copy the xattr on a rename, no?

>   2. Every tool in the copy chain must explicitly opt in to xattr
>      preservation. cp requires --preserve=xattr, rsync requires -X,
>      tar requires --xattrs. Each missing flag causes silent data
>      loss. Transparent preservation through arbitrary tool flows
>      is not achievable in userspace.

But this is true for your proposed ptime as well.  You have to change
every single tool to copy over the ptime.  Worse, you have to change
the format of tar in a non-standard on-disk format change to support
this new ptime timestamp.  And rsync will require a non-standard
protocol change to support the new timestamp.

> Atomic saves are the default behavior of mainstream applications
> (LibreOffice, Vim, Kate, etc.).

You will also have to change mainstream applications to copy ptime
from the original file to the file.new before the atomic rename.
Using ptime doesn't change this.  So you will need to make this
non-standard, Linux-specific change to all of these mainstream
applications.

Is it worth it?  It's a huge amount of cost being spread across a very
large part of the open source ecosystem just this fairly narrow use
case.  Personally, I'm not convinced it's worth the effort.

						- Ted
