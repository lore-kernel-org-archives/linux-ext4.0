From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Why the third parameter of "ext4_ext_put_in_cache" is __u32?
Date: Thu, 26 Jul 2007 22:54:41 +0800
Message-ID: <3d0408630707260754w71df514bh719a6e40cc6e2fdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:45941 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbXGZOym (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2007 10:54:42 -0400
Received: by mu-out-0910.google.com with SMTP id i10so804937mue
        for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2007 07:54:41 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all

  The third parameter of "ext4_ext_put_in_cache" is used to receive
physical block number. I think the data type should be "ext4_fsblk_t".

Thanks in advance.

YZ
