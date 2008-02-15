From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH resend] ext2/3/4: convert byte order of constant
	instead of variable
Date: Thu, 14 Feb 2008 16:27:55 -0800
Message-ID: <1203035275.3637.71.camel@localhost.localdomain>
References: <20080210101010.GB6737@joi>
	 <20080214142015.f59a9e21.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54788 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693AbYBOA2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 19:28:05 -0500
In-Reply-To: <20080214142015.f59a9e21.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-14 at 14:20 -0800, Andrew Morton wrote:
> On Sun, 10 Feb 2008 11:10:15 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> >  fs/ext2/super.c |    8 +++-----
> >  fs/ext3/super.c |    2 +-
> >  fs/ext4/super.c |    2 +-
> 
> Please don't bundle the filesystem patches in this manner.  I split
> it into three patches.
> 
Andrew, Ted,

I added the ext4 patch in the ext4 patch queue.

Regards,
Mingming
