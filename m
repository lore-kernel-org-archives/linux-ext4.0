From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ditching e4b->alloc_semp
Date: Tue, 22 Feb 2011 14:00:02 -0700
Message-ID: <6A9C4ED7-C0FF-4232-8E2D-D76855021E87@dilger.ca>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com> <6F62599D-3EC9-421C-AAD2-CFA6204A5F8C@dilger.ca> <AANLkTi=a_p6euBjPsJJUgFp8cR+6tkHx4+iGjeTWAi2G@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39940 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1BVVAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 16:00:03 -0500
In-Reply-To: <AANLkTi=a_p6euBjPsJJUgFp8cR+6tkHx4+iGjeTWAi2G@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-22, at 1:02 PM, Amir Goldstein wrote:
> On Tue, Feb 22, 2011 at 7:18 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On 2011-02-21, at 1:02 PM, Amir Goldstein wrote:
>>> After looking at the code a bit, I find that the only critical resource
>>> that several groups may share on a single page is the Uptodate flag,
>>> which is used to indicate that the buddy cache for *all* these groups
>>> is loaded and lock_page() and get_page() are used to protect it.
>>> 
>>> There are 2 ways to eliminate this dependency:
>>> 
>>> 1. (AKA easy lane) use a single page (or more) per block group.
>>> this will increase the memory usage for 1K blocks fs and for 2K block fs
>>> on 8K page system, but are these use cases really that common?
>> 
>> I think some distros may use 1kB block filesystems for root, where there are lots of small files.  I wonder if smolt would have this kind of info?
>> 
>>> 2. (AKA hard lane) attach buffer heads to buddy page and use
>>> buffer_uptodate() and buffer_lock() instead of PageUptodate() and lock_page()
>>> to initialize buddy cache of groups that share the same page.
>>> 
>>> What do you say?
>>> Shall I take easy lane?
>> 
>> For flex_bg filesystems, it would probably make even more sense to just load all of the bitmaps for that page, since it won't waste any more memory or cause extra disk seeks.  I wonder what the memory vs. seek performance tradeoff is for 1k filesystems to load all the bitmaps even for the non-flex_bg case (i.e. would the second bitmap have been loaded anyway in most cases)?
> 
> I'm sorry. I don't follow. I see how disk seeks can be avoided if we
> load all bitmaps of a flex_bg,
> but there can be no more than 2 groups on a page (4 on 8k system).
> So what do I gain? My goal  is to remove the locking protection on
> allocations from different block groups.

My point was that the locking is necessary because we may be loading multiple bitmaps into a single page at different times, making it difficult to set PageUptodate at one time.  However, with flex_bg it is possible to read both bitmap blocks into the same page at one time without noticeably hurting performance, and possibly even improving performance due to reduced disk operations.  Without flex_bg the benefit of reading all the bitmaps into a page at one time is less clear, because it would seek to read each bitmap.

Cheers, Andreas





