From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Ext4: Fix extended timestamp encoding and decoding
Date: Thu, 26 Nov 2015 15:28:36 +0000
Message-ID: <7814.1448551716@warthog.procyon.org.uk>
References: <20151124193646.GA3482@thunk.org> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <20151120145434.18930.89755.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124193646.GA3482-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Content-ID: <7813.1448551716.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:

> This is the patch I would prefer to use (and in fact which I have
> added to the ext4 tree):
> 
> There are issues with 32-bit vs 64-bit encoding of times before
> January 1, 1970, which are handled with this patch which is not
> handled with what you have in your patch series.  So I'd prefer if you
> drop this patch, and I'll get this sent to Linus as a bug fix for 4.4.

Fine by me.

Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
