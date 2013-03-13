From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e4defrag: defrag a file when orig_physical_cnt ==
 donor_physical_cnt
Date: Wed, 13 Mar 2013 15:54:22 -0400
Message-ID: <20130313195422.GG5604@thunk.org>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
 <1362327978-30423-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53209 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab3CMTy0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 15:54:26 -0400
Content-Disposition: inline
In-Reply-To: <1362327978-30423-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 04, 2013 at 12:26:17AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When orig_physical_cnt == donor_physical_cnt, we need to defrag a file
> because a file could be written backwards.  So that will make it look
> like a contiguous extent but actually the physical blocks are reversed.

The problem with your change is in the case where orig_physical_cnt
and donor_physical_cnt are 1 (i.e., the file is perfectly defragged),
we will still try to swap the extents.

The fundamental problem is that we are using a metric which is flawed;
in the case of the following file:

> File size of /mnt/sda3/testfile is 40960 (10 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..       0:      34825..     34825:      1:
>    1:        1..       1:      34824..     34824:      1:      34826:
>    2:        2..       2:      34823..     34823:      1:      34825:
>    3:        3..       3:      34822..     34822:      1:      34824:
>    4:        4..       4:      34821..     34821:      1:      34823:
>    5:        5..       5:      34820..     34820:      1:      34822:
>    6:        6..       6:      34819..     34819:      1:      34821:
>    7:        7..       7:      34818..     34818:      1:      34820:
>    8:        8..       8:      34817..     34817:      1:      34819:
>    9:        9..       9:      34816..     34816:      1:      34818: eof

We should be counting this as having 10 extents, not 1.

   	     	      	      	     		     - Ted
