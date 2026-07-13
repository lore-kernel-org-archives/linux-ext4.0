Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E958543B493
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783953195; cv=none; b=kBohDaQFShfeMgqMCM6NkZqIr+deJGssXB+9Niqmqtco+Pn/+nlLckxzLbTJg8Mw68JNrDjq4O5gMOTqjL6PtVJ3pq51RMGhefKz0sl7ZYcz+NGPnf68Jd95pXppNe0Dpqr2tTWgdV+cm1Lqdhi8ShHY112MjQtIoZv5fthtmDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783953195; c=relaxed/simple;
	bh=LJPueR8a2Bs9bwwyRsPl0t9Za3k3qLPq5xW3Z9I3NVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPCqktke+1h5NNPw3zJgZStjXyQL4Bci4sKSJMxc5puC4vA9rPwZZkoMac+LM5CVPK7yaQFFOENXRsi2k6U1X6chLe47Wkps/SUawgP7/7u5Gh2t1XgMBsvV+ioyPSbDadrctpfHv0rPqdNS3clULV5+ngV0DxqJAqWP++e2zf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=TzDfna0F; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="TzDfna0F"
Received: from macsyma.thunk.org ([151.240.45.35])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66DEWuib019915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 10:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1783953179; bh=si+dq4YGo4YhW29/So/42ZoEf9z/pyRgDtTmF7C0Tyc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=TzDfna0FF32b6kTGQ1Pb7N3BE1gBqSj/WazfBAChFWwmrPSaG72lUQ+JLxRwcBdUV
	 Xsh+AyAHUm/MZ5c3O+E9NGeQ20XftX0oB5CkDa7w0h+hKLR55q3XJJva6Kx5hFneKb
	 Xq8ptj6W3ZaGqA6IC4epE/9NfQWZJd4xGIeImcbmC++iRS0aZMPLuZ48pqpJKAXOdw
	 Sbo3fY7xejjhZ65bQT9ESsuokGiqD2gR1XPUGWl/QXc60CTkBVw1EO0e126GN1a4kA
	 tTvmIqt9z9KsR4Wg0nUPFEoWWh+YxBNkG5ezDWIOZtJZioK+Vs3QVtUdU0hM/OMD96
	 6hdRqlfLtQNaQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 3E2A39F0D0F; Mon, 13 Jul 2026 10:32:56 -0400 (EDT)
Date: Mon, 13 Jul 2026 10:32:56 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>,
        Marco Elver <elver@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
Message-ID: <alT2yHlfzhTZ9n4T@mit.edu>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712165610.366474-2-timday@thelustrecollective.com>

On Sun, Jul 12, 2026 at 12:56:02PM -0500, Timothy Day wrote:
> Clang reports the following warning when context analysis is enabled:
> 
> fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not \
>   held on every path through here [-Werror,-Wthread-safety-analysis]
>   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
>       |             ^
> 
> When WARN_ON_ONCE() wraps down_write_trylock(), it adds an unlikely()
> annotation which hides the conditional acquire annotation from Clang's
> context analysis. This triggers a false positive. Pull the trylock out
> of the macro to silence this warning.

Does this mean that using Clang's context analysis means that we can't
use unlikely()?  That seems.... unfortunate.  Is there any other way
we can fix the false positive?  Even disabling unlikely() if and only
if Clang context analysis is enabled might be a better choice, since
we don't necessarily need to build with context analysis enabled when
building a production kernel.

				- Ted
