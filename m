From: Jan Kara <jack@suse.cz>
Subject: Re: old/new ext3 compatibility
Date: Mon, 23 Mar 2009 19:34:28 +0100
Message-ID: <20090323183428.GE15488@atrey.karlin.mff.cuni.cz>
References: <20090319184501.GG3634@mtholyoke.edu> <20090319220224.GM3634@mtholyoke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ron Peterson <rpeterso@mtholyoke.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36294 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbZCWSea (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 14:34:30 -0400
Content-Disposition: inline
In-Reply-To: <20090319220224.GM3634@mtholyoke.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 2009-03-19_14:45:02-0400 rpeterso:
> > As I understand it, debian lenny's ext3 filesystem uses 256 byte inodes,
> > to be forward compatible with ext4.
> > 
> > I have a production server running debian etch.  It is attached to a
> > fiber channel array, on which it has several ext3 filesystems.  I'm
> > installing a new server, and I'd like to use lenny.  It will be attached
> > to the same array, and I'd like to be able to occasionally use the ext3
> > filesystems created previously.  Ideally, I'd also like to go the other
> > direction as well.  Is this possible, or just crazy talk?
> 
> If I understand what I'm reading correctly, this is a non-problem.  Any
> recent 2.6 kernel should understand ext3 filesystems with 256 byte
> inodes just fine.  The only thing that has happened is that the latest
> debian stable defaults to using 256 byte inodes rather than 128.  Is
> that correct?  Are there any gotcha's here that I should be aware of?
  Yes. Any 2.6 kernel will understand both inode sizes. It is just a
matter of a default in mkfs. Larger inodes allow for more effective
handling of extended attributes, ACLs and such but waste more
space/throughput in case you don't use them...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
