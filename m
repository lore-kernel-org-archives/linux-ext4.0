From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ext2 reservations (Re: -mm merge plans for 2.6.23)
Date: Tue, 10 Jul 2007 21:49:23 +0400
Message-ID: <20070710174923.GA5751@martell.zuzino.mipt.ru>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:40559 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbXGJRt2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 13:49:28 -0400
Received: by ug-out-1314.google.com with SMTP id j3so1386707ugf
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 10:49:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> ext2-reservations.patch
> 
>  Still needs decent testing.

Was this oops silently fixed?
http://lkml.org/lkml/2007/3/2/138
2.6.21-rc2-mm1: EIP is at ext2_discard_reservation+0x1c/0x52

I still have that ext2 partition backed up.
