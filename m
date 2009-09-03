From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Update Documentation/md.txt to mention journaling
	won't help dirty+degraded case.
Date: Thu, 3 Sep 2009 11:08:39 +0200
Message-ID: <20090903090839.GF3793@elf.ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz> <200909021749.47695.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909021749.47695.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 2009-09-02 17:49:46, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Add more warnings to the "Boot time assembly of degraded/dirty arrays" section,
> explaining that using a journaling filesystem can't overcome this problem.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

I like it! Not sure if I know enough about MD to add ack, but...

Acked-by: Pavel Machek <pavel@ucw.cz>

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
