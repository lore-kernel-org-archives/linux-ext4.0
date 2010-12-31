From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Fri, 31 Dec 2010 20:31:41 +1100
Message-ID: <AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
References: <20101230232936.GA931@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: wengang@ca-server1.us.oracle.com
To: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58937 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0LaJbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Dec 2010 04:31:43 -0500
In-Reply-To: <20101230232936.GA931@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Joel,

On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle.com> =
wrote:
> Nick,
> =A0 =A0 =A0 =A0While visiting some issues in ocfs2_page_mkwrite(), I =
realized
> that we're returning 0 to mean "Please try again Mr VM", but the call=
er

0 has always meant minor fault, which means the filesystem satisfied
the request without doing IO. In the change to bit mask return values,
I kept it compatible by having major fault be presence of a bit, and mi=
nor
fault indicate absence.

> of page_mkwrite() now expects VM_FAULT_NOPAGE. =A0This is all due to
> 56a76f [fs: fix page_mkwrite error cases in core code and btrfs].

NOPAGE basically means no further action on part of the VM is required.
It was used to consolidate pfn based fault handler with page based faul=
t
handler. And then, later, it was further used in this case to allow the
filesystem to have the VM try again in rare / difficult to handle error=
 cases
exactly like truncate races.

> =A0 =A0 =A0 =A0In the comment for 56a76f, you state that btrfs is the=
 example
> but all other filesystems need to be fixed...yet ocfs2, ext4, and gfs=
2
> continue to return 0 or VM_FAULT_SIGBUS.
> =A0 =A0 =A0 =A0I guess this continues to work because we return the p=
age
> unlocked (thus triggering the "if (unlikely(!(tmp & VM_FAULT_LOCKED))=
)"
> logic). =A0Was this expected to continue to work, or do you consider =
these
> filesystems broken until they are updated with the new return codes?

No it was all back compatible. That is to say, the ones that return SIG=
BUS
in these cases were already broken, but the patch didn't break them fur=
ther.
Actaully it closed up races a bit, if I recall. But yes they should hav=
e all
been converted to the new calling convention and returning with page
locked.

If the filesystem returns 0, it means minor fault, and the VM will actu=
ally
install the page (unless the hack to check page->mapping catches it).


> =A0 =A0 =A0 =A0Back to the ocfs2 issue. =A0Am I correctly reading the=
 current
> code that we can safely throw away the page passed in to page_mkwrite=
()
> if a pagecache flush has dropped it?

Well you just return NOPAGE and the VM throws the page away.


> =A0Currently, we presume that the
> page passed in must be the one we make writable. =A0We make a quick c=
heck
> of page->mapping =3D=3D inode->i_mapping, returning 0 (for "try again=
")
> immediately if that's false. =A0But once we get into the meat of our
> locking and finally lock the page for good, we assume mapping=3D=3Di_=
mapping
> still holds. =A0That obviously breaks when the pagecache gets truncat=
ed.
> At this late stage, we -EINVAL (clearly wrong).

The better way to do this would be to just return VM_FAULT_NOPAGE
in any case you need the VM to retry the fault. When you reach the
business end of your handler, you want to hold the page locked, after
you verify it is correct, and return that to the fault handler.


> =A0 =A0 =A0 =A0It looks hard to lock the page for good high up at our=
 first
> check of the mapping. =A0Wengang has proposed to simply ignore the pa=
ge
> passed into page_mkwrite() and just find_or_create_page() the sucker =
at
> the place we're ready to consider it stable. =A0As I see it, the two
> places that call page_mkwrite() are going to revalidate the pte anywa=
y,
> and they'll find the newly created page if find_or_create_page() gets=
 a
> different. =A0Is that safe behavior?

I can't see the point. If you can find_or_create_page, then you can
lock_page, by definition. Then check the mapping and
VM_FAULT_SIGBUS if it is wrong.

Messing with the wrong page will only see the result ignored by the VM,
and push an incorrect page through parts of your fault handler, which
is potentially confusing at best, I would have thought.

Thanks,
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
