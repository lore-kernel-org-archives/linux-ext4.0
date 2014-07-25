From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Fri, 25 Jul 2014 10:07:15 -0400
Message-ID: <20140725140715.GR1865@thunk.org>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
 <20140725081312.GO6397@azat>
 <53D24307.6050903@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56520 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643AbaGYOHT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 10:07:19 -0400
Content-Disposition: inline
In-Reply-To: <53D24307.6050903@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 07:44:07PM +0800, Brad Campbell wrote:
> 
> Appreciate you taking a look at this and I see where you are going with it.

This patch looks good to me.  If you could give it a try, I would
appreciate it.

This looks like the same bug which was reported in Ubuntu:

https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/1321958

							- Ted
