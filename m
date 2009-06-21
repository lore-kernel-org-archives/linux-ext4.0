From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
	size
Date: Sat, 20 Jun 2009 23:57:31 -0400
Message-ID: <20090621035731.GA6719@mit.edu>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int> <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51425 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbZFURnu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2009 13:43:50 -0400
Content-Disposition: inline
In-Reply-To: <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Toshiyuki-san,

I'm curious what if any testing you've done using 128k or 256k block
sizes?  I note that EXT4_MAX_BLOCK_SIZE is still set to 65536, and of
course, > 64k blocksize testing can only take place on systes with
page sizes > 64k --- of which there are very few at the moment.

Thanks,

						- Ted
