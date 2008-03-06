From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Thu, 06 Mar 2008 11:23:47 -0600
Message-ID: <1204824227.7964.4.camel@norville.austin.ibm.com>
References: <n7xejaoynp9.fsf@sor.suse.de>
	 <1204813967.8679.28.camel@norville.austin.ibm.com>
	 <n7xzltbwzq3.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33531 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbYCFRXy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 12:23:54 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m26HNnOo019024
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 12:23:49 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m26HNnUQ226628
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 12:23:49 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m26HNmTa014797
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 12:23:49 -0500
In-Reply-To: <n7xzltbwzq3.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-06 at 18:04 +0100, Matthias Koenig wrote:
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> > Should field 8 of /etc/fstab (fs_passno) be zero for these mount points?
> > Is there any reason for it to be anything different?
> 
> Why? zero would mean that they should never get checked.
> I think it is reasonable to have the choice to get your crypto
> filesystems checked. Current practise for SuSE has been to allow
> only 0, but checked this filesystem anyway, which has lead to complaints.
> So we want to do this more consistent.

Zero tells fsck not to check the filesystem during reboot.  It's what
tells fsck -A which filesystems to check.  If we don't expect the
filesystem to be check-able during that phase, a non-zero value won't
have any real meaning.
-- 
David Kleikamp
IBM Linux Technology Center

