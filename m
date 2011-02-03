From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 03 Feb 2011 16:00:47 -0600
Message-ID: <4D4B258F.6020708@redhat.com>
References: <20110203144011.GA28409@quack.suse.cz>	<4D4AC4E2.701@redhat.com>	<AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>	<4D4B06AF.6000106@redhat.com> <AANLkTi=wAX8yLSsbn-zM5t6DrE22asYnz6KdQBfSYuUT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1BCWBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 17:01:32 -0500
In-Reply-To: <AANLkTi=wAX8yLSsbn-zM5t6DrE22asYnz6KdQBfSYuUT@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/3/11 3:57 PM, Amir Goldstein wrote:

> Can you give a rough estimate of how those commits diverge between
> bugfixes, kernel API changes, code cleanups?

Um, maybe by the time LSF rolls around ;) It'd take a while to sift
though.
 
> Next3 has been following ext3 since 2.6.31 and I remember changes of
> the 2 latter,
> but not many major bugfixes.
> 
> I hardly think we can get away with throwing out ext3 code base, but
> maybe it can go
> into bugfixes-only mode? that is unless Jan likes to apply cleanups ;-)

In theory that's what it's been for a couple years already :)

-Eric

> Amir.
> 
