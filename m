From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 02:21:55 -0700
Message-ID: <1332235315.7847.63.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
	 <4F684673.1050309@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43631 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752633Ab2CTJV4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2012 05:21:56 -0400
In-Reply-To: <4F684673.1050309@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2012-03-20 at 09:57 +0100, Jiri Slaby wrote:
> On 03/19/2012 06:09 PM, Joe Perches wrote:
> > As far as I can tell, your "reasons" as you
> > explained it is that you just do not like
> > whitespace or style changes.
> No, sorry, you misunderstand me.

No, sorry, you were simply unclear in your reference.

> And BTW setting the argument that it is a newer interface (that is what
> ath5k pr_* conversion patches commit log says) is not a good
> justification at all.

No again, the ath5k pr_ conversion patches are to
standardize prefixes and to reduce code size by
centralizing tests.

https://lkml.org/lkml/2012/3/18/121
https://lkml.org/lkml/2012/3/18/123
https://lkml.org/lkml/2012/3/18/124

I happen to like 30K/10+% code size reductions.

