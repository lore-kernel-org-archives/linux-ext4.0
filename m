From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: E2fsprogs 1.40 release imminent!
Date: Mon, 25 Jun 2007 01:11:01 +0200
Message-ID: <20070624231101.GF23175@xi.wantstofly.org>
References: <E1I2aKE-0008RV-KP@tinytim.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, fedora-arm@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alephnull.demon.nl ([83.160.184.112]:35510 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXXdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jun 2007 19:33:06 -0400
Content-Disposition: inline
In-Reply-To: <E1I2aKE-0008RV-KP@tinytim.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jun 24, 2007 at 06:12:54PM -0400, Theodore Ts'o wrote:

> The hg repository located at:
> 
> 	http://thunk.org/hg/e2fsprogs
> 
> ... contains what I hope to be the e2fsprogs 1.40 release.  If folks
> could test it and let me know if they find any embarassing bugs, I would
> greatly appreciate it.  It can also be found at:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.40-rc1.tar.gz

The release at the URL above seems to solve the issues I've been
seeing on ARM (in particular, it seems to fix the strict aliasing
issue that was causing dumpe2fs to segfault.)

Thanks!
