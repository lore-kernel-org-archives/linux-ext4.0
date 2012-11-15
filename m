From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Thu, 15 Nov 2012 11:10:41 -0800
Message-ID: <20121115191041.GB27207@lenny.home.zabbo.net>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
 <1352794923-28555-1-git-send-email-lczerner@redhat.com>
 <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
 <alpine.LFD.2.00.1211131304030.3577@localhost>
 <20121113141911.GA7472@X61>
 <20121113185104.GC1282@lenny.home.zabbo.net>
 <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peng Tao <bergwolf@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, dmonakhov@openvz.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423636Ab2KOTKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 14:10:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I have prepared a path to fix this and I am going to test this
> right not. Basically it will:
> 
> 1. remove the callback
> 
> 2. rename functions
> 	ext4_ext_walk_space -> ext4_fill_fiemap_extents
> 	ext4_ext_fiemap_cb -> ext4_find_delayed_extent
> 
> 3. put fiemap_fill_next_extent() into ext4_fill_fiemap_extents)_
> 
> 4. Call ext4_find_delayed_extent() only for non existing extents
> 
> 5. Use GFP_NOFS in ext4_find_delayed_extent()
> 
> 5. hold the i_data_sem for:
> 	ext4_ext_find_extent()
> 	ext4_ext_next_allocated_block()
> 	ext4_find_delayed_extent()
> 
> 6. call fiemap_fill_next_extent after releasing the i_data_sem
> 
> does it sounds ok?

That sounds.. good?  I'm no ext* locking expert :).

> ---
> I should probably split that into two parts to make the changes
> clearer, because removing the if (newex->ec_start == 0) in the old
> ext4_ext_fiemap_cb() obfuscated it a lot.

Yeah, definitely.  I found myself squinting looking for code changes in
all the code motion.

- z
