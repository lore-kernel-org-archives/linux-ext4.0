From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Thu, 03 Sep 2009 15:34:42 +0200
Message-ID: <m3ljkwnoct.fsf@intrepid.localdomain>
References: <20090828064449.GA27528@elf.ucw.cz>
	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A9FA5F2.9090704@redhat.com> (Ric Wheeler's message of "Thu, 03
	Sep 2009 07:18:10 -0400")
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ric Wheeler <rwheeler@redhat.com> writes:

>>> Just to add some support to this, all of the external RAID arrays that
>>> I know of normally run with write cache disabled on the component
>>> drives.
>>
>> Do they use "off the shelf" SATA (or PATA) disks, and if so, which ones?
>
> Which drives various vendors ships changes with specific products.
> Usually, they ship drives that have carefully vetted firmware, etc.
> but they are close to the same drives you buy on the open market.

But they aren't the same, are they? If they are not, the fact they can
run well with the write-through cache doesn't mean the off-the-shelf
ones can do as well.

Are they SATA (or PATA) at all? SCSI etc. are usually different
animals, though there are SCSI and SATA models which differ only in
electronics.

Do you have battery-backed write-back RAID cache (which acknowledges
flushes before the data is written out to disks)? PC can't do that.
-- 
Krzysztof Halasa
