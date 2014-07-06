From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH] fix cross-compilation support
Date: Sat, 05 Jul 2014 21:45:12 -0300
Message-ID: <53B89C18.6080205@zacarias.com.ar>
References: <1404607112-26902-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:53500 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGFAp0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2014 20:45:26 -0400
In-Reply-To: <1404607112-26902-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/05/2014 09:38 PM, Theodore Ts'o wrote:

> Commit 2500ebfc89 (util: fix make dependencies for subst) broke cross
> compilation because it unconditionally used config.h without setting a
> includes path so that the config.h file could be found.
> 
> The proposed fix of adding the include path (such as was proposed at
> http://patchwork.ozlabs.org/patch/355662/ or in Debian Bug #753375)
> aren't really the right fix, since the information in config.h is for
> the target environment, and not the build environment.  So using
> config.h when building helper programs used as part of the build can
> potentially cause more problems than it solves.
> 
> In general, build helpers must be written to be as portable as
> possible, and to not require any autoconf defined #ifdef's whenever
> possible.  The subst program broke this rule to (1) address a Coverity
> security complaint by using futimes if is present, and (2) to preserve
> the nanosecond portion of the file timestamp.
> 
> Oh, well.  We won't be able to do the latter when cross compiling, and
> as to the former, if an attacker has write access to your build tree
> while you are building programs that will be run as root, you've got
> bigger problems.  :-)
> 
> Fix the problem that commit 2500ebfc89 was trying to address by
> explicitly adding @DEFS@ to CFLAGS, so that -DHAVE_CONFIG_H is passed
> to make depend.  This fixes up the make depend without forcing the use
> of config.h when cross-compiling.
> 
> Addresses-Debian-Bug: #753375
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Helmut Grohne <helmut@subdivi.de>
> Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
> Cc: 753375@bugs.debian.org

Tested-by: Gustavo Zacarias <gustavo@zacarias.com.ar>

Indeed cleaner than my solution, thanks.
Regards.

