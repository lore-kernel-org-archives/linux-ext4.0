From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster size
Date: Fri, 20 Dec 2013 12:58:47 +0800
Message-ID: <CAGBYx2ay84YFV35g9B7wL0GLN-K_KLLXWp7mBjvF9LBgURfZHA@mail.gmail.com>
References: <1387435099-11163-1-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2a1w+REq6634mOpSZhWWSVuYMuXy48LhAJq7q4kB5Wdew@mail.gmail.com> <20131220042246.GA23508@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <yangyongqiang01@baidu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63813 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LTE7J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2013 23:59:09 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so815692ead.38
        for <linux-ext4@vger.kernel.org>; Thu, 19 Dec 2013 20:59:07 -0800 (PST)
In-Reply-To: <20131220042246.GA23508@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 12:22 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 19, 2013 at 02:40:42PM +0800, Yongqiang Yang wrote:
>> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.
>
> Hi Yongqiang,
>
> I can't find the original message you were replying.  I can
> reconstruct the 2/2 patch, but is there a 1/2 patch that you had meant
> to send to the linux-ext4 list?
Interesting, I sent the patch to ext4 list and you. I will resend them.

Thanks,
Yongqiang.
>
> Many thanks,
>
>                                         - Ted



-- 
Best Wishes
Yongqiang Yang
