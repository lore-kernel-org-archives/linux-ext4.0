From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on percpu_counter_batch
Date: Tue, 6 Sep 2011 09:30:50 -0400
Message-ID: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
References: <20110826072622.406d3395@kryten> <20110826072927.5b4781f9@kryten> <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110829214609.495ee299@kryten> <20110906034851.GC18425@mtj.dyndns.org>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anton Blanchard <anton@samba.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:62664 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab1IFNa7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 09:30:59 -0400
In-Reply-To: <20110906034851.GC18425@mtj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sep 5, 2011, at 11:48 PM, Tejun Heo wrote:

> On Mon, Aug 29, 2011 at 09:46:09PM +1000, Anton Blanchard wrote:
>>=20
>> When testing on a 1024 thread ppc64 box I noticed a large amount of
>> CPU time in ext4 code.
>>=20
>> ext4_has_free_blocks has a fast path to avoid summing every free and
>> dirty block per cpu counter, but only if the global count shows more
>> free blocks than the maximum amount that could be stored in all the
>> per cpu counters.
>>=20
>> Since percpu_counter_batch scales with num_online_cpus() and the max=
imum
>> amount in all per cpu counters is percpu_counter_batch * num_online_=
cpus(),
>> this breakpoint grows at O(n^2).
>>=20
>> This issue will also hit with users of percpu_counter_compare which
>> does a similar thing for one percpu counter.
>>=20
>> I chose to cap percpu_counter_batch at 1024 as a conservative first
>> step, but we may want to reduce it further based on further benchmar=
king.
>>=20
>> Signed-off-by: Anton Blanchard <anton@samba.org>
>=20
> Applied to percpu/for-3.2.

Um, this was an ext4 patch and I pointed out it could cause problems.  =
(Specifically, data loss=85)

- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
