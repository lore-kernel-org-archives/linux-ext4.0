From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC] ext4: add an io-tree to track block allocation
Date: Thu, 21 Jun 2012 19:04:31 +0800
Message-ID: <CAGBYx2Z5XWrN70ka+1TSUqQowRzc=2UgBGJvAwvriKngN8xPMg@mail.gmail.com>
References: <20120621094648.GA17503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:53474 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2FULMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 07:12:39 -0400
In-Reply-To: <20120621094648.GA17503@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 21, 2012 at 5:46 PM, Zheng Liu <gnehzuil.liu@gmail.com> wro=
te:
> Hi all,
>
> This year at ext4 workshop a new idea that calls io-tree is proposed =
to
> solve some problmes in ext4 [1]. =A0I summarize the problems that are
> needed to solve by io-tree in here:
> 1. reserve quota calculation in bigalloc
> 2. simplify puch hole implementation
> 3. simplify fiemap implementation
> 4. SEEK_DATA/HOLE implementation
Actually, we can accelerate
 ext4_da_write_cache_pages by looking up extent status tree rather
than page cache.  This is one of aims of the original patch sets.

>
> Meanwhile with io-tree, some codes can be improved as following:
> 1. accelerate get_block functions
> 2. simplify uninitialized extent conversion
> 3. fine granularity locking (extent lock)
>
> I make a plan to implement io-tree that can be divided into three-ste=
ps.
> Now I describe it in detailed.
>
> * Step 1
> The following problems will be solved in this step:
> 1. reserve quota calculation in bigalloc
> 2. simplify puch hole implementation
> 3. simplify fiemap implementation
> 4. SEEK_DATA/HOLE implementation
>
> Currently a patch set has been submitted to the mailing list by
> Yongqiang and Allison, which called status extent tree, and it has
> simplified fiemap implementation. =A0But it only works when delay
In my memory  reserveing quota for bigalloc is also resolved in the
original patch sets.  Was it sent out?  If not, I can send the patch
to you if you need it:-)

> allocation is enabled. =A0I will pick up this work. =A0Now I have reb=
ased
> this patch set to 3.5-rc3, and renamed it to extent status tree as
> Darrick advised.
>
> Next I will try to solve the above problems and make it run in
> nodelalloc mode.
>
> * Step 2
> To be improved:
> 1. accelerate get_block functions
> 2. simplify uninitialized extent conversion
IMHO ext4_da_write_cache_pages can be improved in this step.

Yongqiang.
>
> For the above improvements, a status member will be added in extent
> status tree to indicate the current status of this extent. =A0I think=
 that
> the status includes dealloc, allocated, uninit, and hole. =A0Then we =
can
> let get_block functions to lookup extent status tree firstly to
> accelerate get_block. =A0Meanwhile uninitialized extent conversion ca=
n be
> modified to reduce lock contention of i_mutex.
>
> * Step 3
> To be done:
> 1. fine granularity locking (extent lock)
>
> Now in ext4 it does some operations with i_mutex locking. =A0After ad=
ding
> extent status tree, we can avoid to take this lock as much as possibl=
e.
> It seems that a new member needs to be added to indicate the type of
> locking. =A0We can take a range lock with shared or exclusive, and, w=
hen a
> range is locked, it cannot be merged by other processes and other typ=
es
> extent lock.
>
> Dave Chinner said that maybe range lock can be used in xfs too. =A0So=
 I
> will try to implement a generic extent locking as much as possible af=
ter
> step 3.
>
> Please review this RFC, and any feedbacks are appreciated. =A0Thanks.
>
> In addition, I remember that at ext4 workshop Ted mentions that a big
> extent tree has been implemented to improve extent cache. =A0So we ne=
ed to
> consider whether need to merge big extent tree and io-tree or not aft=
er
> both big extent tree and io-tree have been done.
>
> 1. http://www.spinics.net/lists/linux-ext4/msg31742.html
>
> Regards,
> Zheng



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
