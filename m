From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 08:11:28 -0400
Message-ID: <20100630121127.GA22713@infradead.org>
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca>
 <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
 <26505.1277899544@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, viro@ZenIV.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0F3MLp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 08:11:45 -0400
Content-Disposition: inline
In-Reply-To: <26505.1277899544@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 30, 2010 at 01:05:44PM +0100, David Howells wrote:
> My aim was to avoid the need to create new stat syscalls in the future by
> making it possible to increment the version number you're asking for.

The cost of adding a syscall is much smaller than adding all the wanking
in your system call.  Think about it - adding a new stat variant if a
few lines of code which add minimal icache footpint.  Even less so when
the applications using the old ones disappear for a while.  Totally
overdesigned crap like yours on the other hand adds lots of code and
branches that stay forever.  In addition to making life for strace and
co really hard if the structure ever changes.

So adding a few fields of padding at the end for new members is fine,
but doing overkill of versioning including queries for supported
versions doesn't.

