From: Theodore Tso <tytso@mit.edu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000000 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Fri, 2 Jan 2009 00:08:54 -0500
Message-ID: <20090102050854.GH17821@mit.edu>
References: <20081209104121.GA7572@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60693 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZABFI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jan 2009 00:08:57 -0500
Content-Disposition: inline
In-Reply-To: <20081209104121.GA7572@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 09, 2008 at 04:11:22PM +0530, Aneesh Kumar K.V wrote:
> 
> I have one question regarding the patch. What about blocks allocated for
> directories for the  ext3 format.  With extent format we are not
> setting EXT4_MB_HINT_DATA for non regular files. So i guess we also
> need the below patch .

I've updated the remove-ext4_new_blocks to include your suggested
patch.  I would like to try implementing a new, more intelligent
allocation algorithm later, though.

						- Ted
