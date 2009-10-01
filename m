From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Where all does preallocated/extra space hide?
Date: Thu, 01 Oct 2009 11:55:47 -0500
Message-ID: <4AC4DF13.10704@redhat.com>
References: <4AC23A17.5020100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZJAQzr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Oct 2009 12:55:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n91Gtp3D014162
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 12:55:52 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n91Gtl51028653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 12:55:51 -0400
In-Reply-To: <4AC23A17.5020100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> I was running some of the xfstests enospc tests on ext4, and they were
> failing; in one case, manymanymany small files are made to fill up a
> 100M filesystem.  ext4 stops quite early with -ENOSPC, but after a bit,
> (or after a "sync") we get 40MB free again.  So 40% of the fs space is
> hidden somewhere in preallocation...
> 
> I tried calling out to discard group prealloc but that's only a few
> blocks.  I'll go trace through the sync paths to see what all gets
> released, but if anyone knows offhand where the rest of that space is
> hiding, please give me a shout.  :)
> 
> Thanks,
> -Eric

Possibly related; on a 1G filesystem, doing this:

#!/bin/bash

xfs_io -F -f -d -c 'pwrite -b 64k 0 512m' /mnt/test/io_test
rm /mnt/test/io_test

in a "while true" loop spews ENOSPC.  (it's a direct IO 512m write in 
64k chunks).  Buffered IO seems fine ...

-Eric
