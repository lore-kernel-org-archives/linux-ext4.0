Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389652;
	b=aNwpYhPTzkZn8HVlBZKNakvAoYrSzTf07MJxw7WdZL8LymR0445BX3jovJ56rOMzQXM9
	 UqO+noufOBm3bElCFOQdXUnH6DvT2OWRIjtKb1vPcce/dyFOJLZTe5nwKY57uNV9v+0Ln
	 dbmpjyS1EHorWSpXGVk1+h60M49iZNL13hyb59ME3N+MvUYKc8vB/X2oekAnexvA7cbgR
	 ZQEgqCWo7YhFRDhU0A9pHaj1ZCZaDTAX8rXcNCEHZKtUDAskfNHnP0yvlzBS6K8UXl0lf
	 s1X/0W+/bLEuimdQZxoTb9X/CKoroACzkrNHaFMsvksQc8apFwtIX/poZMVk5LnafqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389652;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UxQLDsrm5Bn3FiXuPcGFrFZIY4Qgd1CNPnHPoQGzQhc=;
	b=xjaPOk83dN/kmLXN4h8QD0snXx/V/shU7A89cdODt/nF6JA9JwGy/WWqYzwEdE6Q8h6g
	 TB23fbBcQ7FhmL8ro2vmrAYGj87X+C8xrHIOmVdoh3hK9WmybC0SlwD5hN3/xWQaqKQYb
	 pJ9F0KjzPg4koPOpNRykNqqp6RjshcVxYiJaoJEnsUyNjmpC3BEFEfDLGzqbW1MBGaG3e
	 msEXJz9awwmA9KSUu7gIhNaTfeMq9mvsOcSdQhnoQE0IrCVHcDFIdKof/aqBlRnShs0YD
	 HKb3leI64yDgiNfi7hXh7p6At3PNHzE2x5dHxJ6zI97l5xf4Uq3w25MvaaWpdNliCVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GLtQoeAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0903B606A31C;
	Wed, 11 Nov 2026 09:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GLtQoeAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719321F00A05;
	Wed, 11 Nov 2026 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389651;
	bh=UxQLDsrm5Bn3FiXuPcGFrFZIY4Qgd1CNPnHPoQGzQhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GLtQoeAY0mrnAY0bSjsRnGSvaNs+ez+7FDZJNG8Mtcj65toWfTW8PMB5aiEVszULa
	 KoCE9F9mivUgLpHq3UdX5jpwfh65n3G71JcnKQ0V/nXpe+ynzHzRT9H4XVJ6t4iRBD
	 b+q+n3vga6wqq6ZvC4QYq4PdA1v6i7ki/pYBnygnNDBLj/b4MpLRA2e6a2H3Guzi4A
	 Zg8knxWD3iXKhgGMpp6YRUS+wGEdQwKLTPwRTz+hw3HzAzdM2Q8c27wWucohtcbkYw
	 ijQS9GoePWL7z4nmn7h4xTd/MYb4YUoWbPDpdrEcJu03uNN3wZdh8VzFLtVBFv71Mo
	 53OC38J7SEyDQ==
Date: Wed, 11 Nov 2026 10:34:05 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 16/34] hpfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261111-verpennen-eigne-ortstarif-e47e3521ab76@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191235@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191235@kernel.org>

On Fri, Oct 30, 2026 at 04:10:01PM +0000, sashiko-bot@kernel.org wrote:
> Does this allow a read-write remount or reconfigure after an error to
> succeed and synchronously write the spare block at sector 17 via
> mark_dirty()?

That writes the same dirty bit that hpfs_error() already wrote when the
error happened. Before this patch the same remount ran mark_dirty() as
well and made the filesystem writable again on top.
