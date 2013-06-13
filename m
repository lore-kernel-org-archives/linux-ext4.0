From: "jon ernst" <jonernst07@gmx.com>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Wed, 12 Jun 2013 23:53:28 -0400
Message-ID: <20130613035328.9230@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:62594 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab3FMDxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 23:53:34 -0400
Received: from mailout-us.gmx.com ([172.19.198.48]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0LpKrZ-1UAMet3Mgf-00f8AF for
 <linux-ext4@vger.kernel.org>; Thu, 13 Jun 2013 05:53:30 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>For your convenience, you might want to take a look at:

 >git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

>This will build all of the tools you need for xfstests, in a hermetic
>build environment, and create a tarball that has everything you need
>to run xfstests. There are also some convenience scripts which allow
>you to easily kick off an xfstests run using qemu.
Thank you! 
I found a small issue in README of xfstest-bld.
"make tarball" won't work unlesee do "make" once.
"make" pulls several repo's source code.
Then "make tarball" works.



> - Ted
