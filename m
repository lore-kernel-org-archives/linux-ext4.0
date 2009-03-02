From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: how to scale root-reserved space going forward...
Date: Mon, 02 Mar 2009 10:26:21 -0600
Message-ID: <49AC08AD.7050602@redhat.com>
References: <49AB0ABE.1030009@redhat.com> <20090302024754.GF6973@mit.edu> <20090302085632.GM3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZCBQ0a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2009 11:26:30 -0500
In-Reply-To: <20090302085632.GM3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> I suspect that at a certain filesystem size, there isn't much benefit
> in having more reserved space.  If we keep 50GB of reserved space then
> this is likely to contain a decent amount of 1MB free chunks, which is
> what we really care about.
> 
> Cheers, Andreas

As long as we don't care much about inode<->block locality, that is
probably ok...

I got one off-list reply from someone who was depending on the 5% for
administration reasons, but even if we change the default I assume we'll
leave the tunable in place for people who really do want 5% for
"root-reserved" over "allocator safety buffer" reasons.

-Eric

