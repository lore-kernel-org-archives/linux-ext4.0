From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Thu, 21 Jun 2007 01:06:48 +0530
Message-ID: <1182368214.3969.7.camel@garfield>
References: <1182331988.9772.7.camel@garfield>
	 <20070620150902.GA15561@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39725 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXFTThn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 15:37:43 -0400
In-Reply-To: <20070620150902.GA15561@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-06-20 at 11:09 -0400, Theodore Tso wrote:
> Hi Kalpak, 
> 
> 	In the future it would be really helpful if you split up your
> patches so that each different thing is done in separate patches.

Sure. Do you want me to split this patch too and resend?

> 
> 	Also, note there is a recent bug fix in this area, and the
> byte-swapping extended attributes.  The issues involved here are
> subtle; please see the discussion here:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=232663
> 
> So before your patches go in, we need to do a careful audit to make
> sure they don't interact properly with this patch which is already in
> e2fsprogs mainline.

This fix is already in our tree. We periodically keep syncing our tree
with the mainline changes. So I have tested my changes with this patch
present. 

Actually I had created test images for the expand-extra-isize patches
which failed on big-endian machines which brought these bugs to my
notice.

Thanks,
Kalpak.
