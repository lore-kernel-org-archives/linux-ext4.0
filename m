From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 02:44:36 -0700
Message-ID: <1332236676.7847.83.camel@joe2Laptop>
References: <20120320025835.GE14363@thunk.org>
	 <1332212574.7847.49.camel@joe2Laptop>
	 <216818.1332222366@turing-police.cc.vt.edu>
	 <20120320.031001.1532841232287663716.davem@davemloft.net>
	 <4F684407.1040807@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Valdis.Kletnieks@vt.edu, tytso@mit.edu, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:58662 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753671Ab2CTJoh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2012 05:44:37 -0400
In-Reply-To: <4F684407.1040807@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2012-03-20 at 09:47 +0100, Jiri Slaby wrote:
> Joe writes: "notify a particular set of per subsystem messages that
> pr_<level> could easily provide"
> 
> Maybe the concept is not explained well enough that we do not follow?

Basically, when pr_fmt(fmt) is #defined to something
other than "#define pr_fmt(fmt) fmt", it could be used
as a mechanism to do more than standardize prefixes.

__builtin_strcmp is pretty useful.

You can do things like:
(I'm just typing, this may have errors)

#define _first_macro_arg(arg1) arg1
#define first_macro_arg(arg1, ...) _first_macro_arg(arg1)

#define pr_info(fmt, ...)					\
do {								\
	if (!__builtin_strcmp(first_macro_arg(pr_fmt(fmt)),	\
			      KBUILD_MODNAME ": " fmt)))	\
		advanced_printk(fmt, ##__VA_ARGS__);		\
	else							\
		printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__);	\
while (0)

etc...

Anyway, it's been a couple of years since I prototyped
something like that and tested file sizes.

The size delta of an allyesconfig was:

-rwxr-xr-x 1 joe joe 926968471 2010-06-29 10:39 vmlinux.allyesconfig.printk_level_with_module
-rwxr-xr-x 1 joe joe 927196127 2010-06-23 02:40 vmlinux.allyesconfig.pr_level

It reduced an allyesconfig by .1%
It wasn't a huge saving.

I'll play with it again and send an rfc
patch in a couple of days.

Maybe I'll prototype a pr_notify mechanism too.

cheers, Joe

