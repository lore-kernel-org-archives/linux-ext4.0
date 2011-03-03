From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH v2] ext4: Fix a BUG in mb_mark_used during trim.
Date: Thu, 03 Mar 2011 23:33:35 +0800
Message-ID: <4D6FB4CF.4040202@tao.ma>
References: <alpine.LFD.2.00.1103031117210.8737@dhcp-27-109.brq.redhat.com> <1299160774-2337-1-git-send-email-tm@tao.ma> <20110303141109.GB16191@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34817 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758250Ab1CCPdn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 10:33:43 -0500
In-Reply-To: <20110303141109.GB16191@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Christoph,
On 03/03/2011 10:11 PM, Christoph Hellwig wrote:
> On Thu, Mar 03, 2011 at 09:59:34PM +0800, Tao Ma wrote:
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> In a bs=4096 volume, if we call FITRIM with the following parameter as
>> fstrim_range(start = 102400, len = 134144000, minlen = 10240),
> Can you add a xfstests regression test for this particular invocation?
> We already have Lukas' fstrim.c tester in the tree, so it could be a
> simple wrapper around it.
Actually these numbers are related to the block size of a ext4 volume.
To be more specific, with the above number, we have
first_block + block_len > EXT4_BLOCKS_PER_GROUP while
block_len < EXT4_BLOCKS_PER_GROUP.
So do you think it is generic enough for a test case in xfstests since 
now this
tool kit is also used to test xfs and btrfs?

Regards,
Tao




