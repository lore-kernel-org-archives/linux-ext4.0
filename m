From: Duane Griffin <duaneg@dghda.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
	ext4_statfs()
Date: Mon, 23 Nov 2009 14:40:52 +0000
Message-ID: <e9e943910911230640v3ec7c15cs4514e7802200a004@mail.gmail.com>
References: <4AF4A429.7090507@redhat.com>
	 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
	 <20091108214804.GC7592@mit.edu>
	 <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
	 <20091115032941.GB4323@mit.edu>
	 <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
	 <20091119190846.GB2099@thunk.org>
	 <e9e943910911230357r338bcb45ga6962c92d32fca4a@mail.gmail.com>
	 <20091123142658.GE2532@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <andreas.dilger@lustre.org>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53684 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZKWOkr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 09:40:47 -0500
Received: by fxm5 with SMTP id 5so4684737fxm.28
        for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 06:40:52 -0800 (PST)
In-Reply-To: <20091123142658.GE2532@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/11/23  <tytso@mit.edu>:
> On Mon, Nov 23, 2009 at 11:57:44AM +0000, Duane Griffin wrote:
>> Unfortunately you can't just blindly give back the journalled block:
>> it may have been escaped. So you need to read in the block from the
>> journal, unescape it if required, then give it back.
>
> Good point; this is going to make supporting a read-only mount that
> doesn't replay the journal very difficult to implement for
> data=journal mode, since it would mean intercepting the actual block
> I/O read functions for data reads, which is outside of fs/ext4 in the
> generic fs/ and mm/ functions.  Doing it for metadata blocks will be
> annoying, but at least it's all inside fs/ext4.

Yes, that is the sticking point I got to with my last attempt at this :(

I was kinda hoping that someone would have a bright idea that doesn't
involve hacking an IO completion callback into get_block_t...

>                                        - Ted

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
