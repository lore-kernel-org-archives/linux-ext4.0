From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 03/12] statx: Add a system call to make enhanced file info available
Date: Mon, 21 Dec 2015 23:21:24 +0000
Message-ID: <4234.1450740084@warthog.procyon.org.uk>
References: <20151204120633.GI14427@amd> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <20151120145457.18930.79678.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, arnd@arndb.de, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151204120633.GI14427@amd>
Content-ID: <6178.1449249670.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> But fstat() is really different operation to stat() -- tell me about
> my file descriptor vs. tell me about this filename, and ptrace (and
> some "security" solutions) might want to allow one but disallow the
> second. I'd not group them together..

You can argue it either way.  I think Linus came down on the side of combining
them.

David
