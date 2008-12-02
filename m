From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: also fix loop in do_split()
Date: Tue, 02 Dec 2008 14:29:35 -0600
Message-ID: <49359AAF.6010803@redhat.com>
References: <49310E1A.60105@gmail.com> <20081202120751.8b0226ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: roel kluin <roel.kluin@gmail.com>, sct@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYLBUfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2008 15:35:08 -0500
In-Reply-To: <20081202120751.8b0226ca.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:

> A local variable called `i' should always have signed type.  In fact,
> it should have `int' type.  Doing
> 
> 	unsigned i;
> 
> is an act of insane vandalism, punishable by spending five additional
> years coding in fortran.
> 
> I suggest you fix this by giving `i' the type God intended, or by
> making it unsigned and then renaming it to something which is not
> intended to trick programmers and reviewers.
> 
> Sheesh.

/me hangs head in shame, and points feebly but only halfheartedly at the
other people who reviewed the change when it originally went in... I
have no idea what I was thinking.  Sorry.  Please don't make me go back
to Fortran.

-Eric
