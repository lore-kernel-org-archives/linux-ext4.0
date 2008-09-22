From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 1/10] VFS: Fix error handling ofwrite_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 21:52:09 +0900
Message-ID: <3717EAB2B3F742ACBE4FFEC94B98BEB5@nsl.ad.nec.co.jp>
References: <20080922195526t-sato@mail.jp.nec.com> <20080922105956.GA16069@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Christoph Hellwig" <hch@infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>,
	<viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>,
	<xfs@oss.sgi.com>, <axboe@kernel.dk>,
	<mtk.manpages@googlemail.com>, <linux-kernel@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080922105956.GA16069@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> On Mon, Sep 22, 2008 at 07:55:26PM +0900, Takashi Sato wrote:
>> I've changed the type of write_super_lockfs and unlockfs from "void" to
>> "int" so that they can return an error.
>
> Returning an error from the freeze operation makes sense, but for the
> unfreeze I don't see the point.  You must however change all existing
> instances to actually return a value (even if it's always 0 for now)
> to avoid breaking git bisect.

I thought unlockfs should return an error because ext3_unlockfs()
might cause I/O error in writing a super block.
But it is an internal error and the unfreezing succeeds.
So I will consider returning 0.

> If you touch all instances anyway, it would be nice to rename them
> to freeze / unfreze as the current names are more confusing.

I will consider renaming.

Cheers, Takashi
