From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Fri, 16 Nov 2007 10:12:14 -0800
Message-ID: <OF6546148C.B252F592-ON88257395.006383BB-88257395.0063FFA9@us.ibm.com>
References: <20071116031716.GJ13834@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45817 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbXKPSMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2007 13:12:51 -0500
In-Reply-To: <20071116031716.GJ13834@lazybastard.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>fsync() will sync an inode even if only i_atime was changed.
>fdatasync() would ignore such changes.  I guess atime was the major
>reason for creating fdatasync() in the first place.

I think it was mtime.  One doesn't normally call any kind of sync when one 
is just reading the file.  But keeping an accurate mtime is often not 
worth the I/O.

And theoretically, there could be all kinds of "truly meta" metadata that 
changes as you write to the file but would probably be considered more 
expendable than the file's actual data.

But I think it was always intended that fdatasync() would sync the data in 
a meaningful way -- i.e. such that the data can be retrieved after a 
system failure; it surely wasn't meant for the user to understand 
filesystem internals.  I've heard the term "data-related metadata" to 
distinguish such things as allocation maps and pointer blocks from mtime, 
permissions, etc.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems
