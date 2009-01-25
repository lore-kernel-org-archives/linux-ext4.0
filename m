From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out before
 	using them.
Date: Sun, 25 Jan 2009 11:01:55 -0600
Message-ID: <497C9B03.4080008@redhat.com>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com>	 <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>	 <497C903E.5080108@redhat.com> <ea11fea30901250822n7b1e9c3ck1959d2e42e47ce76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZAYRCD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Jan 2009 12:02:03 -0500
In-Reply-To: <ea11fea30901250822n7b1e9c3ck1959d2e42e47ce76@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Manish Katiyar wrote:
> On Sun, Jan 25, 2009 at 9:45 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Manish Katiyar wrote:
>>> On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>>> ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
>>>> where we access the b_size of it. Since it is a local variable it
>>>> might contain some garbage. Make sure it is filled with zero before
>>>> passing.
>>> Hi Ted/mingming,
>>>
>>> Any feedback on this ??
>> This looks ok to me, Manish.  I'm curious, did you see this fail in real
>> life, and if so, what'd the failure look like?
> 
> Actually no......I realised this while going through the code. I was
> also wondering why we haven't hit this till now. Since ext{3,4} don't
> have this issue, the only reason I can think of is because ext2 with
> quota is not very much used or somehow we are lucky.
> 
>> With the change, the tmp_bh bh_size is 0, so maxblocks down the
>> get_block path is also 0, but I guess that works out ok.
> 
> Yes, but that is better than having a random garbage. Isn't it ?

Absolutely; it just struck me as a little odd but it's exactly what
__ext2_get_block does as well, I probably just need to take a closer
look at what it does w/ a 0 max.

-Eric

> Thanks -
> Manish

