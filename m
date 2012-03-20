From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 21:06:06 -0400
Message-ID: <20120320010606.GC14363@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
 <20120319040950.GG31682@thunk.org>
 <1332131137.23125.44.camel@joe2Laptop>
 <4F6762F1.7050902@gmail.com>
 <1332176943.1983.28.camel@joe2Laptop>
 <171703.1332178579@turing-police.cc.vt.edu>
 <1332179050.3341.7.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46953 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab2CTBGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:06:11 -0400
Content-Disposition: inline
In-Reply-To: <1332179050.3341.7.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 10:44:10AM -0700, Joe Perches wrote:
> 
> This stuff ain't whitespace.
> 

I'll have to respectfully disagree with you.  For ext4, as far as I am
concerned, changing printk(KERN_INFO, ...) to pr_info(...) is *purely*
a whitespace-level change.

						- Ted
