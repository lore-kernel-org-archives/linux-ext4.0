From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 08:28:13 -0400
Message-ID: <20090826122813.GI32712@mit.edu>
References: <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090826111751.GC26595@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 26, 2009 at 01:17:52PM +0200, Pavel Machek wrote:
> > Metadata takes up such a small part of the disk that fscking
> > it and finding it to be OK is absolutely no guarantee that
> > the data on the filesystem has not been horribly mangled.
> >
> > Personally, what I care about is my data.
> >
> > The metadata is just a way to get to my data, while the data
> > is actually important.
> 
> Personally, I care about metadata consistency, and ext3 documentation
> suggests that journal protects its integrity. Except that it does not
> on broken storage devices, and you still need to run fsck there.

Caring about metadata consistency and not data is just weird, I'm
sorry.  I can't imagine anyone who actually *cares* about what they
have stored, whether it's digital photographs of child taking a first
step, or their thesis research, caring about more about the metadata
than the data.  Giving advice that pretends that most users have that
priority is Just Wrong.

That's why what we should document is that people should avoid broken
storage devices, and advice on how to use RAID properly.  At the end
of the day, getting people to switch from ext2 to ext3 on some
misguided notion that this way, they'll know when their metadata is
safe (at least in the power failure case; but not the system hangs and
you have to reboot case), and getting them to ignore the question of
why are they using a broken storage device in the first place, is
Documentation malpractice.

						- Ted
