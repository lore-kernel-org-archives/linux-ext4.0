From: Alex Tomas <alex@clusterfs.com>
Subject: Re: 2.6.21-ext4-1
Date: Mon, 30 Apr 2007 20:24:47 +0400
Message-ID: <4636184F.3030206@clusterfs.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:61583 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946362AbXD3QZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 12:25:05 -0400
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> P.S.  One bug which I've noted --- if there is a failure due to disk
> filling up, running e2fsck on the filesystem will show that the i_blocks
> fields on the inodes where there was a failure to allocate disk blocks
> are left incorrect.  I'm guessing this is a bug in the delayed
> allocation patches.  Alex, when you have a moment, could you take a
> look?  Thanks!!

definitely. thanks for the report.

thanks, Alex
