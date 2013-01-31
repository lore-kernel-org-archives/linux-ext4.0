From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
Date: Thu, 31 Jan 2013 10:10:17 +0800
Message-ID: <5109D289.1050708@huawei.com>
References: <1359502081-20240-1-git-send-email-jack@suse.cz> <20130130144535.GK4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
	<xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>,
	<ocfs2-devel@oss.oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:5007 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3AaCLT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2013 21:11:19 -0500
In-Reply-To: <20130130144535.GK4503@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/1/30 22:45, Al Viro wrote:
> On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
>>
>>   Hi,
>>
>>   since nobody seem to have picked up any of the patches (at least
>> nobody told me so), I've added acks I received to the patches and I'm
>> sending them to Al for merging. Al, can you please merge these? Thanks.
> 
> VFS part (4/4) picked; IMO at least ext* and xfs should go through the
> filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
> it as well - not sure how active their tree is these days...

I would say just grab it.

We've been sending bug fixes to ocfs2 mailing list since Aug 2012, but none
was pushed into upstream.

