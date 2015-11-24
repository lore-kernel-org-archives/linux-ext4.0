From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 01/12] Ext4: Fix extended timestamp encoding and decoding
Date: Tue, 24 Nov 2015 21:10:53 +0100
Message-ID: <3495329.crWmoA5ACn@wuerfel>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <20151120145434.18930.89755.stgit@warthog.procyon.org.uk> <20151124193646.GA3482@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124193646.GA3482-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 24 November 2015 14:36:46 Theodore Ts'o wrote:
> This is the patch I would prefer to use (and in fact which I have
> added to the ext4 tree):
> 
> There are issues with 32-bit vs 64-bit encoding of times before
> January 1, 1970, which are handled with this patch which is not
> handled with what you have in your patch series.  So I'd prefer if you
> drop this patch, and I'll get this sent to Linus as a bug fix for 4.4.

I'm happy with either one. Apparently both Davids have arrived with
almost the same algorithm and implementation, with the exception of
the pre-1970 handling you mention there.

	Arnd
