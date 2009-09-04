From: Mark Lord <lkml@rtr.ca>
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe
 width, writes in storage
Date: Fri, 04 Sep 2009 17:21:27 -0400
Message-ID: <4AA184D7.1010502@rtr.ca>
References: <20090828064449.GA27528@elf.ucw.cz>	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>,
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A9FCF6B.1080704@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ric Wheeler wrote:
..
> You must disable the write cache on these commodity drives *if* the MD 
> RAID level does not support barriers properly.
..

Rather than further trying to cripple Linux on the notebook,
(it's bad enough already)..

How about instead, *fixing* the MD layer to properly support barriers?
That would be far more useful, productive, and better for end-users.

Cheers
