From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Fri, 31 Dec 2010 22:16:35 +1100
Message-ID: <AANLkTik3_=Jo2ubML1hhanFFKC3MkEibrCPruto2oY_v@mail.gmail.com>
References: <20101230232936.GA931@mail.oracle.com>
	<AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
	<20101231110054.GA20521@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42971 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0LaLQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Dec 2010 06:16:37 -0500
In-Reply-To: <20101231110054.GA20521@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 31, 2010 at 10:00 PM, Joel Becker <jlbec@evilplan.org> wrot=
e:
> On Fri, Dec 31, 2010 at 08:31:41PM +1100, Nick Piggin wrote:
>> On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle.co=
m> wrote:

>> If the filesystem returns 0, it means minor fault, and the VM will a=
ctually
>> install the page (unless the hack to check page->mapping catches it)=
=2E
>
> =A0 =A0 =A0 =A0Right, but does it install the page passed into page_m=
kwrite()?
> The way I read the code, it actually rechecks the pte and installs th=
e
> page it now finds.

No, it doesn't install anything, it just bails out and the fault will b=
e
restarted if required.

>> The better way to do this would be to just return VM_FAULT_NOPAGE
>> in any case you need the VM to retry the fault. When you reach the
>> business end of your handler, you want to hold the page locked, afte=
r
>> you verify it is correct, and return that to the fault handler.
>
> =A0 =A0 =A0 =A0This is going to be hard. =A0Our write_end() assumes i=
t must
> unlock the pages (which is normal behavior for write(2)), but in the
> page_mkwrite() case we need to avoid the unlock to follow your
> recommendation (we use our write_begin/write_end pair to trigger any
> allocation or zeroing needed before the page is writable).

Yes that would be the best option. It is possible to use the unlocked
return, but that still gives possibility of races in some cases. Consid=
er
if the filesystem has to allocate some persistent metadata while the
page is dirty, then it must do so in page_mkwrite (set_page_dirty may
not sleep), but if the page is returned with no locks, it might be poss=
ible
that metadata is freed before the page can be installed in the dirty pt=
e.

Basically it would be nice for all filesystems to move to this conventi=
on
so we can remove the old cruft.


>> > =A0 =A0 =A0 =A0It looks hard to lock the page for good high up at =
our first
>> > check of the mapping. =A0Wengang has proposed to simply ignore the=
 page
>> > passed into page_mkwrite() and just find_or_create_page() the suck=
er at
>> > the place we're ready to consider it stable. =A0As I see it, the t=
wo
>> > places that call page_mkwrite() are going to revalidate the pte an=
yway,
>> > and they'll find the newly created page if find_or_create_page() g=
ets a
>> > different. =A0Is that safe behavior?
>>
>> I can't see the point. If you can find_or_create_page, then you can
>> lock_page, by definition. Then check the mapping and
>> VM_FAULT_SIGBUS if it is wrong.
>
> =A0 =A0 =A0 =A0The find_or_create_page() is deep at the meat of the f=
unction,
> not the cursory check at the top. =A0The idea is that at this point,
> find_or_create_page() will return a locked page that must, by
> definition, be part of the correct mapping.

But you must still handle failures there, because find_or_create_page
may return -ENOMEM. So just lock the page, recheck the mapping
there, and then do exactly the same error handling.

>> Messing with the wrong page will only see the result ignored by the =
VM,
>> and push an incorrect page through parts of your fault handler, whic=
h
>> is potentially confusing at best, I would have thought.
>
> =A0 =A0 =A0 =A0If the VM is rechecking the pte after we return from
> page_mkwrite(), won't it see any new page created?

But the point of page_mkwrite is a dirty notifier for the fs. If this n=
ew
different page was installed due to say truncate then a read-only
fault, the filesystem would miss the notification. So it just does the
simple thing and retries the whole sequence (if needed).
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
