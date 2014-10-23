From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/6] RFC: (partially) endian-annotate e2fsprogs
Date: Thu, 23 Oct 2014 16:26:46 -0500
Message-ID: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaJWV0t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:26:49 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLQnFF027917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:26:49 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLQkFJ005735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:26:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is really only partial, and in the end didn't spot any
actual problems.  And things are a bit odd and tricky, because
some structures (superblocks, inodes, etc) are swapped in-place
in the same structure (so they can't be easily annotated - 
if we wish to, we should define separate on-disk and in-memory
structures).

Further, i_block in the inode is sometimes swapped on read, and
sometimes not (!), depending on whether it's indirect blocks,
extents, or inline data.  So that's still messy too.

So this is really just kind of an RFC; I did it on a whim, and
things aren't yet totally sparse-check clean, but figured I'd send
it out and see what people think, whether it's worth merging,
or working on cleaning up the above issues to make it all tidier.

(sparse is pretty good at looking for casts in and out of blk64_t
too, though I haven't looked much at those.)

Thanks,
-Eric
