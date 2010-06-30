From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 19:36:03 +0200
Message-ID: <201006301936.03804.arnd@arndb.de>
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <201006301531.39365.arnd@arndb.de> <20100630100553.707785c7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100630100553.707785c7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 30 June 2010, Jeff Layton wrote:
> In the event that we approach running out of flags, we could even use
> the last flag as a "HAS_FLAGS2" flag, to add a new flags field at the
> end. Ugly, but it would avoid the need for a new syscall. We can kick
> that potential problem down the road though. With 64 flags to play
> with, it likely won't be a problem for a while.

Along the lines of what Christoph argued, we can also just use the
new syscall when that happens.

	Arnd
