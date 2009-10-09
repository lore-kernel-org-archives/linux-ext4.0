From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: ext4 corruptions
Date: Fri, 9 Oct 2009 23:53:24 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
References: <1255116014.3014.8.camel@mini>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
To: Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1255116014.3014.8.camel@mini>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


[ adding some CCs so that this doesn't get lost in the lkml wilderness ]

On Fri, 9 Oct 2009, Alexey Fisher wrote:

> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
> systems.
> The symptoms:
> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
> bad things and will try to fix it. After this action is the system
> unusable.

Does this happen also when you switch from vanilla 2.6.32-rcX to vanilla 
2.6.31, or only from vanilla 2.6.32-rcX to "Ubuntu 2.6.31"?

> Do any one had same problem? The is no sans to bisect it, after some
> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
> or fsck problem?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
