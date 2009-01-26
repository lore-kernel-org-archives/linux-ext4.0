From: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Mon, 26 Jan 2009 08:39:23 -0800
Message-ID: <497DE73B.4050602@us.ibm.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com> <20090114044059.GA6222@mit.edu> <20090114191632.GA13114@linux-os.sc.intel.com> <1231961377.14825.51.camel@laptop>  <20090114212038.GJ6222@mit.edu> <1232568618.16682.20.camel@jamoon.sc.intel.com> <1232782595.4859.3.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53890 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZAZQj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2009 11:39:28 -0500
In-Reply-To: <1232782595.4859.3.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Zijlstra wrote:
> On Wed, 2009-01-21 at 12:10 -0800, Pallipadi, Venkatesh wrote:
>> On Wed, 2009-01-14 at 13:20 -0800, Theodore Tso wrote:
>>> On Wed, Jan 14, 2009 at 08:29:37PM +0100, Peter Zijlstra wrote:
>>>>> 38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
>>>>> commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
>>>>> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>>> Date:   Fri Sep 26 19:32:20 2008 +0200
>>>>>
>>>>>     futex: rely on get_user_pages() for shared futexes
>>>>>
>>>>>     On the way of getting rid of the mmap_sem requirement for sha=
red futexes,
>>>>>     start by relying on get_user_pages().
>>>>>
>>>>>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>>>     Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>>
>>>> However does a futex change make ext3 crap its pants?
>>> I agree, this doesn't make much sense.  I've looked at the patch, a=
nd
>>> I don't see how this would cause an ext3 orphaned-inode list handli=
ng
>>> problem
>>>
>>> Are you sure the bisect was done correctly?  Have you tried reverti=
ng
>>> that one commit, or otherwise conclusively shown that a kernel with
>>> this commit fails, and one without this commit works just fine?
>>>
>> Unfortunately, I cannot revert this patch alone from upstream git.
>> But I consistently see
>> upstream git: Always produces this oops on reboot
>> checkout of =EF=BB=BF38d47c1b: Always produces this oops on reboot
>> checkout of =EF=BB=BF=EF=BB=BF94aca1da (one patch before the above c=
ommit): Reboots fine
>> without the oops.
>>
>> This is petty specific to the particular userspace, looks like.
>> I only see this on SLES10 installation. Also, I need a non-root user
>> logged in at least once after boot through X to see this problem. I =
was
>> always seeing this as I had autologin on local terminal and was remo=
tely
>> rebooting the system. If I just boot to init 3 or boot to init 5 wit=
h no
>> user logged in or boot to init 5 with root logged in, I do not see t=
his
>> problem.
>=20
> Ted, could this happen due an extra iput()?
>=20
> In that case, Venki, does the below patch fix it?
>=20
> Credit goes to Darren for spotting this.
>=20
> ---
>  kernel/futex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f89d373..f4132ab 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -929,7 +929,7 @@ out_unlock:
>=20
>  	/* drop_futex_key_refs() must be called outside the spinlocks. */
>  	while (--drop_count >=3D 0)
> -		drop_futex_key_refs(&key1);
> +		drop_futex_key_refs(&key2);

Unfortunately, I realized later that this code was indeed correct and I=
=20
asked Ingo to pull my patch implementing the above change.  Quoting my=20
previous mail on the subject:

"I believe what is happening here is that the requeue loop requeues eac=
h=20
waiter from one futex (key1) to another (key2).  It rightly takes a=20
reference to the futex at key2 and then decrements the references to=20
key1 by drop_count (since the waiters now reference key2, not key1).=20
The newly taken key2 references will be dropped in futex_wait() when=20
each waiter is woken up and takes the futex."

However, there are still two patches in linux-tip/core/futexes that=20
addresses get|put symmetry of futex keys:

90621c40cc4ab7b0a414311ce37e7cc7173403b6
42d35d48ce7cefb9429880af19d1c329d1554e7a

However, the first is an addition of a WARN_ON (which is unlikely to=20
catch this issue as it was geared toward catching puts on failed gets).=
=20
  The latter mostly adds puts where they were missing, so also unlikely=
=20
to help.

--
Darren



>=20
>  out_put_keys:
>  	put_futex_key(fshared, &key2);
>=20
>=20


--=20
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
