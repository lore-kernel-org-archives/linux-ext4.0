From: Pavel Machek <pavel@ucw.cz>
Subject: Re: MD/DM and barriers (was Re: [patch] ext2/3: document
	conditions when reliable operation is possible)
Date: Tue, 1 Sep 2009 16:01:21 +0200
Message-ID: <20090901140120.GD2028@ucw.cz>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu> <4A9685D4.2070906@redhat.com> <4A96BA2D.60804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A96BA2D.60804@garzik.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 2009-08-27 12:54:05, Jeff Garzik wrote:
> On 08/27/2009 09:10 AM, Ric Wheeler wrote:
>> One thing that does need fixing for some MD configurations is to stress
>> again that we need to make sure that barrier operations are properly
>> supported or users will need to disable the write cache on devices with
>> volatile write caches.
>
> Agreed; chime in on Christoph's linux-vfs thread if people have input.
>
> I quickly glanced at MD and DM.  Currently, upstream, we see a lot of
>
>         if (unlikely(bio_barrier(bio))) {
>                 bio_endio(bio, -EOPNOTSUPP);
>                 return 0;
>         }
>
> in DM and MD make_request functions.
>
> Only md/raid1 supports barriers at present, it seems.  None of the other  
> MD drivers support barriers.

Not even md/raid0? Ouch :-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
