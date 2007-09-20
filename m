From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Thu, 20 Sep 2007 17:54:27 -0400
Message-ID: <20070920215427.GL30221@thunk.org>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48568 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXITVya (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 17:54:30 -0400
Content-Disposition: inline
In-Reply-To: <46F2D678.4060203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2007 at 03:22:16PM -0500, Eric Sandeen wrote:
> I'd do this, my rpm-fu is still reasonably strong, though - I'm curious,
> is there a compelling reason to split out just libcom-err?  what about
> libuuid?  libblkid?  e2fsprogs is a bit of a grab bag of things.  What's
> the rationale for the split?

Nope, there isn't much rationale unless we also split out fsck, so
that people who don't want to use any ext 2/3/4 filesystems don't need
to install programs like e2fsck, mke2fs, libext2fs.so, etc.   

The main reason why Debian did was more out of code wanking reasons
than anything else, as far as I know....

     	           	      	       	      	- Ted
