From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 10:44:28 -0600
Message-ID: <658720A3-2331-4A79-9FCC-67096AE40800@dilger.ca>
References: <20110725155836.GF6107@quack.suse.cz> <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com> <20110726121225.GC20131@quack.suse.cz> <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com> <4E2EEB93.1010106@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:41920 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1GZQo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 12:44:29 -0400
In-Reply-To: <4E2EEB93.1010106@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 26-07-11 09:20:28, Yongqiang Yang wrote:
> I have been thinking if we can handle fiemap much simpler for a while.
> Current code is very ugly due to page cache look up.  I have a
> thought on simplifying these code.  The reason leading us to looking
> up page cache is that delayed extents are not in extents tree.  I
> think we can add an in-memory delayed extents list in inode, and we
> can delete entries in the list after we allocate blocks for them.
> There is no limit on length of extents in the list, this way can an
> entry contain as many blocks as they are contiguous logically.
> 
> What's your opinion?

It may also be useful to have an extent list for submitting large contiguous writeouts to disk, instead of having to look them up.

The main question is whether the added overhead of maintaining the list is worthwhile if we can get an equivalent functionality using a tag lookup in the page cache.

Cheers, Andreas





