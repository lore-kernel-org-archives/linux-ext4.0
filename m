From: Jeff Garzik <jeff@garzik.org>
Subject: MD/DM and barriers (was Re: [patch] ext2/3: document conditions when
 reliable operation is possible)
Date: Thu, 27 Aug 2009 12:54:05 -0400
Message-ID: <4A96BA2D.60804@garzik.org>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu> <4A9685D4.2070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41810 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZH0Qyo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 12:54:44 -0400
In-Reply-To: <4A9685D4.2070906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/27/2009 09:10 AM, Ric Wheeler wrote:
> One thing that does need fixing for some MD configurations is to stress
> again that we need to make sure that barrier operations are properly
> supported or users will need to disable the write cache on devices with
> volatile write caches.

Agreed; chime in on Christoph's linux-vfs thread if people have input.

I quickly glanced at MD and DM.  Currently, upstream, we see a lot of

         if (unlikely(bio_barrier(bio))) {
                 bio_endio(bio, -EOPNOTSUPP);
                 return 0;
         }

in DM and MD make_request functions.

Only md/raid1 supports barriers at present, it seems.  None of the other 
MD drivers support barriers.

DM has some barrier code...  but the above code was pasted from DM's 
make_request function, so I am guessing that DM's barrier stuff is 
incomplete and disabled at present.

I've been mentioning this issue for years... glad some people finally 
noticed :)

	Jeff



