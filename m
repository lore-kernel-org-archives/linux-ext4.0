From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Thu, 13 Dec 2007 15:58:57 -0700
Message-ID: <20071213225857.GK3214@webber.adilger.int>
References: <20071206161045.1054bbe7@gara> <20071207101428.GE3214@webber.adilger.int> <20071207095212.037ca68a@gara> <20071211110033.GQ3214@webber.adilger.int> <20071211100812.557b923b@gara> <20071211231528.GS3214@webber.adilger.int> <20071213095112.100b3d9e@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:35441 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763905AbXLMW67 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2007 17:58:59 -0500
Content-Disposition: inline
In-Reply-To: <20071213095112.100b3d9e@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 13, 2007  09:51 -0600, Jose R. Santos wrote:
> Now, storing the bits only guaranties that the flexbg size is always a
> power-of-two and does not guarantee that the super block flexbg size
> represents the actual meta-data grouping on disk.  For this we need to
> verify that the bitmap offsets match what the super block reports.  It
> may be an unlikely scenario, but it may be worth it to check this as
> well at mount time.

I'm not sure what you mean...  Isn't the flexbg size just a count of
the number of block groups?  If it is always a power of two, and the
groups per metabg is always a power of two (it is) then they will
always be even multiples.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
