From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What is fragment in ext3/4 ?
Date: Fri, 03 Aug 2007 11:05:52 -0500
Message-ID: <46B35260.9000900@redhat.com>
References: <46B1A9F9.3050901@gmail.com> <20070803000228.GO6142@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Coly Li <colyli@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210AbXHCQGG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2007 12:06:06 -0400
In-Reply-To: <20070803000228.GO6142@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Aug 02, 2007  17:55 +0800, Coly Li wrote:
>> These days, when I read the source code of mke2fs, I found an option -f
>> to set the fragment size.
>>
>> But I can not find any explaining for ext3/4 framgment from google,
>> excepting someone saying ext2/3 does not support this feature.
>>
>> Can anyone tell me what is the function or purpose of fragment of ext
>> file system ?
> 
> This is an obsolete concept from BSD that was never used by ext[234].
> Consider a "fragment" in this context to be the same as a "tail" for
> reiserfs.  A very small file, or the end of a file that is less than
> a block.

There's a fair amount of code around this never-implemented concept;
should it be removed?  :)

-Eric
