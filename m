From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Date: Sat, 30 Jan 2010 14:11:13 -0500
Message-ID: <20100130191113.GC10181@infradead.org>
References: <4B633F9A.8000404@sandeen.net> <20100130105501.GA22909@infradead.org> <4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org> <4B647AFE.5000507@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0A3TLO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 14:11:14 -0500
Content-Disposition: inline
In-Reply-To: <4B647AFE.5000507@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 30, 2010 at 12:31:26PM -0600, Eric Sandeen wrote:
> These are the deps that I know xfstests has, to build and to run:
> 
> BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
> BuildRequires:  libacl-devel, libattr-devel, libaio-devel
> 
> Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
> Requires:       bc, indent, quota
> 
> which isn't so bad...

Doesn't seem to bad.  Indent is afaik only needed for the weird 122 test
which doesn't apply to non-xfs filesystems.

> I'm not sure an xfsprogs dependency is so onerous; plenty has depended
> on e2fsprogs through the years and we've lived with that ;)  But
> the lag time for xfsprogs to use released xfs_io functionality is a
> bit of a bummer.
> 
> But I guess I don't have a great answer for who else uses xfs_io:

I use xfs_io in lots various local scripts.  It's a really handly
tool for exercising some of the more weird I/O related syscalls.

