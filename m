From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 01/12] Ext4: Fix extended timestamp encoding and decoding
Date: Sat, 28 Nov 2015 21:45:55 -0500
Message-ID: <20151129024555.GA31968@thunk.org>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <20151120145434.18930.89755.stgit@warthog.procyon.org.uk>
 <20151124193646.GA3482@thunk.org>
 <3495329.crWmoA5ACn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3495329.crWmoA5ACn@wuerfel>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 24, 2015 at 09:10:53PM +0100, Arnd Bergmann wrote:
> On Tuesday 24 November 2015 14:36:46 Theodore Ts'o wrote:
> > This is the patch I would prefer to use (and in fact which I have
> > added to the ext4 tree):
> > 
> > There are issues with 32-bit vs 64-bit encoding of times before
> > January 1, 1970, which are handled with this patch which is not
> > handled with what you have in your patch series.  So I'd prefer if you
> > drop this patch, and I'll get this sent to Linus as a bug fix for 4.4.
> 
> I'm happy with either one. Apparently both Davids have arrived with
> almost the same algorithm and implementation, with the exception of
> the pre-1970 handling you mention there.

I was doing some testing on x86, which leads me to ask --- what's the
current thinking about post y2038 on 32-bit platforms such as x86?  I
see that there was some talk about using struct timespec64, but we
haven't made the transition in the VFS interfaces yet, despite a
comment in an LWN article from 2014 stating that "the first steps have
been taken; hopefully the rest will follow before too long".

Cheers,

					- Ted
