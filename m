From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Automatically allocate delay allocated	blocks
 on close
Date: Tue, 24 Feb 2009 03:13:44 -0700
Message-ID: <20090224101344.GN3199@webber.adilger.int>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu>
 <1235451952-2726-2-git-send-email-tytso@mit.edu>
 <1235451952-2726-3-git-send-email-tytso@mit.edu>
 <1235451952-2726-4-git-send-email-tytso@mit.edu>
 <1235451952-2726-5-git-send-email-tytso@mit.edu>
 <1235451952-2726-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52552 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZBXKOA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 05:14:00 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1OADu23004379
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 02:13:56 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFK00K00ETOWE00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 24 Feb 2009 02:13:56 -0800 (PST)
In-reply-to: <1235451952-2726-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 24, 2009  00:05 -0500, Theodore Ts'o wrote:
> When closing a file that had been previously truncated, force any
> delay allocated blocks that to be allocated so that if the filesystem
> is mounted with data=ordered, the data blocks will be pushed out to
> disk along with the journal commit.  Many application programs expect
> this, so we do this to avoid zero length files if the system crashes
> unexpectedly.

Should this only be done with "truncate-to-zero" operations, or any
truncate?  Some applications may do extending truncates in order to
trigger file preallocation ala Windows, and we don't necessarily want
to punish all of the IO for those files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

