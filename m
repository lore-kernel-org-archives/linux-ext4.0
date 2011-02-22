From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ditching e4b->alloc_semp
Date: Tue, 22 Feb 2011 10:18:59 -0700
Message-ID: <6F62599D-3EC9-421C-AAD2-CFA6204A5F8C@dilger.ca>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:29229 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1BVRTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 12:19:00 -0500
In-Reply-To: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-21, at 1:02 PM, Amir Goldstein wrote:
> On Mon, Feb 14, 2011 at 11:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Feb 14, 2011 at 9:58 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> 
>>> One thing that comes to mind about your question with the
>>> e4b->alloc_semp causing problems.  If the only reason why we need it
>>> is to protect against multiple attempts to initialize different block
>>> groups that share the same buddy bitmap, can we solve the problem by
>>> ditching e4b->alloc_semp entirely, and simply using lock_page() on the
>>> buddy bitmap page to protect it?
>> 
>> Perhaps. I imagine there is more than one elegant way to deal with that,
>> but using a semaphore is not one of them.
>> I will take a shot at evaporating e4b->alloc_semp.
> 
> After looking at the code a bit, I find that the only critical resource
> that several groups may share on a single page is the Uptodate flag,
> which is used to indicate that the buddy cache for *all* these groups
> is loaded and lock_page() and get_page() are used to protect it.
> 
> There are 2 ways to eliminate this dependency:
> 
> 1. (AKA easy lane) use a single page (or more) per block group.
> this will increase the memory usage for 1K blocks fs and for 2K block fs
> on 8K page system, but are these use cases really that common?

I think some distros may use 1kB block filesystems for root, where there are lots of small files.  I wonder if smolt would have this kind of info?

> 2. (AKA hard lane) attach buffer heads to buddy page and use
> buffer_uptodate() and buffer_lock() instead of PageUptodate() and lock_page()
> to initialize buddy cache of groups that share the same page.
> 
> What do you say?
> Shall I take easy lane?

For flex_bg filesystems, it would probably make even more sense to just load all of the bitmaps for that page, since it won't waste any more memory or cause extra disk seeks.  I wonder what the memory vs. seek performance tradeoff is for 1k filesystems to load all the bitmaps even for the non-flex_bg case (i.e. would the second bitmap have been loaded anyway in most cases)?

Cheers, Andreas





