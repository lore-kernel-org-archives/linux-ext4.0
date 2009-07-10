From: Curt Wohlgemuth <curtw@google.com>
Subject: Question on huge_file
Date: Fri, 10 Jul 2009 08:32:12 -0700
Message-ID: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:13898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZGJPcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 11:32:17 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n6AFWE6X005397
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 16:32:15 +0100
Received: from pxi14 (pxi14.prod.google.com [10.243.27.14])
	by zps77.corp.google.com with ESMTP id n6AFWClg019591
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 08:32:12 -0700
Received: by pxi14 with SMTP id 14so666790pxi.10
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 08:32:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I apologize if this is a dumb question, but I'm having trouble
understanding the huge_file superblock flag.

I see how, if this flag is set, that the inode can have a size > 2**32
bytes, using the i_size_lo/i_size_high fields.

But since an ext4_extent only uses 32-bits for for its ee_block field
to represent the logical block, how can an extent describe any block
range of a file past the 4GiB boundary?

Am I missing something?

Thanks,
Curt
