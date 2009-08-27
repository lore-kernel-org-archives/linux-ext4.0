From: Rik van Riel <riel@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 23:29:56 -0400
Message-ID: <4A95FDB4.3050904@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <19092.28371.793339.764701@notabene.brown> <20090825234454.GI4300@elf.ucw.cz> <4A94B529.1080308@redhat.com> <20090826111537.GB26595@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752515AbZH0Da6@vger.kernel.org>
In-Reply-To: <20090826111537.GB26595@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Ok, can you help? Having a piece of MD documentation explaining the
>>> "powerfail nukes entire stripe" and how current filesystems do not
>>> deal with that would be nice, along with description when exactly that
>>> happens.
>> Except of course for the inconvenient detail that a power
>> failure on a degraded RAID 5 array does *NOT* nuke the
>> entire stripe.
> 
> Ok, you are right. It will nuke unrelated sector somewhere on the
> stripe (one that is "old" and was not recently written) -- which is
> still something ext3 can not reliably handle.

Not quite unrelated.  The "nuked" sector will be the one
that used to live on the disk that is broken and no longer
a part of the RAID 5 array.

I wouldn't qualify a missing hard disk as a software issue...

-- 
All rights reversed.
