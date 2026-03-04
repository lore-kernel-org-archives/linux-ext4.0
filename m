Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9134CFC6;
	Wed,  4 Mar 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631639; cv=none; b=Dbw3cV5yiaDjefIwnpNOuBqsIV8i1KLvj0gOZTWHITPi+1cl+dzfQTW33uoQrBL7BmUsGxvOhratv1AuM0ZqLuQkeySFejBK+D0Wn1dajVePJWcZCza0W6cl0JL6Y+LFImvoCVWFxAoa48aWGO1Uezu2ihGvoJN33DtzSetiBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631639; c=relaxed/simple;
	bh=saBpvESaGj5QiqSpFfWOGnf8j0MOslSLXlBi7/U5dHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hp3mRDJdDLDCNTVhJ0FOjMiCWglOrv7r7q6WGWoCwr1Vi+3PLNwaZkHlSYTKqubVts9Eh51plsNMQoq39q+P3gy4xuC4jh/kty6bmcyjuvqbDWTVmBO3iGdSKKFzQubLdsA5fS9ezwGuTZBIqTjO8bbkVCKfHjghub0Bws6gZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz9Q10ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz9Q10ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17945C19423;
	Wed,  4 Mar 2026 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631639;
	bh=saBpvESaGj5QiqSpFfWOGnf8j0MOslSLXlBi7/U5dHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pz9Q10cesxvicAfZAxJWsJipenbgc+L+GNBCNpgox/ApeDmUPPNe8bReiHFtdKJCo
	 YDJrcx41hrcP49safkalWHRbQyMbDCsHrAYtLJLIZsdZrE0bJ6Utugirq3RpNrvbZO
	 FHWGLQu8SALp+v14qeuSUvgpocfy3rK1dggz0b3mdpAENAGW19TwVxKlHXFttwaBBN
	 9doonxpzjRixTTqINhTaW9bdDXsZKwniR6coFVIkE9yZoYJn9u4qPvJs7mZhBc07jy
	 mvSFumdnatCpc4H+iN0pw8E1ysCu1zZ7LDRKoVLOgExDFMBxxcINf3rkkQfAzvtlq7
	 VguxGnHd/toJA==
Date: Wed, 4 Mar 2026 14:40:33 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <20260304-mahnung-ableisten-50d5c4e71013@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-63-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> Instead of using mapping->i_private_list use a list in private part of
> the inode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  virt/kvm/guest_memfd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 017d84a7adf3..6d36a7827870 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -30,6 +30,7 @@ struct gmem_file {
>  struct gmem_inode {
>  	struct shared_policy policy;
>  	struct inode vfs_inode;
> +	struct list_head gem_file_list;

I think that needs to be gMem_file_list not, gem_file_list.
