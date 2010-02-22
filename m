From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Mon, 22 Feb 2010 14:44:24 +0900
Message-ID: <4B8219B8.8070207@jp.fujitsu.com>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com> <20100216185452.GE3153@quack.suse.cz> <4B7BAA70.9070605@jp.fujitsu.com> <20100217164933.GC5337@thunk.org>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58470 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0BVFof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2010 00:44:35 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o1M5iWlX022792
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 22 Feb 2010 14:44:33 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5FE6245DE57
	for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 14:44:32 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 2EB9545DE55
	for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 14:44:32 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0FB271DB8038
	for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 14:44:32 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B581F1DB803B
	for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2010 14:44:28 +0900 (JST)
In-Reply-To: <20100217164933.GC5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
sorry for my late response.

tytso@mit.edu wrote:
 > On Wed, Feb 17, 2010 at 05:36:00PM +0900, Toshiyuki Okajima wrote:
 > > >
 > > > The reason that I wanted to change the journaling interface into=
 jbd2 were:
 > > > - the most of my customers use linux for Mission Critical (M.C.)=
=2E
 > > > - M.C. users want the filesystems which have more integrity for =
their data.
 > > > - I think we should not recommend ext4 to M.C. users because
 > > >   for M.C. users, ext4 is still unstable filesystem.
 > > >   Therefore I want to let M.C. users use ext3 for the present.
 > > > - it is not easy to maintain both jbd and jbd2, so
 > > >   I thought it was easy to solve it by unifying the journaling i=
nterfaces
 > > >   into ext4.
 >
 > But if they are mission critical users, why would they be willing to
 > accept changes to the jbd2 layer, and the necessary changes to ext3 =
so
 > it can use jbd2?  Any time you add changes, you will be causing a
 > certain amount of instability and risk.  So the question is, what ar=
e
 > your users willing to tolerate?
 >
 > Some important questions to ask:
 >
 > 1) Is the problem psychological?  i.e., is the problem that it is
 > *called* ext4?  After all, ext4 is derived from ext3, so if they are
 > willing to accept new features backported into ext3 (i.e., journal
 > checksums) and the risks associated with making changes to add new
 > features, why are they not willing to accept ext4?
I guess some important basic functions, delayed allocation and quota
seems to be still unstable. At least, if these functions may work
incorrectly, M.C. users cannot use it.

 > 2) If it is a question of risk, how many changes are they willing to
 > accept?  I will note that if you don't enable extents, and disable
 > delayed allocation, you can significantly decrease the risk of using
 > ext4.  (Essentially at that point the only major change is the block
 > allocation code and the changes to use jbd2.)
I think M.C. users don't accept ext4 easily because the basic body of e=
xt4
is a little different from ext3 even if the features of delalloc and ex=
tents
are unused.
(For example, ext4 has the multi block allocation feature, but ext3 doe=
sn't
have.)

---
Besides, even if we use ext3 and encounter some troubles by ext3/jbd mo=
dule,
we can avoid these troubles by using ext2 module during repairing
these troubles. (Because ext3 filesystem can mount as ext2 filesystem b=
y ext2
module.)
But even if we use ext4 with "extents" feature and encounter some troub=
les
by ext4/jbd2 module, we cannot avoid these troubles by ext2/ext3 module=
s
because ext3 (or ext2) cannot work "extents" feature. Therefore I think
M.C. users demand that the quality of ext4 is the same as ext3 level or
higher.
---

 >
 > 3) How much testing do you need to do before it would be considered
 > acceptable for your Mission Critical users?  Or is it a matter of ti=
me
 > to allow other users to be the "guinea pigs"?   :-)
 >
I think I also have to test the ext4 features (delalloc, quota, mballoc
and so on).
It may cost about half a year or a year ...

 > > > OK. I see.
 > > > (ext3 is already stable filesystem, so, we should not change
 > > >  ext3 drastically.)
 >
 > Well, certainly, *any* change is going to risk destablizing the file
 > system.  Isn't that the argument why you are concerned about whether
 > ext4 is ready for your M.C. users?  One of the reasons why we forked
 > jbd2 from jbd was precisely because of these sorts of concerned.  So
 > if you switch ext3 to use jbd2, would that not increase the risk to
 > your M.C. users?
Of course, M.C. users don't want unstable filesystems.
So, M.C. users don't use ext3 with jbd2 at once even if ext3 with jbd2
is achieved.
But they are sure to want filesystems which have enough integrity featu=
res.=E3=80=80

Therefore, at first, I was to try to add the journaling interface jbd2
with jbd interface left.
(But I think M.C. users want to use ext4 in the future because ext4 is:
  - max filesystem size is much bigger than ext3
  - I/O performance is superior to ext3 with delayed allocation and mul=
ti block
     allocation.
  - and other features which ext3 doesn't have fascinate M.C. users.)

By this change, I thought ext3 and ext4 would mutually achieve a good e=
ffect:
  - [ext3] jbd2 component can get stable earlier because ext3 joins the=
 jbd2
           users, then developers of jbd2 increase.
  - [ext3] as the result, if jbd2 becomes enough quality, M.C. users ca=
n use
           jbd2 interface of ext3.
  - [ext4] as the result, if jbd2 becomes enough quality, ext4 becomes =
better
           quality.
  - [ext4] at last, if ext4 becomes enough quality, M.C. users can use =
ext4.

But, I will stop trying to implement jbd2 interface of ext3
because I understand the policy which keeps ext3 stable with ext3 & jbd=
=2E

Best Regards,
Toshiyuki Okajima

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
