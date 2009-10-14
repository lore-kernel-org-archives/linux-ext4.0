From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Help understanding prealloc space choice?
Date: Wed, 14 Oct 2009 10:26:45 -0700
Message-ID: <6601abe90910141026s3d07dc74qd9968f39c2482f4a@mail.gmail.com>
References: <6601abe90910131106u3a569d51g1322fe6764a2fbb6@mail.gmail.com>
	 <20091014052314.GA29704@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:4142 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZJNR15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 13:27:57 -0400
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n9EHQmwb030180
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 18:26:48 +0100
Received: from pzk39 (pzk39.prod.google.com [10.243.19.167])
	by spaceape11.eur.corp.google.com with ESMTP id n9EHNdC2011290
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 10:26:46 -0700
Received: by pzk39 with SMTP id 39so8531970pzk.15
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 10:26:46 -0700 (PDT)
In-Reply-To: <20091014052314.GA29704@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh:

Thanks for responding.

On Tue, Oct 13, 2009 at 10:23 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, Oct 13, 2009 at 11:06:35AM -0700, Curt Wohlgemuth wrote:
>> Hi all:
>>
>> I'm looking in ext4_mb_use_preallocated() and am seeing something od=
d.
>>
>> First we look through the inode prealloc list, and see if we have a
>> preallocation that satisfies the allocation context:
>>
>> =A0 =A0 =A0 =A0/* all fields in this condition don't change,
>> =A0 =A0 =A0 =A0 * so we can skip locking for them */
>> =A0 =A0 =A0 =A0if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ac->ac_o_ex.fe_logical >=3D pa->pa_ls=
tart + pa->pa_len)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>>
>> =A0 =A0 =A0 =A0/* non-extent files can't have physical blocks past 2=
^32 */
>> =A0 =A0 =A0 =A0if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL=
) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pa->pa_pstart + pa->pa_len > EXT4_MAX=
_BLOCK_FILE_PHYS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>>
>> =A0 =A0 =A0 =A0/* found preallocated blocks, use them */
>> =A0 =A0 =A0 =A0spin_lock(&pa->pa_lock);
>> =A0 =A0 =A0 =A0if (pa->pa_deleted =3D=3D 0 && pa->pa_free) {
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =3D> Now we're good, and have an AC that sat=
isfies us.
>> =A0 =A0 =A0 =A0 =A0 =A0 =3D> We call ext4_mb_use_inode_pa(ac, pa);
>>
>>
>> But ext4_mb_use_inode_pa() has this:
>>
>> =A0 =A0 =A0 BUG_ON(pa->pa_free < len);
>>
>> Nowhere do we check the 'pa_free' value to decide if this preallocat=
ion is
>> okay to use.
>>
>
> the 'len' value above is derived out of what we have in prealloc spac=
e.
> ie, we do this
>
> =A0 =A0 start =3D pa->pa_pstart + (ac->ac_o_ex.fe_logical - pa->pa_ls=
tart);
> =A0 =A0 end =3D min(pa->pa_pstart + pa->pa_len, start + ac->ac_o_ex.f=
e_len);
> =A0 =A0 len =3D end - start;
>
> Now to decide whether we need to use a particular inode prealloc spac=
e
> we look at the pa->pa_lstart which is the start logical block number
> mapping this prealloc space. So if the requested logical block number
> falls within a prealloc space (ie within pa->pa_lstart , pa->pa_lstar=
t + pa->pa_len)
> we use the prealloc space. Done by the below conditional ext4_mb_use_=
preallocated
>
> =A0 =A0 =A0/* all fields in this condition don't change,
> =A0 =A0 =A0 * so we can skip locking for them */
> =A0 =A0 =A0 if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
> =A0 =A0 =A0 =A0 =A0 =A0 ac->ac_o_ex.fe_logical >=3D pa->pa_lstart + p=
a->pa_len)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
>
>
>>
>> Further down in ext4_mb_use_preallocated() we check the locality gro=
up
>> prealloc list; for this, we DO check pa_free:
>>
>> =A0 =A0 =A0 =A0 =A0spin_lock(&pa->pa_lock);
>> =A0 =A0 =A0 =A0 =A0if (pa->pa_deleted =3D=3D 0 &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pa->pa_free >=3D =
ac->ac_o_ex.fe_len) {
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpa =3D ext4_mb_check_group_pa(go=
al_block,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pa, cpa);
>>
>
>
> locality group prealloc space is not looked with the logical block nu=
mber.
> We just claim need blocks from the prealloc space. Hence we check for=
 the
> available free blocks and the needed free blocks.
>
>
>
>> So my question is: =A0Is it a bug that we don't check that an inode
>> preallocation has enough free blocks for the AC before we try to use=
 it? =A0I
>> have hit the BUG_ON above at least once in my testing, but I can't
>> characterize what the workload was at the time (nor can I reproduce =
it...).
>>
>
> You should not hit that. That would mean prealloc space accounting we=
nt wrong.
> Which is really a BUG

Okay, I get it.

In theory, it really does seem like a problem to me that we don't
check pa_free before we decide that the inode prealloc space is
suitable for this AC.  In practice, though, this would only be an
issue if we got overlapping requests in the same logical block range,
which just shouldn't happen.

Looking further, it seems that the BUG_ON in ext4_mb_use_inode_pa()
fired for me after a lot of device failures, along with failures to
read the block bitmap and the like.  So I suppose that trying to deal
gracefully with this sort of device error is just difficult to do, eh?

Thanks,
Curt

>
> -aneesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
