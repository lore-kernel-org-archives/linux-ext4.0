From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 11:16:00 -0500
Message-ID: <20101119161600.GH10039@thunk.org>
References: <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org>
 <20101119141007.GB25488@infradead.org>
 <20101119153748.GE10039@thunk.org>
 <20101119155003.GA7145@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Lord <kernel@teksavvy.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48713 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0KSQQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 11:16:07 -0500
Content-Disposition: inline
In-Reply-To: <20101119155003.GA7145@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 10:50:03AM -0500, Christoph Hellwig wrote:
> 
> It's a huge issue for virtualization, where naive TRIM implementations
> can expose data deleted in one VM to others.  It's also a huge issues
> for RAIDs as mentioned by you.

Fair enough, I'll buy that.  If you are sharing an SSD using
virtualization across two VM's with different trust bounaries,
non-deterministic TRIM could very well be an issue, depending on how
it the "non-deterministic" bit was implemented.

(I can think of one PCIe-attached flash implementation I know of where
the trim is simply not persistent across a power failure, such that if
Alice trims a block, it will return 0, but if no one rewrites the
block before a power failure, then reading that some block will return
Alice's original data, and not data belonging to Bob.  This would be
an example of a non-deterministic TRIM that would be problematic for
RAID, but not from a security perspective.  OTOH, the trim command is
blazingly fast on this implementation, since there is absolutely no
flash write or erase operation associated with the TRIM, and so mount
-o discard makes a lot of sense for this particular storage device.)

						- Ted
