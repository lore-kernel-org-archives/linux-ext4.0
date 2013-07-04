From: Lukas Czerner <lczerner@redhat.com>
Subject: [RFC PATCH 0/1] ext4: Try to better reuse recently freed space
Date: Thu,  4 Jul 2013 11:11:53 +0200
Message-ID: <1372929114-12808-1-git-send-email-lczerner@redhat.com>
Cc: enwlinux@gmail.com, Jose_Mario_Gallegos@Dell.com,
	jordan_hargrave@Dell.com, rwheeler@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933532Ab3GDJMZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jul 2013 05:12:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

as I just recently discovered here http://www.ogris.de/blkalloc/ ext4 have
some unexpected allocation strategies which can cause some problems in
certain scenarios (see the 1/1 patch).

This is my attempt to fix this, however I think that this will need some
discussion because it changes some of the block allocator heuristic
quite significantly and I would like to make sure that it will not hurt
our performance in some widely used workloads. Eric, could you run your
performance testing with your test suite to see how it performs ?

Also, I think that the old behaviour might be quite helpful for SSD because
we're not overwriting existing blocks but rather trying to use new one, so
the firmware should have easier job. However I do not know how significant
impact if at all it might have. If we find out that this is helpful for
SSD we might make this conditional depending on the type of the device.

Which brings me to the other problem. Since the original behaviour is really
bad for thinly provisioned devices we would like to avoid using it even if
the underlying storage is SSD, however IIRC there is no way to distinguish
this from within the kernel.

See the comparison between the old and new allocator behaviour
http://people.redhat.com/lczerner/allocator/

Comments and testing is welcomed.

Thanks!
-Lukas
