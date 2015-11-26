From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/12] statx: Provide IOC flags for Windows fs attributes
Date: Thu, 26 Nov 2015 15:35:29 +0000
Message-ID: <7976.1448552129@warthog.procyon.org.uk>
References: <20151124195256.GB3482@thunk.org> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <20151120145447.18930.5308.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, arnd@arndb.de, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151124195256.GB3482@thunk.org>
Content-ID: <7975.1448552129.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o <tytso@mit.edu> wrote:

> As a result, I would suggest that we not try to use the
> FS_IOC_[GS]ETFLAGS number scheme for any new interface, so we're at
> least not making a bad situation worse.
> 
> The only reason why some other file systems have chosen to use
> FS_IOC_[GS]ETFLAGS, instead of defining their own ioctl, is so they
> can use lsattr/chattr from e2fsprogs instead of creating their own
> utility.  But for statx, there isn't a good reason use the same flags
> number space.  At the very least, can we use a new flags field for the
> Windows file attributes?  It's not like lsattr/chattr has the ability
> to set those flags today anyway.  So we might as well use a new flags
> field and a new flags numberspace for them.

Hmmm...  I was trying to make it so that these bits would be saved to disk as
part of the IOC flags so that Samba could make use of them.  I guess they'll
have to be stored in an xattr instead.

David
