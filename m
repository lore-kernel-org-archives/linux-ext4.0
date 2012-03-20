From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 02:46:43 -0700
Message-ID: <1332236803.7847.85.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
	 <4F684673.1050309@suse.cz> <1332235315.7847.63.camel@joe2Laptop>
	 <4F684D00.4040102@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:58186 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab2CTJqo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2012 05:46:44 -0400
In-Reply-To: <4F684D00.4040102@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2012-03-20 at 10:25 +0100, Jiri Slaby wrote:
> On 03/20/2012 10:21 AM, Joe Perches wrote:
> > the ath5k pr_ conversion patches are to
> > standardize prefixes and to reduce code size by
> > centralizing tests.
> 
> What is the "standard" prefix?

KBUILD_MODNAME

> > https://lkml.org/lkml/2012/3/18/121
> > https://lkml.org/lkml/2012/3/18/123
> > https://lkml.org/lkml/2012/3/18/124
> > I happen to like 30K/10+% code size reductions.
> Obvious question: what speed reduction does this bring?

Anyone looking for speed impacts in logging
messages is looking in the wrong place.

btw: it's effectively 0.


