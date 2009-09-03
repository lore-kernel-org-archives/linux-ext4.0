From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Thu, 03 Sep 2009 13:12:21 +0200
Message-ID: <m3ab1cp9ii.fsf@intrepid.localdomain>
References: <20090828064449.GA27528@elf.ucw.cz>
	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37129 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZICLMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 07:12:23 -0400
In-Reply-To: <4A9F230F.40707@redhat.com> (Ric Wheeler's message of "Wed, 02
	Sep 2009 21:59:43 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <rwheeler@redhat.com> writes:

> Just to add some support to this, all of the external RAID arrays that
> I know of normally run with write cache disabled on the component
> drives.

Do they use "off the shelf" SATA (or PATA) disks, and if so, which ones?
-- 
Krzysztof Halasa
