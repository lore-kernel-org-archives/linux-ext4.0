From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 10:25:20 +0100
Message-ID: <4F684D00.4040102@suse.cz>
References: <cover.1331856299.git.joe@perches.com>  <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>  <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>  <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>  <4F684673.1050309@suse.cz> <1332235315.7847.63.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48946 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2CTJZY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 05:25:24 -0400
In-Reply-To: <1332235315.7847.63.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/20/2012 10:21 AM, Joe Perches wrote:
> On Tue, 2012-03-20 at 09:57 +0100, Jiri Slaby wrote:
>> And BTW setting the argument that it is a newer interface (that is what
>> ath5k pr_* conversion patches commit log says) is not a good
>> justification at all.
> 
> No again, the ath5k pr_ conversion patches are to
> standardize prefixes and to reduce code size by
> centralizing tests.

What is the "standard" prefix?

> https://lkml.org/lkml/2012/3/18/121
> https://lkml.org/lkml/2012/3/18/123
> https://lkml.org/lkml/2012/3/18/124
> 
> I happen to like 30K/10+% code size reductions.

Obvious question: what speed reduction does this bring?

thanks,
-- 
js
suse labs
