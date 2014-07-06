From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH] e2fsprogs: Add INCLUDES to BUILD_CFLAGS when cross-compiling
Date: Sat, 05 Jul 2014 21:32:40 -0300
Message-ID: <53B89928.3010206@zacarias.com.ar>
References: <1401832319-2247-1-git-send-email-gustavo@zacarias.com.ar> <20140705235542.GA19036@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:53389 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaGFAcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2014 20:32:55 -0400
In-Reply-To: <20140705235542.GA19036@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/05/2014 08:55 PM, Theodore Ts'o wrote:

> I would think that
> 
> BUILD_CFLAGS="-I$(top_builddir)/lib -DHAVE_CONFIG_H"
> 
> ... would be safer, since $INCLUDES could potentially include some
> $CPPFLAGS that could be specific to the target architecture.
> 
> Yes?

Not really, since that way it's missing config.h, still failing:

-----
cd ./util ; /usr/bin/make subst
make[2]: Entering directory
`/home/gustavoz/b/test/output/build/e2fsprogs-1.42.10/util'
        CREATE dirpaths.h
        CC subst.c
subst.c:8:20: fatal error: config.h: No such file or directory
compilation terminated.
-----

Regards.
