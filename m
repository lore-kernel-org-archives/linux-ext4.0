From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 21:50:47 +0000
Message-ID: <20090121215047.GF16133@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz> <20090121214748.GE16133@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:45127 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZAUVut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jan 2009 16:50:49 -0500
Content-Disposition: inline
In-Reply-To: <20090121214748.GE16133@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Finally, I prefer maintainers of the filesystems themselves to decide
> whether their filesystem needs flushing and thus knowingly impose this
> performance penalty on them...

It could of course be a generic mount option which works with all
filesystems.

Then *administrators* can decide whether their data needs flushing,
which is where the decision should lie...

I'd vote for enabling it by default, but it's ok if it isn't.  Apps
where users expect integrity can warn if they see the option is disabled.

-- Jamie
