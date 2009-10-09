From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: update donor file's ctime/mtime
Date: Fri, 09 Oct 2009 11:20:55 -0600
Message-ID: <EE52B431-D993-47A3-B914-5FE2ACE953B8@sun.com>
References: <4ACD9D04.40503@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61027 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZJIRVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 13:21:50 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n99HL8dg005608
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 10:21:08 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KR900800BG0UT00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 09 Oct 2009 10:21:08 -0700 (PDT)
In-reply-to: <4ACD9D04.40503@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 8-Oct-09, at 02:04, Kazuya Mio wrote:

> EXT4_IOC_MOVE_EXT changes donor file data, but doesn't update ctime/ 
> mtime.
> This patch fixes this problem.

I would argue that just migrating the file data shouldn't update the  
ctime/mtime.
Those are used to determine if the file has changed in some way,  
usually for the
purpose of backup.  Migrating the data does not change anything from  
the user-space
POV and shouldn't force a new backup of the file.
