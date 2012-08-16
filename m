From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
Date: Thu, 16 Aug 2012 15:32:00 +0300
Message-ID: <502CE840.4060802@panasas.com>
References: <502CC4AA.6040702@gmail.com> <1345119652.3393.220.camel@sauron.fi.intel.com>
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
Received: from natasha.panasas.com ([67.152.220.90]:34384 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2HPMdC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 08:33:02 -0400
In-Reply-To: <1345119652.3393.220.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/16/2012 03:20 PM, Artem Bityutskiy wrote:

> On Thu, 2012-08-16 at 12:00 +0200, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Remove lock and unlock super operation.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 


Are you sure? It used to be that exofs_sync_fs() could be called
concurrently.

What about two "bash -c sync" calls or a sync and an unmount
in parallel. anything protecting that?

If so then sure, but please let me test first.
Boaz

