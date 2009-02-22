From: Theodore Tso <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sun, 22 Feb 2009 15:00:26 -0500
Message-ID: <20090222200026.GG17066@mit.edu>
References: <1235115642.22702.2.camel@localhost.localdomain> <499ECF5C.7020509@redhat.com> <1235155713.22702.25.camel@localhost.localdomain> <20090220193013.GA28530@mini-me.lan> <1235276519.7599.7.camel@localhost.localdomain> <20090222043126.GE17066@mit.edu> <1235280141.7599.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41200 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbZBVUAc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Feb 2009 15:00:32 -0500
Content-Disposition: inline
In-Reply-To: <1235280141.7599.37.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 22, 2009 at 06:22:21PM +1300, Andreas Friedrich Berendsen wrote:
> Tso,
> 
> If you look my previous e-mails, you will see that I included an output
> fro my fsck program, which is version 1.41.4 (second output bewlo):
> 
> # fsck
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)

So this was the version where e2fsck core dumped?  Do you remember
what sort of messages it printed out before the core dump?  That would
have been very useful indeed.

					- Ted
