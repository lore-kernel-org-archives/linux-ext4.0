From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Add SEEK_DATA/SEEK_HOLE support V2
Date: Wed, 28 Sep 2011 16:11:34 +0800
Message-ID: <CAGBYx2YP0=BW-86-9zaaTqu+-x85JqEECkpsQH89AD6L7sGeKg@mail.gmail.com>
References: <4E82BF7B.7000403@oracle.com>
	<CAGBYx2YzeBvQPEV7uuHmxwZQD+oE+nuF_bd+CZwzm1F0n8o-ZA@mail.gmail.com>
	<4E82D48C.2000603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
To: jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37073 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1I1ILi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 04:11:38 -0400
Received: by iaqq3 with SMTP id q3so6630809iaq.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 01:11:35 -0700 (PDT)
In-Reply-To: <4E82D48C.2000603@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 28, 2011 at 4:02 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 09/28/2011 03:21 PM, Yongqiang Yang wrote:
>
>> On Wed, Sep 28, 2011 at 2:32 PM, Jeff Liu <jeff.liu@oracle.com> wrot=
e:
>>> Hello all,
>>>
>>> This is the V2 for add SEEK_DATA/SEEK_HOLE support to ext4.
>>> In V1, I copied all the codes regarding fetching delayed-extents ou=
t to
>>> my seek callback function, it's stupid to duplicate the code blocks=
=2E
>>>
>>> Now the idea is, since the delayed-extents is the main concern to s=
earch
>>> extents for both fiemap and seek, so IMHO, it's better to consolida=
te
>>> this procedure into a new function(get_delayed_extent() in my patch=
),
>>> and call it in fiemap and seek call-back functions if necessary. =A0=
In
>>> this way, when yongqiang's delayed-extents tree is ready, we only n=
eed
>>> to modify the code block at get_delayed_extent() accordingly.
>>>
>>> In addition, yongqiang has pointed out there might be a deadlock, b=
ut
>>> per my understood, as the target inode already locked via i_mutex i=
n
>>> ext4_llseek() before, this lock can prevent any modification to the
>>> file, and we call find_get_pages_tag() when trying to fetch the dir=
ty
>>> pages, this function using rcu read lock, it also safe to read. =A0=
So I
>>> have no idea what's wrong, could anyone please kindly point me out =
in
>>> this case? =A0I'm definitely a newbie to this list, sorry for my ig=
norant.
>> Ok. =A0There is no deadlock, fiemap releases i_data_sem before calli=
ng
>> get_delayed_extent().
>>
>> BTW: It seems that there is a bug in fiemap according to code, I am
>> not sure which commit introduced it, delayed extents beyond last
>> allocated block are ignored.
>
> Hmm... could you show me a bit more detailed info with the test scena=
rio
> if convenient? I can help testing, at least 3.1.0-rc2+ is works to me=
=2E
Could you test a file with map info like AAAADDDDDHHHHDDDD,
A-allocated block, D-deayed block, H-hole.  then filefrag -v and have
a look if extent map info is right.

Thanks,
Yongqiang.
>
> Also, upstream coreutils-cp(1) has been well tested for ext4, it coul=
d
> be used for fiemap tests based on the extent_scan module:
> http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/extent-scan.c=
?h=3Dnext&id=3Db56b53bd70b1f8fa2b5a95d4569bb72a2419b5cd
>
> Thanks,
> -Jeff
>
>>
>> Yongqiang.
>>>
>>> Anyway, I'd like to post the revised for your guys review first.
>>> In have split the modification to two patches this time, since I ho=
pe to
>>> make it looks more convenient for the review purpose.
>>>
>>> The 1st patch, remove the delayed-extents fetching procedure to a
>>> function named as get_delayed_extent(), and modify the
>>> ext4_ext_fiemap_cb() accordingly.
>>>
>>> The 2nd path add the ext4_ext_seek_cb() to implement the
>>> SEEK_HOLE/SEEK_DATA stuff based on previous code change.
>>>
>>> Testing:
>>> =3D=3D=3D=3D=3D=3D=3D=3D
>>> In addition to the test cases mentioned in V1, I also done another =
tests
>>> through sunil's seek test program, please refer to:
>>> http://oss.oracle.com/~smushran/seek_data/seek_test.c
>>>
>>> To ensure the 1st patch does not cause regression issue on fiemap, =
I
>>> have done some tests via cp(1) with fiemap copy support, the sparse=
 file
>>> used for this test is produced by:
>>> python -c "f=3Dopen('./sptest', 'w'); [(f.seek(x) or f.write(str(x)=
)) for
>>> x in range(1, 1000000000, 99999)]; f.close()
>>>
>>>
>>> Any feedback are appreciated!
>>>
>>>
>>> Thanks,
>>> -Jeff
>>>
>>
>>
>>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
