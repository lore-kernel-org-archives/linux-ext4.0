From: Curt Wohlgemuth <curtw@google.com>
Subject: Use of kmalloc vs vmalloc in ext4?
Date: Wed, 11 Mar 2009 07:32:14 -0700
Message-ID: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:48255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZCKOcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 10:32:18 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id n2BEWGEF003070
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 07:32:16 -0700
Received: from wf-out-1314.google.com (wfd27.prod.google.com [10.142.4.27])
	by wpaz5.hot.corp.google.com with ESMTP id n2BEVnZo030742
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 07:32:15 -0700
Received: by wf-out-1314.google.com with SMTP id 27so31109wfd.15
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 07:32:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been running various tests of ext4 partitions lately, and have
found that with very low memory situations, I'm getting intermittent
mount failures due to ENOMEM from ext4_mb_init() and
ext4_fill_flex_info() .  Here's a typical dmesg from the latter:

          EXT4-fs: not enough memory for 8198 flex groups
          EXT4-fs: unable to initialize flex_bg meta info!

This is from a kzalloc() call of size ~64k .  I think the
ext4_mb_init() calls to kmalloc() and alloc_percpu() are even smaller.

I was wondering why all the code in ext4 (and ext[23], for that
matter) uses kmalloc() and friends instead of vmalloc(), at least
where it's safe; is it just for performance reasons?

I've seen the above errors when I do a mount -a, causing several
partitions to be mounted; I can usually mount the failed ones by hand
right afterwards, but this is a big difference for us, in our
environment, compared to, say, ext2 partitions.

Thanks,
Curt
