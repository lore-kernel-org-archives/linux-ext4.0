Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8978D3E7BAF;
	Thu, 28 May 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779969776; cv=none; b=SqqirJE796oxevwhMuvnZIpA5mUB+pWa1k6OTjwFk3Aj6meO/AY0vGIAmW/Scjcnp/ePxHZ9kGxYvjBDSatt7fxh1jCfFpkcxrj7iphs7rB0QnEby6+2tdiSddi3H1oHpvMLpsu6/ma2LInVeNyuPROg5jj9hR5U+IKPl79vb1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779969776; c=relaxed/simple;
	bh=sy4FPeYdz1c1upnEaFo1Gzs0q8sDKHq03tALhaLTdlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rj0qv4LrhTSzbNta92oEYCkADCua3fovFe/LmTg17fqO1V+zQyinpe+S+5bcn1K9wE42hxdRwRqoGjQV1yZ5GYKEOP9WbF06chWlKJDl6wjQ+MD8zl6f/iUkJmB7xgQ0FVxm1JgXmWgltsqvNyPD7pTP0H/1N0iogUoPQ+NlBMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfF+O8jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfF+O8jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A371F000E9;
	Thu, 28 May 2026 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779969775;
	bh=WzuRhvTFnKVMuLosDl+wUsUU9ggU6cVs+BamrsMo9rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gfF+O8jDnrcV/j5OSoQRl5T27zkLERWL2K7jASubWQkFFezswGAOiOMxnLA2U1gVb
	 jxIYY/Yl3Kzch7fdOYJWOkLuSR3wseyrKZH/NUQpZBBloBOFiZLFNjsCndmAFOsEQ8
	 GABBVytqyy+kdbslcFwH8FjyXUECrB6dmF1XsjxFyc3+j4L4KFVvADjOVBd3CxxV0w
	 bsHg4s2dq0IP66hF6e0XwBt0FQ0s64VgI3LcF80JctT0a0MdPaqKWQJfw1RW95XKg1
	 2SdDpRjRuvwBcCRyLJLwFkrDb7X1+tUkm72cDudD6uf5o33iV+Y++6vLDidkrcPXBQ
	 D9BU+gz2ZynTA==
Date: Thu, 28 May 2026 14:02:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/8] ext4: convert mballoc KUnit test to sget_fc()
Message-ID: <20260528-pailletten-gitter-hiermit-5198ec556b28@brauner>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
 <20260526-work-sget-v1-2-263f7025cedd@kernel.org>
 <ny6ggedljk3celsnnaaczpehmgll6hqrglqc44ku53cmxrclx5@w4qby54x6mff>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ny6ggedljk3celsnnaaczpehmgll6hqrglqc44ku53cmxrclx5@w4qby54x6mff>

On Tue, May 26, 2026 at 07:47:27PM -0500, Theodore Ts'o wrote:
> On Tue, May 26, 2026 at 05:09:04PM +0200, Christian Brauner wrote:
> > Add a no-op mbt_init_fs_context() so fs_context_for_mount() has
> > something to call on the fake fs_type....
> 
> I was trying to figure out what needed to be in an init_fs_context()
> functrion, and I came accross this in
> Documentation/filesystems/mount_api.rst:
> 
>        const struct fs_context_operations *ops
> 
>      These are operations that can be done on a filesystem context (see
>      below).  This must be set by the ->init_fs_context() file_system_type
>      operation.    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> So is it safe to just have an init_fs_context() function which doesn't
> do this?


> 
> > +static int mbt_init_fs_context(struct fs_context *fc)
> > +{
> > +	return 0;
> > +}
> > +
> 
> I see in fs/fs_context.c that in some places the code protects against
> a NULL ops pointer:
> 
>         if (fc->need_free && fc->ops && fc->ops->free)
> 		fc->ops->free(fc);
> 
> But in other places, it doesn't and we'll end up derefrencing a null
> pointer:
> 
>         if (fc->ops->parse_param) {
> 		ret = fc->ops->parse_param(fc, param);
> 
> 	....
> 
> So it's unclear to me --- when is it safe (and not safe) to not bother
> to fill in the ops pointer?

Hey Ted!

In these two cases it's fine. Because you're just using the allocation
and deallocation functions to get a fs_context that's basically just an
empty vessel to get at a superblock via sget_fc() but you're not really
doing anything with it.

IOW, you can never end up in callchains that cause issues.
