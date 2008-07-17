From: Josef Bacik <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Thu, 17 Jul 2008 10:43:42 -0400
Message-ID: <20080717144342.GA15844@unused.rdu.redhat.com>
References: <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com> <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com> <20080717143332.GE14133@unused.rdu.redhat.com> <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYGQPvS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jul 2008 11:51:18 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 05:00:07PM +0200, Vegard Nossum wrote:
> On Thu, Jul 17, 2008 at 4:33 PM, Josef Bacik <jbacik@redhat.com> wrote:
> > Ok run dumpe2fs -h on your image and see if you have a line that says
> >
> > Errors behavior:          Continue
> >
> > if you do run tune2fs -e remount-ro and then do the mount.  That would explain
> > why you are still having panics even though we should be aborting the journal.
> > Thanks,
> 
> Ahh, that probably explains it. I didn't realize there was such a thing.
> 
> I am doing random-corruption tests, so it is quite possible that this
> bit gets set anywhere along the road...
> 
> But even so, is it correct that the kernel should crash? It seems
> quite possible that error behaviour can change (like this) even with
> "normal" corruption, e.g. outside my test scripts.
>

Yeah thats a hard to answer question, one that I will leave up to others who
have been doing this much longer than I.  My thought is remount-ro is there to
keep you from crashing, so if you have errors=continue then you expect to live
with the consequences.  Course if that bit gets flipped via corruption thats not
good either.  Thanks,

Josef
