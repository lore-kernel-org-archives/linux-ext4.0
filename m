From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize extent selection for block removal in
 case of hole punch
Date: Sun, 23 Jun 2013 14:43:25 -0400
Message-ID: <20130623184325.GD16620@thunk.org>
References: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
 <20130618154053.GF7359@thunk.org>
 <CAOiN93mMc1zG-YToRxVfbm8iDeeB6roJ_AZKcXJgGpfS+yn9xA@mail.gmail.com>
 <20130619140605.GA24194@thunk.org>
 <CAOiN93=8fTSxNOuzQEhrg69FHb2uCNdLWXKObhGPLqaqXX0B4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60528 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FWSn3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 14:43:29 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93=8fTSxNOuzQEhrg69FHb2uCNdLWXKObhGPLqaqXX0B4A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas's patch: "ext4: only zero partial blocks in
ext4_zero_partial_blocks()" appears to address the failures I was
seeing with xfstests 269 and 270, so I'm going to add this patch back
to the ext4 git tree.

Regards,

					- Ted
