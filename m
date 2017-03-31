From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] ext4: Add statx support
Date: Fri, 31 Mar 2017 09:06:07 +0100
Message-ID: <22644.1490947567@warthog.procyon.org.uk>
References: <20170317054755.GA595@zzz> <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317054755.GA595@zzz>
Content-ID: <22643.1490947567.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Biggers <ebiggers3@gmail.com> wrote:

> Ultimately this needs to be addressed in ext4 more fully, but how about for
> ->getattr() just skipping the call to ext4_get_inode_flags() and instead
> populating the generic attributes like STATX_ATTR_APPEND and
> STATX_ATTR_IMMUTABLE from the generic inode flags, rather than from the
> ext4-specific flags?  Actually, it could even be done in generic_fillattr(), so
> that all filesystems benefit.

For the moment, taking Andreas's comments into account, I'll just drop the
call to ext4_get_inode_flags() and just assume ei->i_flags is correct.

I'm not sure whether to push the APPEND and IMMUTABLE attribute transfers to
the generic code - it makes sense for all filesystems that support such flags
and not for those that don't:-/  And, true, the same could be said of the
AUTOMMOUNT attribute.

David
