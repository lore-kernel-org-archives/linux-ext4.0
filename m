From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: remove a useless check for the function
 ext4_data_block_valid
Date: Sun, 27 Jan 2013 07:38:31 -0500
Message-ID: <20130127123831.GC23996@thunk.org>
References: <51045F77.5000106@gmail.com>
 <20130126153826.GB5887@thunk.org>
 <5105CA65.7020504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45692 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3A0Mid (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2013 07:38:33 -0500
Content-Disposition: inline
In-Reply-To: <5105CA65.7020504@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 27, 2013 at 04:46:29PM -0800, Wang Shilong wrote:
> > Actually, it can be true --- if start_blk + count (which are both
> > unsigned integers) overflows....
>     Yeah,you are right....
>     I am sorry,I miss the overflow condition...

We added it because we saw a crash that was a caused by an overflow,
if memory serves correctly.  Or maybe it was a mysterious data or file
system corruption that was incredibly painful to find.

Fun trivia fact: the European Space Agency had the Ariane 5 rocket
explode on its maiden flight due to a integer overflow bug.

	       	      	     	      - Ted


