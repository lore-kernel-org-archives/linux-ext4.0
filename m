From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sat, 11 Dec 2010 21:34:15 -0500
Message-ID: <20101212023415.GG3059@thunk.org>
References: <20101209201359.GG2921@thunk.org>
 <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box>
 <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org>
 <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56796 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab0LLCeb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Dec 2010 21:34:31 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One experiment --- can you try this with the file system mounted with
data=writeback, and see if the problem reproduces in that journalling
mode?

I want to rule out (if possible) journal_submit_inode_data_buffers()
racing with mpage_da_submit_io().  I don't think that's the issue, but
I'd prefer to do the experiment to make sure.  So if you can use a
kernel and system configuration which triggers the problem, and then
try changing the mount options to include data=writeback, and then
rerun the test, and let me know if the problem still reproduces, I'd
be really grateful.

Thanks,

					- Ted
