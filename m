From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Sat, 02 Dec 2006 14:02:53 +0300
Message-ID: <m33b7ylfvm.fsf@bzzz.home.net>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:60565 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1162935AbWLBLCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Dec 2006 06:02:55 -0500
To: "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <E1GXeYv-0006rP-RV@candygram.thunk.org> (Theodore Ts'o's message
	of "Wed\, 11 Oct 2006 09\:55\:57 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>>>>> Theodore Ts'o (TT) writes:

 TT> Storing the tail as an extended attribute
 TT> =========================================
 TT> BSD FFS/UFS Fragments
 TT> =====================

what if we would apply BSD FFS/UFS Fragments design to inodes?
something like basic inode size is still 128 bytes, but we
could unite few contiguous inodes to a larger one and use that
space to store extented attributes, including a tail ?

I foresee couple issues:

a) as we can't predict tail size, we'd need to be able
   to reallocate inode or do some sort of delayed inode
   allocation

b) inode space is quite limited and this why we may exhaust
   it very quickly

thanks, Alex

  
