Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAE03019AA
	for <linux-ext4@vger.kernel.org>; Wed,  3 Jun 2026 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494100; cv=none; b=KZ9noxi7Vypb28Uzv8NxUNU+HRb/s0fz4B4jzN5GxP1K2yiVCYS2NpnVrvrRdI1Al6s3goUZ0oBmPU4uTrZeimIOCEDDeiAU8Ew4tpEBJUmQRGvzuFk/3UOrVAweWBUbkvA3Imbm9R/9rNW4/wh3VsDcDz+4061wI/Qb0WjOJeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494100; c=relaxed/simple;
	bh=JqBWPoa6OM1wBn/TtcjKEcZdpXvCRD7PyZHdJthOkIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9tPX+mW8kpVBYcczZjoNkWqdD0Gby6ElGmcUw1PySdhtS1/cNPvFDNMsDp9ng3jdSnFAF1SJoIIn5i+yam88dCVl8Qx8BkkkDR/J1iGgJCib8WVDgEF50WoCZoRamHE4PFVRClet1F7Xmh9ey74Hn/oKbG5yDAY2SpR6zUR2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=TnaYOFWS; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="TnaYOFWS"
Received: from macsyma.thunk.org ([104.135.218.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 653DfDON021479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Jun 2026 09:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780494076; bh=/WlDoBOBU1AIvM33kioQkvAi40TF6B38PilqBNl1uvc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=TnaYOFWSE8CfrSIRT371u8kpAbaunSiEbQO/zSKffhEWklFEC2fLz6saxoZyGMrEM
	 G9b+hDwdjTcdFFCzJ6UcPuQeGvxv4PyCLINNEInVbiO9DgG6nG0uLkZcrmc0vxXhpD
	 xyMf6eb7CKzLKymDDd1ure3qg/p86rYRlaJEW9CJpQYbtrjSUa4j2uiepf9wMgE2+k
	 S3kP90QxsQvM7Pz3Flh8ChG8saeESJmxsk0Xk1xVmuGiAOIt3o5BCqOWn8TbJ6r1Qr
	 EuKleHYGPke7sOEC/sVv/X3stUmCw9ve+u1jpb8hm14LcWBx6AAzxu758sK30TFOMl
	 hr1FtBcCnQL3Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id EF5D735D605; Wed,  3 Jun 2026 09:41:12 -0400 (EDT)
Date: Wed, 3 Jun 2026 09:41:12 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        aivazian.tigran@gmail.com, linux-ext4@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH v2 02/10] ext4: Allocate mapping_metadata_bhs struct on
 demand
Message-ID: <is7eaz2cgtaucbqupfk66n6gotpn54uy5md35phnd7jwmuivjl@jgmtfr6kahlt>
References: <20260525085035.12891-1-jack@suse.cz>
 <20260525085821.769119-12-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525085821.769119-12-jack@suse.cz>

On Mon, May 25, 2026 at 10:58:08AM +0200, Jan Kara wrote:
> Currently every ext4 inode gets mapping_metadata_bhs struct although it
> is only needed when running without a journal and only for inodes where
> any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
> when dirtying the first metadata buffer for the inode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Theodore Ts'o <tytso@mit.edu>
