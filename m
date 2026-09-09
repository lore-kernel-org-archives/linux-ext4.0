Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D601492E5D;
	Wed,  9 Sep 2026 00:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788913211; cv=none; b=m7zCreU7DOlvqP1XmAetO4ci9yRFQtHnqi3Oki3tzu1NpjLxOQTvgiauviYoCLXkloNfQVNys3GgLnnTe+jJ2XvqZx7QtUopvOSqZT5mCTQ4Wfano36a4BC2a1fwyrGxk3XF1V9g3W+zb86XKZPowPnXlwn6A2AMUEisK9s0ypY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788913211; c=relaxed/simple;
	bh=GMQsh1v4Gf55Y/HACgSghoeCk3N52W17AAWwwb2v+G8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqnN/pPMAcOEqB4JzSiF8Hefn+PJg9MXAF77KNALxOmHTIwCniGhF3x89VP5j1+pi0PWhjkRuLsKX5Y8jasYaGdsghDBV7RFPuYFh01sBjVcW2GoP+8UINd4jaI59RdAixJ6EPf3arhqZ6+CT9zuNzL+ibn+CYmi9mzRFFV4+x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0o/qyYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0o/qyYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EF1F00A3A;
	Wed,  9 Sep 2026 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788913209;
	bh=3r2rhT0buhb25SsigQaKKYL63plJSffphRat3oXylY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U0o/qyYEmt+WgP+NR03YdkRzJKdO0kMCc9eS9IGex7vQvOASzM5QMwPZIN0EznFqG
	 YDGc6yKx78L8CjvKZa6km0YOgcI7+2Db51pno1k/Nn6/GVELLjDUj6l4hBrq/Avrag
	 kP/4HMw9EtVACynPG2Qsh15D57IciORfrR+Ly2V2/sIse136UQRHaqBPjgGjwE44mE
	 hHZA58+JpLWQ99fOaoVuOH30f/HLTV9qeL8ABFylKUwKB9UdLxit02QDBRU/oJo9s3
	 ld1HOkAQSasLjN1rYZC53gpMi/GbjeA5zJUuQ056TGh0tTFLxHjI61PDjciuy0RFOq
	 PiEtGUBagFvnw==
Date: Tue, 8 Sep 2026 17:20:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context
 analysis
Message-ID: <20260909002005.GA3661577@ax162>
References: <20260903101843.3462767-1-elver@google.com>
 <20260907221334.GA1619741@ax162>
 <CANpmjNNuiX-rQFvn0GK1SxAbcxEUH7rKh69GPq+7u2tg63qbmQ@mail.gmail.com>
 <4ohly4m6ffr4jnpqncucwkajjorfzdi4x3perczoszs5cb7ljx@mrf7no3uuzua>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ohly4m6ffr4jnpqncucwkajjorfzdi4x3perczoszs5cb7ljx@mrf7no3uuzua>

On Tue, Sep 08, 2026 at 12:15:13PM +0200, Jan Kara wrote:
> On Tue 08-09-26 00:17:34, Marco Elver wrote:
> > Thanks! I think this is one of those orphaned files - which tree can
> > this go through? Can it go through your tree, unless Jan already
> > picked it up with the other fix?
> 
> If Nathan can take it through his tree, that would be great, otherwise I
> can take it through mine. Just let me know.

I applied this to my clang-fixes tree and created an immutable tag for
you to pull from, as you should have it in your tree since you are
enabling context analysis there. If nobody else needs it and I do not
have any other material for 7.4 in that tree, I won't send a pull
request if the ext2 tree is merged with this included.

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nathan/linux.git tags/clang-fixes-once_lite-for-7.4

for you to fetch changes up to 0bb666d5f5a2339a5692afb312c2161df9620503:

  once_lite: Simplify condition handling and fix context analysis (2026-09-08 16:54:02 -0700)

----------------------------------------------------------------
Immutable branch for once_lite.h context analysis fix

Signed-off-by: Nathan Chancellor <nathan@kernel.org>

----------------------------------------------------------------
Marco Elver (1):
      once_lite: Simplify condition handling and fix context analysis

 include/linux/once_lite.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
Cheers,
Nathan
