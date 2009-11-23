From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
 ext4_statfs()
Date: Mon, 23 Nov 2009 09:26:58 -0500
Message-ID: <20091123142658.GE2532@thunk.org>
References: <4AF4A429.7090507@redhat.com>
 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
 <20091108214804.GC7592@mit.edu>
 <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
 <20091115032941.GB4323@mit.edu>
 <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
 <20091119190846.GB2099@thunk.org>
 <e9e943910911230357r338bcb45ga6962c92d32fca4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@lustre.org>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57796 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZKWO1A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 09:27:00 -0500
Content-Disposition: inline
In-Reply-To: <e9e943910911230357r338bcb45ga6962c92d32fca4a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 11:57:44AM +0000, Duane Griffin wrote:
> Unfortunately you can't just blindly give back the journalled block:
> it may have been escaped. So you need to read in the block from the
> journal, unescape it if required, then give it back.

Good point; this is going to make supporting a read-only mount that
doesn't replay the journal very difficult to implement for
data=journal mode, since it would mean intercepting the actual block
I/O read functions for data reads, which is outside of fs/ext4 in the
generic fs/ and mm/ functions.  Doing it for metadata blocks will be
annoying, but at least it's all inside fs/ext4.

					- Ted
