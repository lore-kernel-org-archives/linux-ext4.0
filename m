From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Wed, 02 Sep 2009 21:59:43 -0400
Message-ID: <4A9F230F.40707@redhat.com>
References: <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca> <20090831132139.GA5425@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <lkml@rtr.ca>, Michael Tokarev <mjt@tls.msk.ru>,
	david@lang.hm, Pavel Machek <pavel@ucw.cz>,
	Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090831132139.GA5425@infradead.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/31/2009 09:21 AM, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 09:19:58AM -0400, Mark Lord wrote:
>>> In my opinion even that is too weak.  We know how to control the cache
>>> settings on all common disks (that is scsi and ata), so we should always
>>> disable the write cache unless we know that the whole stack (filesystem,
>>> raid, volume managers) supports barriers.  And even then we should make
>>> sure the filesystems does actually use barriers everywhere that's needed
>>> which failed at for years.
>> ..
>>
>> That stack does not know that my MD device has full battery backup,
>> so it bloody well better NOT prevent me from enabling the write caches.
>
> No one is going to prevent you from doing it.  That question is one of
> sane defaults.  And always safe, but slower if you have advanced
> equipment is a much better default than usafe by default on most of
> the install base.
>

Just to add some support to this, all of the external RAID arrays that I know of 
normally run with write cache disabled on the component drives. In addition, 
many of them will disable their internal write cache if/when they detect that 
they have lost their UPS.

I think that if we had done this kind of sane default earlier for MD levels that 
do not handle barriers, we would not have left some people worried about our 
software RAID.

To be clear, if a sophisticated user wants to override this default, that should 
be supported. It is not (in my opinion) a safe default behaviour.

Ric

