From: Curt Wohlgemuth <curtw@google.com>
Subject: O_DIRECT and delayed allocation question
Date: Thu, 18 Jun 2009 12:53:17 -0700
Message-ID: <6601abe90906181253u657e67a7u67025774cc53bc4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:45497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZFRTxT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jun 2009 15:53:19 -0400
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out.google.com with ESMTP id n5IJrKw7001297
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 20:53:21 +0100
Received: from pxi15 (pxi15.prod.google.com [10.243.27.15])
	by spaceape13.eur.corp.google.com with ESMTP id n5IJrHRR027734
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 12:53:18 -0700
Received: by pxi15 with SMTP id 15so1257150pxi.13
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 12:53:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This might be a question with an obvious answer, but I'd like
verification one way or the other.

Does the use of O_DIRECT essentially disable delayed allocation for a
given file?

My simple tests show a larger degree of block fragmentation for files
written using O_DIRECT than without, and on its face, this makes sense
to me.  This fragmentation can be removed by using fallocate() on a
file before extending it with writes.

(Strictly speaking, I guess the use of O_DIRECT wouldn't "disable"
delayed allocation, since the blocks are allocated at the "normal"
time -- when going to disk.  But effectively there would be a lot less
block grouping available to build large extents if each write goes to
disk immediately, instead of going through the page cache.)

Thanks,
Curt
