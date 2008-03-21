From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Fri, 21 Mar 2008 00:18:13 -0500
Message-ID: <47E34515.5070500@redhat.com>
References: <20080319193801.GA16687@skywalker> <20080320074740.GA11891@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYCUFTK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 01:19:10 -0400
In-Reply-To: <20080320074740.GA11891@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:

> The extent support on powerpc doesn't seems to work with e2fsprogs.
> make check on e2fsprogs on powerpc gives
>
> f_extents: basic extents support: failed
>   
I see a few things wrong:

Looks like swap_inode_full was incorrectly swapping the i_block
data for extents, as well as incorrectly checking for the 
EXTENTS flag on big-endian boxes.  Hmm maybe I need to think
a little more about symlinks with the extent flag set...

Also, pass1.c was having trouble when the extent flag was improperly
set or unset, because then the extent header was improperly unswapped
or swapped, so verify_header gave the wrong answer.  Temporarily
re-swapping the header before checking fixes... 

I'm working on a patch for these problems, trying to make it
not too ugly.  :)

-Eric



