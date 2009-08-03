From: Andreas Dilger <adilger@sun.com>
Subject: Re: Help to read journal content
Date: Mon, 03 Aug 2009 13:54:44 -0600
Message-ID: <20090803195444.GH5432@webber.adilger.int>
References: <20aa8c370908030417he494294i890e804e6a552488@mail.gmail.com>
 <20aa8c370908030446n59325e14j41e4cc72d86a9bae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: ranjith kannikara <ranjithkannikara@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65310 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZHCTzC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 15:55:02 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n73JsoT7005135
	for <linux-ext4@vger.kernel.org>; Mon, 3 Aug 2009 12:55:02 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNT00M00G7P5L00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 03 Aug 2009 12:54:50 -0700 (PDT)
In-reply-to: <20aa8c370908030446n59325e14j41e4cc72d86a9bae@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 03, 2009  17:16 +0530, ranjith kannikara wrote:
> We are doing a project to make an applicatio that can recover the
> deleted data from an ext3 filesystem
> <http://sourceforge.net/projects/recoverext3/>. We ahve used the tools
> foremost and debugfs to debug the filesystem and read the journal.
> Is there any way to read the journal?
> Or How can we read the journal of a filesystem.
> The inode number of the journal is present in the ext3_super_block
> structure. But We are able to open the inode only with the help of
> these tools.
> Can someone guide us to where tio find the details of how a journal
> can be read.

Why create a new tool?  There is ext3grep which already does a lot of
this work, and it would be much better to spend your time to improve
that tool instead of spending time developing a new tool that doesn't
do anything better than any existing one.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

