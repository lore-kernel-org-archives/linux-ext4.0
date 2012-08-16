From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
Date: Thu, 16 Aug 2012 16:15:05 +0300
Message-ID: <502CF259.9040300@panasas.com>
References: <502CC4AA.6040702@gmail.com>  <1345119652.3393.220.camel@sauron.fi.intel.com>  <502CE840.4060802@panasas.com> <1345122611.3393.225.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Marco Stornelli <marco.stornelli@gmail.com>, <bhalevy@tonian.com>,
	<jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	<adilger.kernel@dilger.ca>, <tytso@mit.edu>,
	<hirofumi@mail.parknet.co.jp>, <mikulas@artax.karlin.mff.cuni.cz>,
	Al Viro <viro@ZenIV.linux.org.uk>, <hch@infradead.org>,
	<dushistov@mail.ru>, <osd-dev@open-osd.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:36437 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2HPNPu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 09:15:50 -0400
In-Reply-To: <1345122611.3393.225.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/16/2012 04:10 PM, Artem Bityutskiy wrote:

> On Thu, 2012-08-16 at 15:32 +0300, Boaz Harrosh wrote:
>> On 08/16/2012 03:20 PM, Artem Bityutskiy wrote:
>>
>>> On Thu, 2012-08-16 at 12:00 +0200, Marco Stornelli wrote:
>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>
>>>> Remove lock and unlock super operation.
>>>>
>>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>>
>>
>>
>> Are you sure? It used to be that exofs_sync_fs() could be called
>> concurrently.
>>
>> What about two "bash -c sync" calls or a sync and an unmount
>> in parallel. anything protecting that?
>>
>> If so then sure, but please let me test first.
> 
> Umm, actually we will probably end up writing the same twice without the
> lock. 
> 


No we are not allowed to run exofs_sync_fs() concurrently because it uses
a per-alllocated scratch buffer to do it's stuff so you can end up with data
corruption on disk.

And we cannot use a spin-lock because we might sleep in ore_write()

There are some optimizations I can do here, but lets for now just do
the sb->s_lock thing, and I might decide to completely revamp the
all thing later.

Thanks
Boaz
