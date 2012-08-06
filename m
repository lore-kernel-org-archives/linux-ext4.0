From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 6 Aug 2012 14:14:41 -0400
Message-ID: <20120806181441.26850.qmail@science.horizon.com>
References: <20120806164700.GA7896@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:52356 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756741Ab2HFSOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Aug 2012 14:14:43 -0400
In-Reply-To: <20120806164700.GA7896@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Here's a replacement patch which should work; I've tested it after
> deleting comerr-dev, e2fslibs-dev, etc., and it works, so I'm pretty
> confident I got it right this time.

Thanks!  Successful build on Ubuntu 12.04.
(No patch required on Debian/unstable.)

(Well, some problems with multiarch and not wanting to *install* without
a new libcomerr2:i386 to match the new libcomerr2:amd64, but that's
something I have to figure out.)
