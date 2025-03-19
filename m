Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251D0257D
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2025 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742402774; cv=none; b=rXT/r+AuMaR8XvfvX4jCGXIT4RUYXbN+uCJs+HRSjafBm7b3hO5GUES+IEGidX+nsvaeRlTXwTWKj041T+L7SQVb60Bnw2kcTuY+mY6TeM+CwIVPRLlLpnSYnjpP4V+BfxZyA0rOzxKKxuUKdNITs7f7l/jP+EzANzHdTYnPf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742402774; c=relaxed/simple;
	bh=fpvHJdekxgPEvB0ATNh0JaH9/Tms0pdcrkDJK3iXu3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1GPDLO+rjfB+F1MhuxS4+10JMxPAD9S7beOtJrtRCPN/0z+c9pIe1Cw1Q8ZYnI+NhNJ/mZRd0+T1Sg3PWvv0vNQ3ErQmcWLFoVvrYENRhRL0hzNl0uQfCOHbcxRAsvsbnEgU0Ph6L6AWCHJUvOdDXPP9lBXy9uC/whzJSSl5LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-222.bstnma.fios.verizon.net [173.48.82.222])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 52JGk2JF018902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 12:46:03 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 65BAC2E010B; Wed, 19 Mar 2025 12:46:02 -0400 (EDT)
Date: Wed, 19 Mar 2025 12:46:02 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Jakub Acs <acsjakub@amazon.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        Mahmoud Adam <mngyadam@amazon.com>, stable@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] ext4: fix OOB read when checking dotdot dir
Message-ID: <20250319164602.GC1061595@mit.edu>
References: <20250319110134.10071-1-acsjakub@amazon.com>
 <20250319130543.GA1061595@mit.edu>
 <CAHk-=wgzYVZ0ZNvcqC+yToX6nFx+SNZqTcyEvzm2RMP-TU-Dqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzYVZ0ZNvcqC+yToX6nFx+SNZqTcyEvzm2RMP-TU-Dqw@mail.gmail.com>

On Wed, Mar 19, 2025 at 09:28:56AM -0700, Linus Torvalds wrote:
> Why would you use 'strcmp()' when you just checked that the length is one?
> 
> IOW, if you are talking about "a bit more optimized", please just check
> 
>         de->name[0] == '.'
> 
> after you've checked that the length is 1.

Yes, good point.  My suggestion was to optimize htings by avoid
calling strcmp() in most cases, but you're absolutely correct that we
could do even better by *never* calling strcmp().

						- Ted
