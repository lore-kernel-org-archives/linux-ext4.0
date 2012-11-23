From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3
Date: Fri, 23 Nov 2012 14:20:09 -0200
Message-ID: <20121123162009.GA10760@andromeda.usersys.redhat.com>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
 <20121108170202.GB19977@thunk.org>
 <50A023B9.4020609@redhat.com>
 <50A54AAC.8050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab2KWQUw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Nov 2012 11:20:52 -0500
Content-Disposition: inline
In-Reply-To: <50A54AAC.8050100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, sorry my delayed answer on this thread.

> >Anyway, back to my main point:  As a guiding principle I think I would
> >say that mount -t ext3 with ext4.ko should hard-reject any option not
> >understood by ext3.ko.  It's clear and predictable, and should make for
> >a decent first cut.
> >
> >-Eric
> 
> Agreed (sounds almost like we had coordinated our answers before I
> spoke to Ted in Barcelona!).
> 
> Ric
> 
that's my main point, and the goal of my first patch. I was thinking in just
warn when mounting a ext3 with ext4.ko using mount options not recognized by
ext3.ko, but, looks like hard-reject these options looks more reasonable than
just warning.

I'm going to re-write the patch using this approach. Is there any concern in
take this direction from any part here?

-- 
Carlos
