From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 11:34:15 +0200
Message-ID: <20090825093414.GB15563@elf.ucw.cz>
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A932B18.1020209@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>>> If your concern is that with Linux MD, you could potentially lose an
>>> entire stripe in RAID 5 mode, then you should say that explicitly; but
>>> again, this isn't a filesystem specific cliam; it's true for all
>>> filesystems.  I don't know of any file system that can survive having
>>> a RAID stripe-shaped-hole blown into the middle of it due to a power
>>> failure.
>>>     
>>
>> Again, ext2 handles that in a way user expects it.
>>
>> At least I was teached "ext2 needs fsck after powerfail; ext3 can
>> handle powerfails just ok".
>
> So, would you be happy if ext3 fsck was always run on reboot (at least  
> for flash devices)?

For flash devices, MD Raid 5 and anything else that needs it; yes that
would make me happy ;-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
