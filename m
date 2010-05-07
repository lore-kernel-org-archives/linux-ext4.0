From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Fri, 07 May 2010 17:25:50 -0400
Message-ID: <4BE4855E.40808@redhat.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>	 <20100504224226.GE6344@thunk.org>	 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>	 <87vdaz21b0.fsf@basil.nowhere.org> <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@halobates.de>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0EGVZ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 May 2010 17:25:58 -0400
In-Reply-To: <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/07/2010 03:22 PM, Amir G. wrote:
> On Fri, May 7, 2010 at 5:12 PM, Andi Kleen wrote:
>    
>> "Amir G." writes:
>>      
>>> Yes, of course, I realize that. This is the reason I chose to
>>> introduce Next3 as a new f/s,
>>> which was branched from Ext3 and not as a new feature to Ext3.
>>> Unfortunately, merging Next3 snapshots feature into Ext4 is not an easy task,
>>> because extent mapped files break the design concepts of Next3 snapshots.
>>>        
>> As I understand it the ext4 code base still supports not having
>> extents enabled in the super block (although I'm not sure how well
>> that variant is tested in practice)
>>
>> So in theory you could have a feature that requires disabling extents.
>>
>> It might not make users very happy though.
>>
>>      
> In theory, it is possible to have 2 modes for Ext4 (extents or snapshots)
> and some would argue that it makes sense to do that.
> But I think that making that decision can be deferred to a later time,
> after people have experienced with Next3 and have decided if they
> would like to have
> the snapshot feature merged into Ext4 or not.
>
> Besides, it would take me a considerable amount of time to merge the
> snapshot feature into Ext4,
> and Next3 is ready to be used now.
>
> Amir.
> --
>    

I think that the counter argument would be that moving features into 
ext3 is probably the wrong thing to do.

I don't think that anyone is in a huge hurry given that we have LVM 
based snapshots with ext3 and btrfs snapshots around the corner.  
Probably this is most interesting when done to the latest version of the 
ext family.

Best regards,

Ric

