Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C83BFE4C;
	Mon, 27 Jul 2026 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178875; cv=none; b=Ouivww19FTgg92tosu+2WpQ0iAWl8iqu4cMh1JupxSJOV6ZwFgSTYglOIVjbGPBbmf/BAp51jrto9NeWA/NYp/SN8n1jBf71eaK4SlnS1p+sVl8wOwdLG/nWnKOpDiEpACYZ3tA4L2JKpGsrmFjt5u1Bg+VNZTZ8Mbe+C9mZIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178875; c=relaxed/simple;
	bh=FJmtOlXCNmZjBnuujI9bRuVtzotLM7cqYndwuQX87Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5QHrjhHdGnvZMSZIfIBlnF9msrSn3uDb+U+gR9BdRJTH7pZ9qSCUwgztFHeusyLgexXakpdmdQ06eXcJ9iuQsPp/x+R7v7zZ1EjnxoDCeDEXUdtkdAHWMxcXJbH+H2lh4/Bk0lKKHu20omyGIyKGaeSWHqKSDHHmuHMQa9xJ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvUwf0Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvUwf0Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF36A1F000E9;
	Mon, 27 Jul 2026 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785178870;
	bh=lOM3+/ArmElaVBagK5nXaINqmLTL/39uAuEGwZrL8Bw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZvUwf0VcS2GvIzsnddkbjdC/1ENpfxhE+C8yKI6abKgfp6bOMzjoXVjX+dO30vrkU
	 1oKmT+qwpYrSoQ0o5JBVjLy4a556GydOE2OQGF+ejfn6QgbbVdmT6955AiKypFk49A
	 10jc7boWP9wLdQG/5M+OlhNr/eIhgraQhDlaDd8ne/9dcbQSkSc/UoXXmYBmWHZz7E
	 J+z2+pJSivr1ivC4RLRUThgz0faAJM4PNZ/b4oNrmdDDGcfxNJZ56+4N63pETVqtjP
	 LO8KpwlwJPjouPs6TloLFwwYJWv8j0LkheioSosDEqQGZSzJiH9ot076sJRa3fz3Y+
	 zszh0tGw4gElw==
Date: Mon, 27 Jul 2026 19:01:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <20260727190108.GB1021387@google.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723085648.1500357-1-ojaswin@linux.ibm.com>

On Thu, Jul 23, 2026 at 02:26:48PM +0530, Ojaswin Mujoo wrote:
> Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> flag. This is because the newly created inode ends up with the following:
> 
>   __ext4_new_inode()
>     ext4_set_inode_flags(init=true) // sets S_DAX
>       fscrypt_set_context()
>         ext4_set_context()
>           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
>                                               doesn't clears S_DAX
>       ext4_set_aops
>         inode->i_mapping->a_ops = &ext4_dax_aops;
> 
> Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> silently ends up bypassing encryption completely. This is reflected in
> multiple xfstests failures like generic/548. To fix this, ensure we disable
> S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> is safe to change DAX state there because ext4_set_aops() later can
> correctly detect S_DAX unset and assign the correct aops.
> 
> The fix was actually the intended behavior however it seemed to have
> silently changed in 043546e46dc7.
> 
> Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> Reported-by: Disha Goel <disgoel@linux.ibm.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Acked-by: Eric Biggers <ebiggers@kernel.org>

I'm glad I wrote those tests like generic/548, which verify that files
are actually being encrypted on-disk...

Looking for other potential encryption bypasses in ext4, I think
ext4_iomap_swap_activate() needs a fix as well to reject encrypted files
(perhaps in the caller).  That would be a separate patch though.

- Eric
