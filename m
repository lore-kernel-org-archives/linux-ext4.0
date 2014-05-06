From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and
 reduce testing complexity
Date: Tue, 6 May 2014 11:21:29 -0400
Message-ID: <20140506152129.GA31730@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231629.31890.34812.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain>
 <20140506013317.GO8434@birch.djwong.org>
 <alpine.LFD.2.00.1405061339470.2255@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52251 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbaEFPVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 11:21:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405061339470.2255@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2014 at 02:50:39PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> meta_bg - Just makes group descriptors to be spread across the file
> 	system. It has been around for some time and I am not sure
> 	why this is not a default already. It should also increase
> 	the limit of the file system size but I am not sure whether
> 	this is still true with flex_bg ?

meta_bg signiicantly slows down mount operations (and in general, any
operation where we need to read in the block group descriptors ---
i.e., dumpe2fs, e2fsck, etc.)

The strategy for meta_bg is that it's something that we enable as we
need it, as part of an online or off-line resize.  That way, we keep
the block groups contiguous for as long as possible.  Once the resize
inode has been exhausted (which _will_ happen when the file system
size grows beyond 16T), the resize operation will turn off the
resize_inode feature and then enable the meta_bg feature.

And this is all working today, with the latest kernel and e2fsprogs;
so there's no reason to enable meta_bg as part of mke2fs operation,
and a good reason not to enable it by default, but to let resize2fs
turn it on when it makes sense to do so.

        	    		       - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
