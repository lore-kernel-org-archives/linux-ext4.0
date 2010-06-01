From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 1 Jun 2010 09:54:29 -0400
Message-ID: <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com>
References: <4C001888.8020006@jaysonking.com>
	<4C0018E1.5060007@jaysonking.com>
	<20100529004913.GL26177@thunk.org>
	<4C0070D8.8060500@jaysonking.com>
	<20100530212502.GQ26177@thunk.org>
	<4C0358B1.1050605@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, "Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42800 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab0FAOAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 10:00:35 -0400
In-Reply-To: <4C0358B1.1050605@uni-konstanz.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 31, 2010 at 2:35 AM, Kay Diederichs
<kay.diederichs@uni-konstanz.de> wrote:
> Am 30.05.2010 23:25, schrieb tytso@mit.edu:
>>
>> On Fri, May 28, 2010 at 08:41:44PM -0500, Jayson R. King wrote:
>>>
>>> The difference is that, 2.6.27's write_cache_pages() in
>>> page-writeback.c still updates wbc->nr_to_write, since the patch
>>> which changed that behavior was dropped from .27-rc2 due to the XFS
>>> regression it causes on mainline. ext4 appears to want the behavior
>>> of write_cache_pages which does not update wbc->nr_to_write. This
>>> write_cache_pages_da() does what ext4 wants, without introducing th=
e
>>> XFS regression. So I believe it is needed.
>>
>> Ah, OK. =A0So I understand the motivation now, and that's a valid
>> concern. =A0The question is now: how much the goal of the 2.6.27 sta=
ble
>> branch to fix bugs, and how much is it to get the best possible
>> performance, at least with respect to ext4? =A0It's going to be hard=
er
>> and harder to backport fixes to 2.6.27, and I can speak from
>> experience that it's very easy to introduce regressions while trying
>> to do backports, since sometimes an individual upstream commit can e=
nd
>> up introducing a regression, and while we do try to document
>> regression fixes in later commits, sometimes the documentation isn't
>> complete.
>>
>> I just spent the better part of a day trying to fix up a backport
>> series for 2.6.32. =A0When I was engaged in this particular exercise=
, it
>> turns out a particular commit to fix a quota deadlock introduced a
>> regression, and the fix to that introduced yet another, and there we=
re
>> three or four patches that all needed to be pulled in at once. =A0Ex=
cept
>> initially I missed one, and that caused an i_blocks corruption issue
>> when using fallocate() that took me several hours and a reverse
>> git-bisection to find. =A0(And this is one set of fixes that will
>> probably never be able to go into 2.6.27.y, since these changes also
>> interlock with probably a dozen or so quota changes that have also
>> gone in over the last couple of kernel releases.)
>>
>> I'll also add that simply testing using dbench, as you said you used
>> in another e-mail message, really isn't good enough to find all
>> possible regressions (it wouldn't have found the i_blocks corruption
>> problem in my initial set of 2.6.32 ext4 backports patches, for
>> example, since dbench only tests a very limited set of fs operations=
,
>> which doesn't include fallocate, or quotas, or mmap for that matter.=
)
>>
>> What I would recommend is using the XFSQA (also sometimes known
>> xfstests) test suite to make sure that your changes are sound. =A0Db=
ench
>> will sometimes find issues, yes, but in my experience it's not the
>> best tool. =A0The fsstress program, which is called in a number of
>> different configurations by xfstests, has found all sorts of problem=
s
>> that other thing shaven't been able to find. =A0Run it on at least a
>> 2-core system, or preferably a 4-core or 8-core system if you have i=
t.
>> I generally run tests using both 4k and 1k blocksize file systems to
>> make sure there aren't problems where the fs blocksize is less than
>> the pagesize.
>>
>> If you are willing to take on the support burden of ext4 for 2.6.27,
>> and do a lot of testing, I at least wouldn't have any objection to
>> these patches. =A0It's really a question of risk vs. reward for the
>> users of the 2.6.27 stable tree, plus a question of someone willing =
to
>> take on the support/debugging burden, and how much testing is done t=
o
>> appropriate tilt the risk/reward balance.
>>
>> Regards,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> For what it's worth: my 2.6.27.45 fileservers deadlock reproducibly a=
fter 1
> to 2 minutes of heavy NFS load, when using ext4 (never had a problem =
with
> ext3). Jayson King's patch series (posted Feb 27) fixed this, and I'v=
e been
> running it since May 1 without problems.
>
> From my experience, I'd say that the ext4 deadlock needs to be fixed;
> otherwise ext4 in 2.6.27 should not be called stable.
>
> best wishes,
> Kay

It has always been marked experimental in 2.6.27, not stable so I'm
totally lost about this effort.

See http://lxr.linux.no/#linux+v2.6.27.47/fs/Kconfig

 139        config EXT4DEV_FS
 140        tristate "Ext4dev/ext4 extended fs support development
(EXPERIMENTAL)"
 141        depends on EXPERIMENTAL
 142        select JBD2
 143        select CRC16
 144        help
 145          Ext4dev is a predecessor filesystem of the next generatio=
n
 146          extended fs ext4, based on ext3 filesystem code. It will =
be
 147          renamed ext4 fs later, once ext4dev is mature and stabili=
zed.
 ...
 164
 165          If unsure, say N.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
