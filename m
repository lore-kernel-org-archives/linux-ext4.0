From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Tue, 18 Dec 2012 21:08:51 -0600
Message-ID: <50D12FC3.6090209@redhat.com>
References: <50D0A1FD.7040203@redhat.com> <20121219012710.GF5987@quack.suse.cz> <20121219020526.GG5987@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab2LSDJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 22:09:34 -0500
In-Reply-To: <20121219020526.GG5987@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/18/12 8:05 PM, Jan Kara wrote:
> On Wed 19-12-12 02:27:10, Jan Kara wrote:
>>> With a u8 tid_t, the "else" clause from commit d9b0193 fires
>>> frequently; I really think the underlying problem is that tid_geq()
>>> etc does not properly handle wraparounds - if, say, target is 255
>>> and j_commit_request is 0, we don't know if j_commit_request
>>> is 255 tids behind, or 1 tid ahead.  I have to think about that
>>> some more, unless it's obvious to someone else.
>>   Well, there's no way to handle wraps better AFAICT. Tids eventually wrap
>> and if someone has stored away tid of a transaction he wants committed and
>> keeps it for a long time before using it, it can end up being anywhere
>> before / after current j_commit_request. The hope was that it takes long
>> enough to wrap around 32-bit tids. If this happens often in practice we may
>> have to switch to 64-bit tids (in memory, on disk 32-bit tids are enough
>> because of limited journal size).

I was wondering if, since the tid_g*() functions only work if the
distance is half the unsigned int space, we can force a commit at some
point if j_transaction_sequence has gotten too far ahead?  I'm not sure
where or if that could be done...

-Eric
