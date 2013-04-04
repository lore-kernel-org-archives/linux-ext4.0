From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Thu, 04 Apr 2013 18:42:45 +0400
Message-ID: <87fvz6pday.fsf@openvz.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org> <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, wenqing.lz@taobao.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43904 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761899Ab3DDOmu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Apr 2013 10:42:50 -0400
Received: by mail-lb0-f171.google.com with SMTP id v10so2764002lbd.2
        for <linux-ext4@vger.kernel.org>; Thu, 04 Apr 2013 07:42:48 -0700 (PDT)
In-Reply-To: <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Today I've asked our admins about antiquarian hardware
Now I'm happy owner of:
1) Itanium2 : DualCore Processor 9020 x2 sockets, 12Gb Ram
   This one is not big-endian(at least linux does not support that) but
   it has 64k pages which allow hard core testing for 1kb fs block size :)
2) PowerMac: G5 powerpc x2 sockets, 2Gb (big endian arch)

I'll install debian on this irons this weekend. So let's hope
we next time will find issues earlier.
