From: Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Subject: Re: ext4 corruptions
Date: Sat, 10 Oct 2009 09:29:44 +0200
Message-ID: <1255159784.27545.4.camel@zwerg>
References: <1255116014.3014.8.camel@mini>
	 <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
	 <4ACFB337.8040109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>,
	Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
To: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ACFB337.8040109-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Am Freitag, den 09.10.2009, 17:03 -0500 schrieb Eric Sandeen:
> Jiri Kosina wrote:
> > [ adding some CCs so that this doesn't get lost in the lkml wilderness ]
> > 
> > On Fri, 9 Oct 2009, Alexey Fisher wrote:
> > 
> >> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
> >> systems.
> >> The symptoms:
> >> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
> >> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
> >> bad things and will try to fix it. After this action is the system
> >> unusable.
> > 
> > Does this happen also when you switch from vanilla 2.6.32-rcX to vanilla 
> > 2.6.31, or only from vanilla 2.6.32-rcX to "Ubuntu 2.6.31"?
> > 
> >> Do any one had same problem? The is no sans to bisect it, after some
> >> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
> >> or fsck problem?
> > 
> 
> Not sure if this is the same as
> http://bugzilla.kernel.org/show_bug.cgi?id=14354 but it's similarly
> lacking in useful info ;)
> 
> Please provide the fsck output, any kernel messages, etc ...
> 
> -Eric

Thank you for the tip. These systems i need for testing graphic
regressions, so i'll try reproduce it on virtual system.

Alexey
