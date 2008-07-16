From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] Add more intelligent handling of the mke2fs.conf
	installation process
Date: Wed, 16 Jul 2008 15:29:49 -0600
Message-ID: <20080716212949.GV6239@webber.adilger.int>
References: <E1KITeX-0001PV-Pv@closure.thunk.org> <487BAA6B.7030001@redhat.com>
 <20080714195526.GA3382@mit.edu> <1216172323.8292.23.camel@mingming-laptop>
 <20080716023532.GO8185@mit.edu> <1216227720.6424.7.camel@mingming-laptop>
 <20080716175257.GF2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57966 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYGPV3x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 17:29:53 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6GLTrLV000964
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:29:53 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4400301BA1HT00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 16 Jul 2008 14:29:52 -0700 (PDT)
In-reply-to: <20080716175257.GF2167@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 16, 2008  13:52 -0400, Theodore Ts'o wrote:
> So if /etc/mk2fs.conf exists, but does not mention ext4dev, we will
> move it aside to /etc/mke2fs.conf.e2fsprogs-old and then install the
> new mke2fs.conf.  If the /etc/mke2fs.conf file exists but does mention
> ext4dev, we install the new mke2fs.conf file as
> /etc/mke2fs.conf.e2fsprogs-new.  In both we print warning to the user
> so they can manually make any changes as needed.

What about just adding the ext4/ext4dev stanzas into the existing file?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

