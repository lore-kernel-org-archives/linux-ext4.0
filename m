From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 13:07:01 -0400
Message-ID: <20110726170701.GA3425@thunk.org>
References: <20110725155836.GF6107@quack.suse.cz>
 <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
 <20110726121225.GC20131@quack.suse.cz>
 <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44190 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1GZRHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 13:07:09 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 08:48:21PM +0800, Yongqiang Yang wrote:
> I guess there are other places where delayed extents should be handled
> by looking up page cache.
> 
> SEEK_HOLE and SEEK_DATA also need to lookup page cache to handle
> delayed extents.

Another place where we're using testing the page cache for delalloc
extents is in the bigalloc patches.  See ext4_find_delalloc_range in
Aditya's patch:

	 http://permalink.gmane.org/gmane.comp.file-systems.ext4/26619

							- Ted

