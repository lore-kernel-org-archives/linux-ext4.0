From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 16:57:05 +0400
Message-ID: <20140726125705.GD24045@azat>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
 <20140725081312.GO6397@azat>
 <53D24307.6050903@fnarfbargle.com>
 <20140725140715.GR1865@thunk.org>
 <53D320F6.40809@fnarfbargle.com>
 <20140726124557.GB6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Brad Campbell <lists2009@fnarfbargle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57068 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGZM5N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 08:57:13 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so4246676lbv.2
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2014 05:57:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140726124557.GB6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 08:45:57AM -0400, Theodore Ts'o wrote:
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
> extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
> extra_isize
> Block count:              5804916736
> Reserved GDT blocks:      585
> 
> If the block count is greater than 2**32 (4294967296), resize_inode
> must not be set, and reserved GDT blocks should be zero.  So this is
> definitely not right.

I've just tried to reproduce this on 24T->48T raid0 array (resizing from
24T to 48T), without any success.
And that's why: I don't have resize_inode in filesystem features.
Thanks for pointing on this, Ted.

Cheers,
Azat.

