Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD6D2367BA;
	Sun, 22 Feb 2026 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771792147; cv=none; b=MUTE9Qx/HVRbfD4BcSjfCmn5Z42D6z2vSRScvTy6mpf2OgYQkU+++z93/w6iCrYC0LjfEUbNfRoP2PjLrFXpw5HY7JREJdLuoKQhJ+l0SYNlq00Y19juerzkuTNayvFDVDuzEGCvRVAamGW1TPmWk9x7jOFikOZsj5xdnRmPNdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771792147; c=relaxed/simple;
	bh=us+jdbZYF+46uqL0ZHOOd0m1jCOey4u0e0r42GAMLUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0ZoHiGktJovVynYgeryaHpuX0TVIuaw1B0ej2bTP+MY9/pyzOvQKLsuutik4mZUZT4UNUwtET7+mIsRY+st+XYRNdMtdO6KdmD/Mu/xYs8dzaYeBoVU6fti+fyszY3C0F2j1rgPHW7We9X6FMBcZtqKvLhhziVxGWzzmXxRb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naZd7siD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naZd7siD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16D4C116D0;
	Sun, 22 Feb 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771792147;
	bh=us+jdbZYF+46uqL0ZHOOd0m1jCOey4u0e0r42GAMLUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=naZd7siDBt/cG5OQWUCyX81oV+MVq50WD3Sh1BFcBfO/Gxa5sSyMyGoQLziCBZ5Eb
	 cV+rORKMNy94ygvVx1SuXULInYiIAUjGRJtkDRKcXqre5tIjV8GY9PerYUzFwVzkxe
	 nyTH3zzoEJfrzKq0L2IKQk5T2CmsC2Ul+V6TplaWqjB2XyFg/FXCukbH9O4sMxSl2N
	 j8LxmccdgmPD1rDZplJ3QT7xA0fDe8Mhkib6zE5HfsVMAzvPgO0d0HLEATCYeVrypg
	 Z9vnL5YRXIkxfRZRrx+QWH2Dti39E+YcukQm26vrDvDVhfS9TGS/TpMwCUU8QR7cPC
	 PQZumNhJRKt9w==
Date: Sun, 22 Feb 2026 12:28:54 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Weber <simon.weber.39@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, tahsin@google.com,
	Anthony Durrer <anthonydev@fastmail.com>
Subject: Re: [PATCH v2] ext4: fix journal credit check when setting fscrypt
 context
Message-ID: <20260222202854.GB37806@quark>
References: <20260207100148.724275-4-simon.weber.39@gmail.com>
 <20260213000720.GA2191@quark>
 <CAM2C2RtuEnbOYSMmLGtfOBmFqPoGLZ3Ld32dTmzkKxchB90HPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM2C2RtuEnbOYSMmLGtfOBmFqPoGLZ3Ld32dTmzkKxchB90HPA@mail.gmail.com>

On Sun, Feb 22, 2026 at 09:11:55AM +0100, Simon Weber wrote:
> Hi Eric,
> 
> thanks for your approval.
> 
> How do we continue from here? Do I have to resubmit a patch with the
> typo fixed or can it just be fixed on the maintainer's side? If I
> resubmit, I should include your Reviewed-by tag at the bottom,
> correct?
> 
> Cheers,
> Simon

This should get taken through the ext4 tree eventually.  You don't need
to resend the patch just for a typo and Reviewed-by.

- Eric
