From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and reduce
 testing complexity
Date: Tue, 6 May 2014 17:30:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061729340.2255@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231629.31890.34812.stgit@birch.djwong.org> <alpine.LFD.2.00.1405021133520.2154@localhost.localdomain> <20140506013317.GO8434@birch.djwong.org> <alpine.LFD.2.00.1405061339470.2255@localhost.localdomain>
 <20140506152129.GA31730@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-45909237-1399390226=:2255"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbaEFQEf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 12:04:35 -0400
In-Reply-To: <20140506152129.GA31730@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-45909237-1399390226=:2255
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 May 2014, Theodore Ts'o wrote:

> Date: Tue, 6 May 2014 11:21:29 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 37/37] ext5: define new subtype to add features and reduce
>      testing complexity
> 
> On Tue, May 06, 2014 at 02:50:39PM +0200, Lukáš Czerner wrote:
> > meta_bg - Just makes group descriptors to be spread across the file
> > 	system. It has been around for some time and I am not sure
> > 	why this is not a default already. It should also increase
> > 	the limit of the file system size but I am not sure whether
> > 	this is still true with flex_bg ?
> 
> meta_bg signiicantly slows down mount operations (and in general, any
> operation where we need to read in the block group descriptors ---
> i.e., dumpe2fs, e2fsck, etc.)
> 
> The strategy for meta_bg is that it's something that we enable as we
> need it, as part of an online or off-line resize.  That way, we keep
> the block groups contiguous for as long as possible.  Once the resize
> inode has been exhausted (which _will_ happen when the file system
> size grows beyond 16T), the resize operation will turn off the
> resize_inode feature and then enable the meta_bg feature.
> 
> And this is all working today, with the latest kernel and e2fsprogs;
> so there's no reason to enable meta_bg as part of mke2fs operation,
> and a good reason not to enable it by default, but to let resize2fs
> turn it on when it makes sense to do so.
> 
>         	    		       - Ted

Perfect, thanks for explanation. I was not very sure about meta_bg
myself.

Thanks!
-Lukas
--8323328-45909237-1399390226=:2255--
