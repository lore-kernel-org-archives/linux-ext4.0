From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: Why the third parameter of "ext4_ext_put_in_cache" is __u32?
Date: Thu, 26 Jul 2007 22:57:59 +0800
Message-ID: <3d0408630707260757w2bd53a2ey6ed1c11f06cd35be@mail.gmail.com>
References: <3d0408630707260754w71df514bh719a6e40cc6e2fdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:42710 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbXGZO6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2007 10:58:01 -0400
Received: by ug-out-1314.google.com with SMTP id j3so545646ugf
        for <linux-ext4@vger.kernel.org>; Thu, 26 Jul 2007 07:58:00 -0700 (PDT)
In-Reply-To: <3d0408630707260754w71df514bh719a6e40cc6e2fdb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sorry, I mean the fourth parameter of "ext4_ext_put_in_cache.


2007/7/26, Yan Zheng <yanzheng@21cn.com>:
> Hi all
>
>   The third parameter of "ext4_ext_put_in_cache" is used to receive
> physical block number. I think the data type should be "ext4_fsblk_t".
>
> Thanks in advance.
>
> YZ
>
