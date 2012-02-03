From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Delayed Extent Tree and Extent Lock Tree
Date: Fri, 3 Feb 2012 17:00:37 +0800
Message-ID: <CAGBYx2YemP=EMr-03MQBuS+yjzn6d6W1NEGesZHeXuV4Y=oWYg@mail.gmail.com>
References: <4F286C35.8080402@linux.vnet.ibm.com>
	<4F28E936.20303@tao.ma>
	<4F29B6E9.3060008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54194 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045Ab2BCJAi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 04:00:38 -0500
Received: by obcva7 with SMTP id va7so3947557obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2012 01:00:37 -0800 (PST)
In-Reply-To: <4F29B6E9.3060008@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 2, 2012 at 6:04 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 02/01/2012 12:26 AM, Tao Ma wrote:
>>
>> Hi Allison,
>> On 02/01/2012 06:33 AM, Allison Henderson wrote:
>>>
>>> Hi Yongqiang,
>>>
>>> I've have been working on an extent lock implementation that uses a=
n
>>> rbtree to keep track of locked extents, and I think I will probably=
 end
>>> up with a something similar to the tree that you've already set up =
for
>>> delayed extents. =A0So I wanted to send a note out to see what folk=
s would
>>> think about the idea of merging the two solutions.
>>>
>>> If we did this, the tree would get a little more complex in that it
>>> would have to keep track of more than just delayed extents. It woul=
d
>>> have to keep track of all extents and the processes that are waitin=
g on
>>> them. =A0So I guess it would kind of turn into an extent status tre=
e. =A0I
>>> also realize that some folks wanted to see range locks go into /lib=
 as
>>> general purpose code so that other filesystems or kernel code could=
 use
>>> it too, but the advantage to this approach would be one less tree f=
or
>>> ext4 to keep track of. =A0Any thoughts?
>>
>> We (Taobao) are very interested in this stuff and it should benefit
>> several of our workload(It is on our todo list for a long time). I g=
uess
>> Yongqiang's solution is a little bit limited to the only delayed ext=
ent
>> case, and your new solution at least has 2 more benefits:
>> 1. improve the direct i/o read/write
>> 2. speed up the extent search since now we only cache one in
>> ei_cached_extent.
>>
>> So please go ahead with your new solution. btw, do you have any time=
line
>> for it? We are glad to provide any help if needed.
>>
>> Thanks
>> Tao
>>
>
> Thx all for the feed back, it sounds like there will be a lot of bene=
fits to
> extending Yongqiang's delayed extent tree, so I will work on a soluti=
on
> based on that patch set. =A0Unfortunately though, I cannot give a tim=
e frame
> for this work item at the moment. =A0There are currently some other b=
usiness
> needs that may take priority over this one, and until those have been
> decided, I cannot make any promises at this point in time. =A0But I w=
ill work
> as quickly as I can with it since it is currently on my plate, and I =
will
> keep folks updated. =A0At the moment, feed back and guidance is most =
helpful
> to me. =A0Also, since the delayed extent solution is now a dependency=
 for my
> solution, anything to help get that reviewed and merged would help me=
 too.
> =A0Yongqiang, does the set still need review? =A0I think I recall Ted=
 saying it
It passed xfstests last year and I think you can go ahead on the set.
 It seems that your changes are a lot, so maybe we can merge the whole
set until your work is done.  At least, your work and the merging work
can be undertaken concurrently.

If you need any help,  I am available.

Yongqiang.
> was still on his list of things to look at. =A0Im sure I will give it=
 some
> good exercise here too. =A0Thx all for your help! =A0:)
>
> Allison Henderson
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
