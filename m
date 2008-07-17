From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Date: Thu, 17 Jul 2008 17:00:07 +0200
Message-ID: <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
References: <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
	 <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
	 <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
	 <20080717135746.GB14133@unused.rdu.redhat.com>
	 <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com>
	 <20080717141333.GC14133@unused.rdu.redhat.com>
	 <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
	 <20080717141655.GD14133@unused.rdu.redhat.com>
	 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
	 <20080717143332.GE14133@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Josef Bacik" <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	"Johannes Weiner" <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:34457 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYGQPAI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 11:00:08 -0400
Received: by wf-out-1314.google.com with SMTP id 27so6021499wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 08:00:08 -0700 (PDT)
In-Reply-To: <20080717143332.GE14133@unused.rdu.redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 4:33 PM, Josef Bacik <jbacik@redhat.com> wrote:
> Ok run dumpe2fs -h on your image and see if you have a line that says
>
> Errors behavior:          Continue
>
> if you do run tune2fs -e remount-ro and then do the mount.  That would explain
> why you are still having panics even though we should be aborting the journal.
> Thanks,

Ahh, that probably explains it. I didn't realize there was such a thing.

I am doing random-corruption tests, so it is quite possible that this
bit gets set anywhere along the road...

But even so, is it correct that the kernel should crash? It seems
quite possible that error behaviour can change (like this) even with
"normal" corruption, e.g. outside my test scripts.

But I cannot even run dumpe2fs on my image (even with -f switch):

dumpe2fs: Bad magic number in super-block while trying to open disk



Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
