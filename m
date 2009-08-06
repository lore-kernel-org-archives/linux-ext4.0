From: Andreas Dilger <adilger@sun.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 06 Aug 2009 14:50:02 -0600
Message-ID: <20090806205002.GH3340@webber.adilger.int>
References: <28623.1249307676@gamaville.dokosmarshall.org>
 <20090806200400.GC1800@shell> <18249.1249591034@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33162 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZHFUut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 16:50:49 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n76Kom2T001217
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 13:50:48 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNZ00900326NF00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 06 Aug 2009 13:50:48 -0700 (PDT)
In-reply-to: <18249.1249591034@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 06, 2009  16:37 -0400, Nick Dokos wrote:
> I did that to begin with but the problem turns out to be much more
> mundane: there was an IO error on one of the volumes. It wasn't quite
> obvious (no red lights going off) but there *was* a message in
> /var/log/messages - unfortunately I missed it. I eventually recreated
> the error by trying to read the file with ``od -c'' and then went back
> and found the original error. I don't know why/how ll_ver_fs managed to
> read the offset and come up with a 1M difference[1] -- ``od -c'' failed with
> a big thud.

Can you have a look at the error handling in ll_ver_fs at that point?
It seems that it might just have re-used the previous 1MB buffer, but
didn't detect/report the error from the read, which would itself be bad.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

