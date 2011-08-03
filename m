From: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Tue, 2 Aug 2011 23:24:22 -0400
Message-ID: <CACqU3MX6c25mzkbVH+Gftmy5AOQy2KRwPH2t5BJuoE-f6fzzwg@mail.gmail.com>
References: <4E38AB50.9040804@gmail.com>
	<4E38AC92.4090501@cn.fujitsu.com>
	<4E38AFC2.3070608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45436 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1HCDYX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 23:24:23 -0400
In-Reply-To: <4E38AFC2.3070608@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, Aug 2, 2011 at 10:17 PM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> And I checked the code of kswapd, in which explicitly conversion is
> taken on the arg *. I think it should do so in journal.c too.
>
because it is done wrong somewhere is no argument to do it wrong here ...

 - Arnaud
