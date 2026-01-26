Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565A53009C3;
	Mon, 26 Jan 2026 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769402618; cv=none; b=AVEFAz1rqEZ4TC79G8FKU+eY8TbxD9RQ2PfCeQ6W0Tphu0J5H/9W1i5uhjDR79cgaee//Dt+hAHPYvDc0LA2UU2Tfqdv2tOm35EX0yJQUfjEO9SZoZhI5f2tDA/0/O/kD4Zl/e3R/ylvi4WS5eHyeP3P4OD5NpSmATO1Q08WfXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769402618; c=relaxed/simple;
	bh=HzND9p9JRQozIE7HCqyhKMnVk9dyYUaRmZx7DX9vEyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpXnVqDVNVTacwOue3oBfikuI5RMKDiK6mgkCJEpg2k/O3ZGVJLmv1w6BwX5vOOlAOm1K/t6Z9sQ7/yqYd0j207Jxp0wRSNQOG5tiQbavqKtwEeboBzXIZI+IppjxQvMC7iHEJAs6ViE5axQkLa4gQvQokWsT13xQwsAj3nh404=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 938F3227A88; Mon, 26 Jan 2026 05:43:33 +0100 (CET)
Date: Mon, 26 Jan 2026 05:43:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 11/11] fsverity: use a hashtable to find the
 fsverity_info
Message-ID: <20260126044333.GD30803@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-12-hch@lst.de> <20260125013104.GA2255@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125013104.GA2255@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Jan 24, 2026 at 05:31:04PM -0800, Eric Biggers wrote:
> > +	found = rhashtable_lookup_get_insert_fast(&fsverity_info_hash,
> > +			&vi->rhash_head, fsverity_info_hash_params);
> > +	if (found) {
> > +		fsverity_free_info(vi);
> > +		if (IS_ERR(found))
> > +			err = PTR_ERR(found);
> > +	}
> 
> Is there any explanation for why it's safe to use the *_fast variants of
> these functions?

_fast is the default mode of operation of rhashtable, I have no idea
why the authors came up with the naming.  The _fast postfixed versions
just add the required RCU critical sections over ther otherwise fully
internally locked rhashtable operations.  I've expanded the commit
message a bit to make this hopefully more clear.

> This looks incorrect.  The memory barrier is needed after reading the
> flag, not before.  (See how smp_load_acquire() works.)
> 
> Also, it's needed only for verity inodes.
> 
> Maybe do:
> 
> 	if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode)) {
> 		/*
>                  * This pairs with the try_cmpxchg in set_mask_bits()
>                  * used to set the S_VERITY bit in i_flags.
> 		 */
> 		smp_mb();
> 		return true;
> 	}
> 	return false;

Thanks, I've fixed this up.

