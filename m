From: Rik van Riel <riel@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Wed, 26 Aug 2009 00:24:30 -0400
Message-ID: <4A94B8FE.8050307@redhat.com>
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090826002045.GO4300@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Pavel Machek wrote:

> Look, I don't need full drive failure for this to happen. I can just
> remove one disk from array. I don't need power failure, I can just
> press the power button. I don't even need to rebuild anything, I can
> just write to degraded array.
> 
> Given that all events are under my control, statistics make little
> sense here.

I recommend a sledgehammer.

If you want to lose your data, you might as well have some fun.

No need to bore yourself to tears by simulating events that are
unlikely to happen simultaneously to careful system administrators.

-- 
All rights reversed.
