From: Nathan Scott <nscott@aconex.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 07 Dec 2006 09:16:31 +1100
Message-ID: <1165443391.1281.135.camel@edge>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
	 <20061204235042.GS33919298@melbourne.sgi.com>
	 <Pine.GSO.4.53.0612051049200.27677@compserv1>
	 <20061206091100.GA33919298@melbourne.sgi.com>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.app.aconex.com ([203.89.192.138]:36763 "EHLO
	mail.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968688AbWLGDz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Dec 2006 22:55:59 -0500
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061206091100.GA33919298@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2006-12-06 at 20:11 +1100, David Chinner wrote:
> ...
> If all we need to add to XFS is support for those flags, then XFS
> support would be trivial to add.
> 
> Oh, damn. I take that back. We're almost out of flag space in the on
> disk inode - these two flags would use the last 2 flag bits so this
> may require an on disk inode format change in XFS. This will be
> a little more complex than I first thought, ...

It should be OK - you can do it without an inode version revision
if you take a second 16 bits for "di_flags2" from here...

xfs_dinode_core {
	...
        __uint8_t       di_pad[8];      /* unused, zeroed space */

Its guaranteed zeroed initially (i.e. all flags unset) and the XFS
get/set flags APIs are 32 bits, so you should be OK there.

Also, it may also be possible to reclaim di_onlink at some point (maybe
now, since 16 bits would be good here) if mkfs.xfs is changed to always
create v2 inodes (dynamic conversion ATM IIRC)... not 100% sure though,
needs more code analysis.

cheers.

-- 
Nathan
