From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide stable pages during write
Date: Fri, 28 Dec 2012 06:48:35 +0900
Message-ID: <87y5gjxj2k.fsf@devron.myhome.or.jp>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
	<20121213080811.23360.98131.stgit@blackbox.djwong.org>
	<877go3z4ra.fsf@devron.myhome.or.jp>
	<20121227210543.GA20103@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121227210543.GA20103@blackbox.djwong.org> (Darrick J. Wong's
	message of "Thu, 27 Dec 2012 13:40:29 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

>> I think this flag should be separated into "FS provide stable page" and
>> "FS needs bounce buffer for stable page".
>> 
>> My fs (I guess btrfs also) provides stable page by better way, and
>> doesn't need to wait writeback flags too. What needs is just to avoid
>> those stable page stuff.
>
> How does your fs (are we talking about vfat?) provide stable pages?

Basically it copies the data to another page before modifying data only
if page has writeback flag. (this is about new fs under development stage.)

> btrfs creates its own bdi and doesn't set the "stable pages required"
> flag, so it already skips all the stable page stuff.

I see.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
