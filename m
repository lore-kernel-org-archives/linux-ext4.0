Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523319004A;
	Wed,  4 Mar 2026 12:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772627564; cv=none; b=Qqngzr1ogLtk2fAMRntUPeqCW03wVTsRh7lJU+DqztoLKpfC4e49+fPqXRsg6ONAk/0hJZZauoB0dBx3PXQ69P6zhRSbqOq3KHyCvSrhA+3e7+KI4Pxo7UP4p6eysGtRu8+Il9+cMP2cixQ2CpB5Wb5lJ+aqToi0F+acnuhig/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772627564; c=relaxed/simple;
	bh=e83BLM5GvLOSGz2uXBojTED9JFHiqSjMgXE8Lu25qK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLMQ0ONFGx+ZeOV/KiaVFz0ICMxkdZ/gxWhhhgFr28Gr9uTLMV9RKAPVwdI5j0TKcvOcSv2GZumEZwZAahtrrrs5g3s+r0CTf9eEkt0S09EMpzUvQeaH96GUCEGUiUq1byuNG6JP6w82jY0XUfT2Y8BilnEBtm25y/IR8A8tJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5HZ9ZXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5HZ9ZXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC92C19423;
	Wed,  4 Mar 2026 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772627563;
	bh=e83BLM5GvLOSGz2uXBojTED9JFHiqSjMgXE8Lu25qK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O5HZ9ZXCJqHwto+K5TFar84RC/tF8oNzANWMk/pDTUv0yJW8zjeLJacXbuLVY3Xr1
	 9fkVHSKfuzVaATC6KcP4bJBtD8p7xm0HmEXyxf+kH/slGw+wp9sTxWhhWTjK4S2y90
	 C4ycuiLzzeab0IYT1W06GcB2c0bw/oaa5k3o7ZhXK1Ty7Vi48HNCNwwnfIM9Ywmner
	 mlqK0IhGLn6Ady683UiqkEk5BAzJ4r+nasY/agjsM9bTZVEBCFgsaiQula10UbtIJo
	 UVTGmS8PhJknVNsogbZWNgSsN9uPDBXfi8bl6orUalEer0ct1mZsEBEvrP2u+6VVmN
	 k7I44NAJRlW2w==
Date: Wed, 4 Mar 2026 13:32:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 0/32] fs: Move metadata bh tracking from address_space
Message-ID: <20260304-badeort-amtieren-d02d2e06f2c5@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:33:49AM +0100, Jan Kara wrote:
> Hello,
> 
> this patch series cleans up the mess that has accumulated over the years in
> metadata buffer_head tracking for inodes, moves the tracking into dedicated
> structure in filesystem-private part of the inode (so that we don't use
> private_list, private_data, and private_lock in struct address_space), and also
> moves couple other users of private_data and private_list so these are removed
> from struct address_space saving 3 longs in struct inode for 99% of inodes.  I

Yes! I love it.
