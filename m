From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 13930] New: non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 07 Aug 2009 12:58:53 -0600
Message-ID: <20090807185853.GK3340@webber.adilger.int>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: zelogik+bugzilla@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59043 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871AbZHGS7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 14:59:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n77Ix4WH012017
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 11:59:04 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KO000300SNOWR00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 07 Aug 2009 11:59:04 -0700 (PDT)
In-reply-to: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 07, 2009  09:58 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> Normally ext4 is a perfect non-contifuous FS ... so why when I make an:
> 
> sudo e2fsck -v -f -p /dev/sdc1
> 
>    15953 inodes used (0.03%)
>    10361 non-contiguous files (64.9%)
> 
> We have 64.9% of non-contiguous files on a ext4 fs, 
> 
> Files have been transfered from a cifs mount (useful ?) and files size are
> [2-10]|[600-800]MB

Note that the largest single extent in ext4 is 128MB, so it is perfectly
normal to have fragmented files if they are 600MB in size.  Maybe we should
change the e2fsck stats to not consider a file fragmented if it fills the
whole block group (less any metadata therein)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

