From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info available
Date: Tue, 10 May 2016 09:43:43 +0100
Message-ID: <7963.1462869823@warthog.procyon.org.uk>
References: <20160510070803.GC30896@infradead.org> <20160508083543.GA14316@infradead.org> <20160429125736.23636.47874.stgit@warthog.procyon.org.uk> <20160429125743.23636.85219.stgit@warthog.procyon.org.uk> <1734.1462801101@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160510070803.GC30896@infradead.org>
Content-ID: <7962.1462869823.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> All of these are easily available.  But why special case them so that
> userspace must not ask for them?  This makes an otherwise totally
> regular interface special now.  Note that filesystems could always fill
> it out anyway and set it in the return mask.

Because it would be a waste of bits in the mask.  Is there a point in having
bits that are always going to be set unconditionally when we can just
*document* that these few fields are always going to be set.

I'm sure people can cope with the concept that some data are provided
unconditionally and don't have bits and the rest are provided conditionally
and do have bits.

I admit, though, that i_mode is tricky, since it's actually the combination of
two pieces of information - one conditional (permission bits) and one normally
unconditional (file type).  Possibly then i_mode should have two flags since I
can think of situations where the file type might be other - reparse points,
automount points.

So yes, you can look on it as there are special cases.  However, if I can drop
stat emulation support, everything resolves down to the following classes:

 (1) Stuff that's unconditional: st_dev, st_blksize, st_information (maybe).

 (2) st_mode & S_IFMT.  Unconditional or conditional?  I'm not sure.

 (3) Stuff that's conditional: st_mode & ~S_IFMT, st_rdev, st_ino, ...
     Basically everything else.

David
