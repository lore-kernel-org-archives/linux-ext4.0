From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 19:51:50 -0600
Message-ID: <68814CB7-75D6-4CCD-9E60-F4BA6A462BBC@dilger.ca>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz> <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz> <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca> <20100826003657.GN4453@thunk.org> <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca> <20100826012117.GP4453@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16506 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0HZBvw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 21:51:52 -0400
In-Reply-To: <20100826012117.GP4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-25, at 19:21, Ted Ts'o wrote:
> On Wed, Aug 25, 2010 at 06:55:49PM -0600, Andreas Dilger wrote:
>> 
>> I think you are missing the point.  I don't think it matters which
>> mke2fs is in use.  The problem is that ext3_iget() has a workaround
>> for this 5-year-old mke2fs bug that is actively causing a loss of
>> xattr data if lost+found is reallocated.
> 
> Ah, OK.  But it's still the case that the right answer at this point
> is to make ext3 code conform to ext4, and drop the workaround
> altogether.

That's exactly what the patch is doing. :-)

Cheers, Andreas





