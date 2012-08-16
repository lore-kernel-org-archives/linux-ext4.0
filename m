From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
Date: Thu, 16 Aug 2012 18:09:22 +0200
Message-ID: <502D1B32.7020005@gmail.com>
References: <502CC4AA.6040702@gmail.com> <1345119652.3393.220.camel@sauron.fi.intel.com> <502CE840.4060802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: dedekind1@gmail.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <502CE840.4060802@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il 16/08/2012 14:32, Boaz Harrosh ha scritto:
> On 08/16/2012 03:20 PM, Artem Bityutskiy wrote:
>
>> On Thu, 2012-08-16 at 12:00 +0200, Marco Stornelli wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> Remove lock and unlock super operation.
>>>
>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>
>
>
> Are you sure? It used to be that exofs_sync_fs() could be called
> concurrently.
>
> What about two "bash -c sync" calls or a sync and an unmount
> in parallel. anything protecting that?
>
> If so then sure, but please let me test first.
> Boaz
>
> .
>

Yes Boaz, I agree, it's the reason I asked for a comments for exofs and 
hpfs. The only reason to have a lock here is to serialize operations in 
parallel on the same super block.

Marco
