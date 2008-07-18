From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Date: Fri, 18 Jul 2008 13:58:15 +0200
Message-ID: <19f34abd0807180458i2749f5d0jc5c07f691931954e@mail.gmail.com>
References: <20080717141333.GC14133@unused.rdu.redhat.com>
	 <20080717141655.GD14133@unused.rdu.redhat.com>
	 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
	 <20080717143332.GE14133@unused.rdu.redhat.com>
	 <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
	 <20080717144342.GA15844@unused.rdu.redhat.com>
	 <20080717230905.GI6239@webber.adilger.int>
	 <20080718105152.GB15844@unused.rdu.redhat.com>
	 <19f34abd0807180432i19567dfal5d7d29bb1916b562@mail.gmail.com>
	 <20080718112003.GC15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@sun.com>,
	"Josef Bacik" <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org,
	"Johannes Weiner" <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:11710 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYGRL6R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 07:58:17 -0400
Received: by qb-out-0506.google.com with SMTP id p36so1405611qba.17
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 04:58:16 -0700 (PDT)
In-Reply-To: <20080718112003.GC15844@unused.rdu.redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 1:20 PM, Josef Bacik <jbacik@redhat.com> wrote:
>> You can see the full log at
>> http://folk.uio.no/vegardno/linux/log-1216380709.txt which shows that
>> it already survived a lot of failures, so I'm guessing your patch was
>> correct and we just hit a different case. What do you think?
>>
>
> Yeah you are right, its like a shitty game of wack-a-mole.  Heres another patch,
> same thing as last time, pull the other one out put this one on.  Thanks,

It seems to hold up -- no stacktraces, but lots of IO failures.

I would leave it in testing for a bit more, but I've got to run; I'll
give it another go when I get home.

You may see the log so far: http://folk.uio.no/vegardno/linux/log-1216382128.txt


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
