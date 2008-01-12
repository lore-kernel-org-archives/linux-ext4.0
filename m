From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Fwd: [Bug 9732] New: oops in extent code via ext4_fallocate]
Date: Sat, 12 Jan 2008 10:41:02 -0600
Message-ID: <4788ED9E.3090207@redhat.com>
References: <4787D498.1050202@redhat.com> <20080112163144.GA6546@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYALQlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Jan 2008 11:41:07 -0500
In-Reply-To: <20080112163144.GA6546@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Jan 11, 2008 at 02:42:00PM -0600, Eric Sandeen wrote:
> 
>> The BUG_ON is:
>>
>>         BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
>>
>> where these were the values:
>>
>>         logical 8 ee_block 0 ee_len 32776
>>
>> Haven't looked further into it yet.
>>
> 
> Not able to reproduce. Why is it calling ext4_ext_search_left for that
> value of logical ? ext4_ext_get_blocks should have found that the
> logical belong to an already existing extent and return from there. It
> should have returned from
> 
> 2365      if (create == EXT4_CREATE_UNINITIALIZED_EXT)
> 2366               goto out;
> 
> 
> root@qemu-image:/ext4# /root/testfallocate  -f a 0 100

> root@qemu-image:/ext4# /root/truncate  ./a 50

> root@qemu-image:/ext4# /root/testfallocate  -f a 0 100

This isn't exercising extents code at all, all your sizes are all within
the first block.  Try the numbers I have in the bug?

Or more simply,

[root@bear-05 sdb8]# ./testfallocate -f testfile 0 32768
[root@bear-05 sdb8]# ./testfallocate -f testfile 16384 65536

or

[root@bear-05 sdb8]# ./testfallocate -f testfile 0 16384
[root@bear-05 sdb8]# ./testfallocate -f testfile 32768 65536


-Eric
