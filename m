From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 10:05:53 -0400
Message-ID: <20100630100553.707785c7@tlielax.poochiereds.net>
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca>
	<26505.1277899544@redhat.com>
	<20100630121127.GA22713@infradead.org>
	<201006301531.39365.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, viro@zeniv.linux.org.uk,
	smfrench@gmail.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0F3OGJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 10:06:09 -0400
In-Reply-To: <201006301531.39365.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 30 Jun 2010 15:31:39 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 30 June 2010, Christoph Hellwig wrote:
> > The cost of adding a syscall is much smaller
> 
> Ack. No need for different struct layout version since we
> can add another stat syscall every ten years.
> 
> > So adding a few fields of padding at the end for new members is fine,
> > but doing overkill of versioning including queries for supported
> > versions doesn't.
> 
> The ability to request and return a subset of the fields seems useful
> regardless and it can be used to avoid the need for this kind of padding.
> A sufficient amount of padding wouldn't be too bad either, but I guess
> we should not have both the padding _and_ the option for extending the
> structure after the padding.
> 
> With the padding, the 'size' argument can go away, though I'd argue that
> even without the padding we can safely add extra fixed-length fields
> when needed and not need a size argument.
> 

Simply having a flags field seems sufficient to me too. I don't think
we need padding, version or a size. Just make it a "rule" that if you
add a new field that it has to go at the end of the struct and a new
flag has to go with it. The kernel will need to only fill out fields
that are requested and that it knows about.

In the event that we approach running out of flags, we could even use
the last flag as a "HAS_FLAGS2" flag, to add a new flags field at the
end. Ugly, but it would avoid the need for a new syscall. We can kick
that potential problem down the road though. With 64 flags to play
with, it likely won't be a problem for a while.

-- 
Jeff Layton <jlayton@redhat.com>
