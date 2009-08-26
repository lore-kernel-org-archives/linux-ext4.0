From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 13:15:37 +0200
Message-ID: <20090826111537.GB26595@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <19092.28371.793339.764701@notabene.brown> <20090825234454.GI4300@elf.ucw.cz> <4A94B529.1080308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rik van Riel <riel@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A94B529.1080308@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>> Ok, can you help? Having a piece of MD documentation explaining the
>> "powerfail nukes entire stripe" and how current filesystems do not
>> deal with that would be nice, along with description when exactly that
>> happens.
>
> Except of course for the inconvenient detail that a power
> failure on a degraded RAID 5 array does *NOT* nuke the
> entire stripe.

Ok, you are right. It will nuke unrelated sector somewhere on the
stripe (one that is "old" and was not recently written) -- which is
still something ext3 can not reliably handle.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
