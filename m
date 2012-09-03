From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and
 64bits features
Date: Mon, 3 Sep 2012 12:45:25 -0400
Message-ID: <20120903164525.GD5066@thunk.org>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
 <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48624 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab2ICQp1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 12:45:27 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 02, 2012 at 06:31:19PM +0800, Yongqiang Yang wrote:
> Hi Ted,
> 
>     I noticed that you send out the patch enabling resizing on
> filesystems with meta_bg and 64bits, so I send out the corresponding
> patch on e2fsprogs.  Unfortunately, there is still a bug in e2fsprogs
> as my last email says.

The following two patches were sufficient for me to resize a test file
system from 14 TB to 18 TB.  We still need to handle automatic
enabling of the meta_bg flag in resize2fs, but this should be
sufficient for more adventurous folks to test the online resize
patches.  (Note that I also posted a v2 version of patch 5/5 which
fixed a number of 64-bit overflow bugs that I found in my testing.)

      	       	  	 	       	      - Ted
