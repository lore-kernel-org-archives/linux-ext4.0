From: Andreas Dilger <adilger@sun.com>
Subject: Re: patches in queue but missing from series?
Date: Sun, 14 Sep 2008 23:32:56 -0700
Message-ID: <20080915063256.GK4090@webber.adilger.int>
References: <48CD7DEC.6080008@redhat.com> <20080914213448.GB8706@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55928 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYIOGdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 02:33:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8F6X3Xu014946
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 23:33:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7800K014SNID00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 14 Sep 2008 23:33:03 -0700 (PDT)
In-reply-to: <20080914213448.GB8706@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 14, 2008  17:34 -0400, Theodore Ts'o wrote:
> Girish's Fix-EXT_MAX_BLOCK.patch caused regression failures, so it was
> dropped from the patch series.  I don't think anyone ever went back to
> figure out why it was causing the ext4 tree to blow up.

I think we have an updated version of this patch.  Girish?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

