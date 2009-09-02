From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: MD/DM and barriers (was Re: [patch] ext2/3: document conditions
 when reliable operation is possible)
Date: Wed, 02 Sep 2009 20:17:41 +0400
Message-ID: <4A9E9AA5.4020107@msgid.tls.msk.ru>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu> <4A9685D4.2070906@redhat.com> <4A96BA2D.60804@garzik.org> <20090901140120.GD2028@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([81.13.33.159]:56730 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZIBQRk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 12:17:40 -0400
In-Reply-To: <20090901140120.GD2028@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pavel Machek wrote:
> On Thu 2009-08-27 12:54:05, Jeff Garzik wrote:
[]
>> Only md/raid1 supports barriers at present, it seems.  None of the other  
>> MD drivers support barriers.
> 
> Not even md/raid0? Ouch :-(.

Only for raid1 there's no requiriment for inter-drive ordering.  Hence
only raid1 supports barriers (and gained that support very recently,
in 1 or 2 kernel releases).  For the rest, including raid0 and linear,
inter-drive ordering is necessary to implement barriers.  Or md should
have its own queue (flushing) mechanisms.

/mjt
