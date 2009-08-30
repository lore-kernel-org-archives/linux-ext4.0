From: Theodore Tso <tytso@mit.edu>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 11:20:23 -0400
Message-ID: <20090830152023.GB23828@mit.edu>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753797AbZH3PVB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090830075135.GA1874@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 30, 2009 at 09:51:35AM +0200, Pavel Machek wrote:
> 
> If it only was this simple. We don't have 'check brakes' (aka
> 'journalling ineffective') warning light. If we had that, I would not
> have problem.

But we do; comptently designed (and in the cast of software RAID,
competently packaged) RAID subsystems send notifications to the system
administrator when there is a hard drive failure.  Some hardware RAID
systems will send a page to the system administrator.  A mid-range
Areca card has a separate ethernet port so it can send e-mail to the
administrator, even if the OS is hosed for some reason.

And it's not a matter of journalling ineffective; the much bigger deal
is, "your data is at risk"; perhaps because the file system metadata
may become subject to corruption, but more critically, because the
file data may become subject to corruption.  Metadata becoming subject
to corruption is important primarily because it leads to data becoming
corruption; metadata is the tail; the user's data is the dog.

So we *do* have the warning light; the problem is that just as some
people may not realize that "check brakes" means, "YOU COULD DIE",
some people may not realize that "hard drive failure; RAID array
degraded" could mean, "YOU COULD LOSE DATA".

Fortunately, for software RAID, this is easily solved; if you are so
concerned, why don't you submit a patch to mdadm adjusting the e-mail
sent to the system administrator when the array is in a degraded
state, such that it states, "YOU COULD LOSE DATA".  I would gently
suggest to you this would be ***far*** more effective that a patch to
kernel documentation.

						- Ted
