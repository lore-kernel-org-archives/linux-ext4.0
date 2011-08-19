From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: Flush any pending end_io requests before O_direct
 read on dioread_nolock
Date: Fri, 19 Aug 2011 14:08:01 -0700
Message-ID: <CAFgt=MD-uhme9xtYnEkvd6ZKdt73pmQei9ncnWAW_Km0pZRjVg@mail.gmail.com>
References: <20110819012845.7A4A32012F@ruihe2.smo.corp.google.com>
	<20110819205722.GA3578@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:59855 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1HSVIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 17:08:05 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p7JL8392027162
	for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 14:08:03 -0700
Received: from gwm11 (gwm11.prod.google.com [10.200.13.11])
	by wpaz33.hot.corp.google.com with ESMTP id p7JL6Lre011669
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 14:08:01 -0700
Received: by gwm11 with SMTP id 11so2397478gwm.2
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 14:08:01 -0700 (PDT)
In-Reply-To: <20110819205722.GA3578@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Fri, Aug 19, 2011 at 1:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 18, 2011 at 06:28:45PM -0700, Jiaying Zhang wrote:
>> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kioc=
b *iocb,
>> =A0 =A0 =A0 }
>>
>> =A0retry:
>> - =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(inode))
>> + =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(inode)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!list_empty(&ei->i_completed_=
io_list))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&inode->i_mutex=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_flush_completed_IO(in=
ode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_mut=
ex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Doesn't this largely invalidate the reasons for using dioread_nolock
> in the first place, which was to avoid taking the i_mutex for
> performance reasons? =A0If we are willing to solve the problem this w=
ay,
> I wonder if we be better off just simply telling users to disable
> dioread_nolock if they care about cache consistency between DIO reads
> and buffered writes?
>
> (Yes, I do understand that in the hopefully common case where a user
> is not trying to do buffered writes and DIO reads at the same time,
> we'll just take and release the mutex very quickly, but still, it's
> got to have a performance impact.)
My hope is that in the hopefully common case, applications just do a lo=
t of
DIO reads, so the check on unlikely(!list_empty(&ei->i_completed_io_lis=
t)
would fail and we don't need to take the i_mutex lock. It is certainly =
not an
optimal solution because we only care about data consistency for the bl=
ocks
to be read instead of all of uncompleted writes. But again, the more ge=
neral
solution would require some kind of extent tree that requires some
development effort.

Jiaying

>
> I seem to recall a conversation I had with Stephen Tweedie over a
> decade ago, where he noted that many other Unix systems made
> absolutely no cache consistency guarantees with respect to DIO and th=
e
> page cache, but he wanted to set a higher standard for Linux. =A0Whic=
h
> is fair enough, but I wonder if for the case of dioread_nolock, since
> its raison d'etre is to avoid the i_mutex lock, to simply just say
> that one of the side effects of dioread_nolock is that (for now) the
> cache consistency guarantees are repealed if this mount option is
> chosen.
>
> What do folks think?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
