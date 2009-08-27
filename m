From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: MD/DM and barriers (was Re: [patch] ext2/3: document
	conditions when reliable operation is possible)
Date: Thu, 27 Aug 2009 19:09:42 +0100
Message-ID: <20090827180942.GA8140@agk-dp.fab.redhat.com>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu> <4A9685D4.2070906@redhat.com> <4A96BA2D.60804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A96BA2D.60804@garzik.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 27, 2009 at 12:54:05PM -0400, Jeff Garzik wrote:
> DM has some barrier code...  but the above code was pasted from DM's  
> make_request function, so I am guessing that DM's barrier stuff is  
> incomplete and disabled at present.

That code is from the new request-based multipath implementation in 2.6.31
which doesn't yet.

But bio-based dm does support barriers now.  (Just missing some patches to
complete the dm-raid1 support that are still under review IIRC.)

Alasdair
