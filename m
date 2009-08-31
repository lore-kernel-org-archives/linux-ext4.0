From: Christoph Hellwig <hch@infradead.org>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 09:16:26 -0400
Message-ID: <20090831131626.GA17325@infradead.org>
References: <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
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
Received: from bombadil.infradead.org ([18.85.46.34]:52767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZHaNQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 09:16:43 -0400
Content-Disposition: inline
In-Reply-To: <4A9BCCEF.7010402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 09:15:27AM -0400, Ric Wheeler wrote:
>> While most common filesystem do have barrier support it is:
>>
>>   - not actually enabled for the two most common filesystems
>>   - the support for write barriers an cache flushing tends to be buggy
>>     all over our software stack,
>>
>
> Or just missing - I think that MD5/6 simply drop the requests at present.
>
> I wonder if it would be worth having MD probe for write cache enabled & 
> warn if barriers are not supported?

In my opinion even that is too weak.  We know how to control the cache
settings on all common disks (that is scsi and ata), so we should always
disable the write cache unless we know that the whole stack (filesystem,
raid, volume managers) supports barriers.  And even then we should make
sure the filesystems does actually use barriers everywhere that's needed
which failed at for years.

