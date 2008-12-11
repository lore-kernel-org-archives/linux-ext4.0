From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 01/18] jbd2: Add buffer triggers
Date: Thu, 11 Dec 2008 12:57:47 -0700
Message-ID: <20081211195747.GC3178@webber.adilger.int>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
 <1228871395-10273-2-git-send-email-joel.becker@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: mfasheh@suse.com, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Joel Becker <joel.becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50361 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbYLKT6A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Dec 2008 14:58:00 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBBJvxdQ001676
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2008 11:57:59 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KBQ00K019R0ZF00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 11 Dec 2008 11:57:59 -0800 (PST)
In-reply-to: <1228871395-10273-2-git-send-email-joel.becker@oracle.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 09, 2008  17:09 -0800, Joel Becker wrote:
> This adds triggers to jbd2 buffer heads.  Just before writing a metadata
> buffer to the journal, jbd2 will optionally call a commit trigger associated
> with the buffer.  If the journal is aborted, an abort trigger will be
> called on any dirty buffers as they are dropped from pending
> transactions.

It would be a useful exercise to see if changing the group descriptor
checksum to use this mechanism.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

