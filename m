From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: xfstests: test ext4 statfs
Date: Mon, 29 Oct 2012 09:12:26 -0500
Message-ID: <508E8ECA.2080204@sgi.com>
References: <5089749C.4050003@redhat.com> <508AD066.4090102@sgi.com> <508AD8E8.1040301@redhat.com> <508E8480.5020507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: <xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:48136 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040Ab2J2OKs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 10:10:48 -0400
In-Reply-To: <508E8480.5020507@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

   xfstests: test ext4 statfs

     Calculating free blocks in ext[234] is surprisingly hard, since
     by default we report "bsd" style df which doesn't count filesystem
     "overhead" blocks as used.

     With a lot of code dedicated to sorting out what to report as
     free, things tend to go wrong surprisingly often.

     Here's a test to actually try to stop the next regression.  ;)

     NB: For bsddf, the kernel currently does not count journal blocks
     as overhead; it probably should.  But the test below looks to have
     the result within 1% of perfection, so it still passes even if
     the kernel doesn't count the journal against free blocks.

Eric,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit 0b2ab695.

Thanks
--Rich



