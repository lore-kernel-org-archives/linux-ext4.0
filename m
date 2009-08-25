From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 14:42:10 +0100
Message-ID: <20090825144210.7c77c083@lxorguk.ukuu.org.uk>
References: <82k50tjw7u.fsf@mid.bfk.de>
	<20090824130125.GG23677@mit.edu>
	<20090824195159.GD29763@elf.ucw.cz>
	<4A92F6FC.4060907@redhat.com>
	<20090824205209.GE29763@elf.ucw.cz>
	<4A930160.8060508@redhat.com>
	<20090824212518.GF29763@elf.ucw.cz>
	<20090824223915.GI17684@mit.edu>
	<20090824230036.GK29763@elf.ucw.cz>
	<20090825000842.GM17684@mit.edu>
	<20090825094244.GC15563@elf.ucw.cz>
	<4A93E908.6050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A93E908.6050908@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Aug 2009 09:37:12 -0400
Ric Wheeler <rwheeler@redhat.com> wrote:

> I really think that the expectation that all OS's (windows, mac, even your ipod) 
> all teach you not to hot unplug a device with any file system. Users have an 
> "eject" or "safe unload" in windows, your iPod tells you not to power off or 
> disconnect, etc.

Agreed

> I don't object to making that general statement - "Don't hot unplug a device 
> with an active file system or actively used raw device" - but would object to 
> the overly general statement about ext3 not working on flash, RAID5 not working, 
> etc...

The overall general statement for all media and all OS's should be

"Do you have a backup, have you tested it recently"

