From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] Ext4: remove a useless check for the function ext4_data_block_valid
Date: Sun, 27 Jan 2013 16:46:29 -0800
Message-ID: <5105CA65.7020504@gmail.com>
References: <51045F77.5000106@gmail.com> <20130126153826.GB5887@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:34926 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3A0Inz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2013 03:43:55 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so793940dak.6
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 00:43:54 -0800 (PST)
In-Reply-To: <20130126153826.GB5887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sat, Jan 26, 2013 at 02:57:59PM -0800, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> Because it is no doubt 'start_blk + count < start_blk' always comes to
>> false. It is useless to have this check,remove it.
> Actually, it can be true --- if start_blk + count (which are both
> unsigned integers) overflows....
    Yeah,you are right....
    I am sorry,I miss the overflow condition...
> 					- Ted
>

