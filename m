From: Michael Rubin <mrubin@google.com>
Subject: Re: EXT3 way too happy with write errors
Date: Thu, 18 Dec 2008 10:29:09 -0800
Message-ID: <532480950812181029k1baf8264y82fb6d9760fe05f8@mail.gmail.com>
References: <20081015002256.GD25662@hostway.ca>
	 <20081218170714.GA6797@atrey.karlin.mff.cuni.cz>
	 <20081218171825.GD20515@hostway.ca>
	 <20081218172759.GE13580@duck.suse.cz>
	 <20081218174921.GF20515@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Mike Snitzer <snitzer@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Simon Kirby <sim@netnation.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:37207 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLRS3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:29:13 -0500
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id mBIITC3L023773
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:12 -0800
Received: from el-out-1112.google.com (elem34.prod.google.com [10.126.164.34])
	by zps38.corp.google.com with ESMTP id mBIIT99F004439
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:10 -0800
Received: by el-out-1112.google.com with SMTP id m34so132260ele.25
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:09 -0800 (PST)
In-Reply-To: <20081218174921.GF20515@hostway.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 18, 2008 at 9:49 AM, Simon Kirby <sim@netnation.com> wrote:
> Not aborting on data write error: User loses data.  File system gets very
> confused.
>
> What am I missing?

I can think of certain situations when companies may care about
getting most of the data to disk and clean it up later.
Datacenters may be replicating the data to many spindles and may
sometimes care about throughput as much as possible. So lossy data
could be preferred to complete data.

Not saying this is always preferred but I can see a use case.

mrubin
