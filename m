From: Gordon Messmer <gordon.messmer@gmail.com>
Subject: Re: kernel panic using external journal and snapshots
Date: Sat, 23 Nov 2013 12:30:48 -0800
Message-ID: <52911078.40207@gmail.com>
References: <5281A8A3.80604@gmail.com> <20131122071145.GA5936@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:44683 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab3KWUb4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Nov 2013 15:31:56 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so3146171pbb.37
        for <linux-ext4@vger.kernel.org>; Sat, 23 Nov 2013 12:31:56 -0800 (PST)
Received: from ascension.private.dragonsdawn.net (50-199-12-33-static.hfc.comcastbusiness.net. [50.199.12.33])
        by mx.google.com with ESMTPSA id at4sm62112974pbc.30.2013.11.23.12.31.54
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.1 cipher=RC4-SHA bits=128/128);
        Sat, 23 Nov 2013 12:31:55 -0800 (PST)
In-Reply-To: <20131122071145.GA5936@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/21/2013 11:11 PM, Zheng Liu wrote:
> For the first question, I haven't a LVM device on my hand.  Hence I am
> not sure whether there is a bug or not.
>
> For the second one, I do a test on my sand box against Linux-3.12-rc5,
> and it works well.  So I think maybe you can try it again on a newer
> kernel.

The problem manifests when a filesystem which uses external journal and 
its snapshot are simultaneously mounted.  If you don't have an LVM 
device with which to create a snapshot, I'm not sure what you're 
testing.  Could you clarify?
