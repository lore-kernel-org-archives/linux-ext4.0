From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Fri, 31 Dec 2010 22:51:27 +1100
Message-ID: <AANLkTinpXuLQSm_W2xOrTXvn3TGGMuzvkMR1GMSwdxsM@mail.gmail.com>
References: <20101230232936.GA931@mail.oracle.com>
	<AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
	<20101231110054.GA20521@mail.oracle.com>
	<AANLkTik3_=Jo2ubML1hhanFFKC3MkEibrCPruto2oY_v@mail.gmail.com>
	<20101231113949.GA21179@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39472 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0LaLv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Dec 2010 06:51:29 -0500
In-Reply-To: <20101231113949.GA21179@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 31, 2010 at 10:39 PM, Joel Becker <Joel.Becker@oracle.com> =
wrote:
> On Fri, Dec 31, 2010 at 10:16:35PM +1100, Nick Piggin wrote:
>> On Fri, Dec 31, 2010 at 10:00 PM, Joel Becker <jlbec@evilplan.org> w=
rote:
>> > On Fri, Dec 31, 2010 at 08:31:41PM +1100, Nick Piggin wrote:
>> >> On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle=
=2Ecom> wrote:
>>
>> >> The better way to do this would be to just return VM_FAULT_NOPAGE
>> >> in any case you need the VM to retry the fault. When you reach th=
e
>> >> business end of your handler, you want to hold the page locked, a=
fter
>> >> you verify it is correct, and return that to the fault handler.
>> >
>> > =A0 =A0 =A0 =A0This is going to be hard. =A0Our write_end() assume=
s it must
>> > unlock the pages (which is normal behavior for write(2)), but in t=
he
>> > page_mkwrite() case we need to avoid the unlock to follow your
>> > recommendation (we use our write_begin/write_end pair to trigger a=
ny
>> > allocation or zeroing needed before the page is writable).
>>
>> Yes that would be the best option. It is possible to use the unlocke=
d
>> return, but that still gives possibility of races in some cases. Con=
sider
>
> =A0 =A0 =A0 =A0Yes, I am aware of that.
>
>> Basically it would be nice for all filesystems to move to this conve=
ntion
>> so we can remove the old cruft.
>
> =A0 =A0 =A0 =A0I can appreciate that. =A0And you've just answered the=
 "Do you
> want us to get there, or are minor faults in the old-0-style OK?"
> question.

It is OK in that it will work. It is not preferred, if you are reworkin=
g pleaase
use the new style.


>> > =A0 =A0 =A0 =A0The find_or_create_page() is deep at the meat of th=
e function,
>> > not the cursory check at the top. =A0The idea is that at this poin=
t,
>> > find_or_create_page() will return a locked page that must, by
>> > definition, be part of the correct mapping.
>>
>> But you must still handle failures there, because find_or_create_pag=
e
>> may return -ENOMEM. So just lock the page, recheck the mapping
>> there, and then do exactly the same error handling.
>
> =A0 =A0 =A0 =A0Of course it can error, but error is different than cl=
ean
> restart. =A0Though cleanup should be the same; I'm looking at our cod=
e
> trying to convince myself that this is so ;-)

Cleanup is exactly the same, yes, because the only difference in
different error codes is what the VM does with them.


> =A0Btw, -ENOMEM is that OOM
> fault error, right? ;-)

Right.


>> > =A0 =A0 =A0 =A0If the VM is rechecking the pte after we return fro=
m
>> > page_mkwrite(), won't it see any new page created?
>>
>> But the point of page_mkwrite is a dirty notifier for the fs. If thi=
s new
>> different page was installed due to say truncate then a read-only
>> fault, the filesystem would miss the notification. So it just does t=
he
>> simple thing and retries the whole sequence (if needed).
>
> =A0 =A0 =A0 =A0Fair enough, even if we caused the new page and thus a=
re already
> notified ;-)

Well, you would be notified via ->fault, but not not writable fault and=
 no
page_mkwrite.


> =A0 =A0 =A0 =A0Essentially, you would really like us (and ext4, and g=
fs2, etc)
> to start returning VM_FAULT_NOPAGE for any place we aren't sure what
> happened to our page, VM_FAULT_OOM when we get an -ENOMEM, and
> VM_FAULT_LOCKED for all successful operations. =A0That the long and s=
hort
> of it? =A0Thank you for helping me understand your plan for this code=
=2E

Exactly.


> =A0 =A0 =A0 =A0Btw, what not use VM_FAULT_RETRY for "I'd like you to =
retry"?
> Especially since the comment for NOPAGE doesn't read anything like it=
s
> actual behavior.

It was designed first to replace that old ->nopfn handler, so it does n=
eed
comments updating. RETRY doesn't cover the ->nopfn usage, but NOPAGE
does cover the retry usage, I think, so names are OK.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
