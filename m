From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Thu, 17 Jul 2008 17:09:05 -0600
Message-ID: <20080717230905.GI6239@webber.adilger.int>
References: <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
 <20080717135746.GB14133@unused.rdu.redhat.com>
 <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com>
 <20080717141333.GC14133@unused.rdu.redhat.com>
 <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
 <20080717141655.GD14133@unused.rdu.redhat.com>
 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
 <20080717143332.GE14133@unused.rdu.redhat.com>
 <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
 <20080717144342.GA15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42791 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbYGQXJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 19:09:08 -0400
In-reply-to: <20080717144342.GA15844@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 17, 2008  10:43 -0400, Josef Bacik wrote:
> Yeah thats a hard to answer question, one that I will leave up to others
> who have been doing this much longer than I.  My thought is remount-ro
> is there to keep you from crashing, so if you have errors=continue then
> you expect to live with the consequences.  Course if that bit gets flipped
> via corruption thats not good either.

It shouldn't cause the kernel to crash, but it should definitely return
an error to the application.  This is probably one of the code paths
that the Coverity folks were reporting on in FAST this year where on-disk
errors are not propagated to the application.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

