From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: Re: [PATCH V5 1/5] quota: Add reservation support for delayed	block
 allocation
Date: Tue, 03 Feb 2009 15:11:00 +0800
Message-ID: <4987EE04.4020506@cn.fujitsu.com>
References: <1231216808.9267.22.camel@mingming-laptop>	 <20090106100645.GH10705@duck.suse.cz>	 <1231805946.6752.17.camel@mingming-laptop>	 <20090113153748.GE10064@duck.suse.cz>	 <1231872797.8719.6.camel@mingming-laptop>	 <20090113190931.GI10064@duck.suse.cz> <1231893775.8719.22.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZBCHNU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 02:13:20 -0500
In-Reply-To: <1231893775.8719.22.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi mingming=EF=BC=9A
I have tested your patch in 2.6.29-rc1. The sum of characters which=20
i had written were fewer than the block softlimit,but a warning occurs.

# edquota -u quser1
Disk quotas for user quser1 (uid 504):
  Filesystem                   blocks       soft       hard     inodes =
    soft     hard
  /dev/sda7                         0          5         10          0 =
       5       10

Steps to reproduce:

# mkfs.ext4 /dev/sda7
# mount /dev/sda7 /mnt -t ext4
# setquota -u quser1 5 10 5 10 /mnt

Then log in as quser1
$ cd /mnt
$ ll
total 20
-rw------- 1 root root  7168 01-20 01:51 aquota.user
drwx------ 2 root root 12288 01-20 01:44 lost+found
$ vim dd.sh

I written some characters,such as abc,then i do wq,
the warning occurs likes below:
"dd.sh" sda7: write failed, user block limit reached.

Mingming Cao =E5=86=99=E9=81=93:
> =E5=9C=A8 2009-01-13=E4=BA=8C=E7=9A=84 20:09 +0100=EF=BC=8CJan Kara=E5=
=86=99=E9=81=93=EF=BC=9A
>> On Tue 13-01-09 10:53:17, Mingming Cao wrote:
>>> =E5=9C=A8 2009-01-13=E4=BA=8C=E7=9A=84 16:37 +0100=EF=BC=8CJan Kara=
=E5=86=99=E9=81=93=EF=BC=9A
>>>> On Mon 12-01-09 16:19:06, Mingming Cao wrote:
>>>>> Thanks for your review and suggestions. All points are taken. I h=
ave
>>>>> updated the quota patches.I am attaching the updated patch here j=
ust for
>>>>> your review.
>>>>>
>>>>> I am waiting for the ext4 tree to updated to rebase the whole ser=
ies
>>>>> against 2.6.29-rc1 plus ext4 patch queue. =20
>>>>>
>>>>   <snip>
>>>>> Quota: Add quota reservation support
>>>>>
>>>>> Delayed allocation defers the block allocation at the dirty pages
>>>>> flush-out time, doing quota charge/check at that time is too late=
=2E
>>>>> But we can't charge the quota blocks until blocks are really allo=
cated,
>>>>> otherwise users could get overcharged after reboot from system cr=
ash.
>>>>>
>>>>> This patch adds quota reservation for delayed llocation. Quota bl=
ocks
>>>>> are reserved in memory, inode and quota won't gets dirtied until =
later
>>>>> block allocation time.
>>>>>
>>>>> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>>>>   The patch is fine. You can add
>>>>
>>>>   Acked-by: Jan Kara <jack@suse.cz>
>>>>
>>>>   How do you want to merge the patches? Via ext4 patch queue?
>>>> There's one generic quota patch that I also need to push to fix so=
me OCFS2
>>>> issue and it collides with your patchset. And also there're furthe=
r
>>>> cleanups in quota code which are long overdue which I want to base=
 on all
>>>> other patches. So I've decided to setup quota git tree. I'll pull =
in your
>>>> two VFS quota patches. Will that work for you?
>>> I think a quota tree is the best place to hold all these quota chan=
ges.
>>> The ext4 part probably make sense to stay together with the vfs cha=
nges,
>>> but it will need to coordinate with Ted's ext4 tree.  Ted, what do =
you
>>> think?
>>   Yes. The best would be if could pull quota changes from my tree bu=
t you
>> could also just carry your two patches and only leave merging them w=
ith
>> vanilla to me.
>>
> Sure, that works for me.
>=20
>>> BTW, there are other two quota cleanup patches that you have alread=
y
>>> acked. I will sent the 2.6.29-rc1 based version.
>>   Yes. Thanks.
>>
>=20
> Attached are all the 5 2.6.29-rc1 based patches, including the two
> cleanups.
>=20
> Thanks!
>=20
> Mingming
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
