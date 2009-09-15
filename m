From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Question on readdir implementation
Date: Tue, 15 Sep 2009 17:56:32 +0000
Message-ID: <87ocpcf5wv.fsf@mid.deneb.enyo.de>
References: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
	<20090915145337.GB23118@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhang Huan <zhhuan@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.enyo.de ([212.9.189.167]:51218 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbZIOScJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2009 14:32:09 -0400
In-Reply-To: <20090915145337.GB23118@mit.edu> (Theodore Tso's message of "Tue,
	15 Sep 2009 10:53:37 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso:

> So this is something we could do in the future.  In practice, no one
> has complained about this as far as NFS is concerned, so it's not high
> priority for me to pursue.  Were you worried about this as a practical
> matter, or as a theoretical one?

readdir returning entries in essentially randomized order is a
practical performance problem for many things, from grep -r to tar. 8-(
(My recent FIBMAP/FIEMAP question was related to that, too.)
