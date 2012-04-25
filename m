From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Wed, 25 Apr 2012 10:36:36 -0500
Message-ID: <4F981A04.1090802@redhat.com>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com> <4F971602.7090005@itwm.fraunhofer.de> <C53AC043-C67D-44DD-9A11-3A196627668A@whamcloud.com> <4F9812C7.3020300@redhat.com> <4F981458.1010708@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org,
	Fan Yong <yong.fan@whamcloud.com>, bfields@redhat.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2DYPgl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Apr 2012 11:36:41 -0400
In-Reply-To: <4F981458.1010708@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/25/12 10:12 AM, Bernd Schubert wrote:
> On 04/25/2012 05:05 PM, Eric Sandeen wrote:
>> On 4/24/12 5:24 PM, Andreas Dilger wrote:
>>> On 2012-04-24, at 4:07 PM, Bernd Schubert wrote:
>>>>> 1) For SEEK_END, we now return -EINVAL for a positive offset
>>>>> (i.e. past EOF)
>>>> 
>>>> I definitely introduces that one, as I cannot see how an
>>>> application might ever run into it. Especially as ext4
>>>> directories cannot shrink. So if an application tries to exceed
>>>> the directory size limit, it looks to me as some of attempt to
>>>> break something or as an error in the application. However, if
>>>> there should be the slightest chance to break existing
>>>> applications relying on that, we need to remove that.
>>> 
>>> I think the other reason to avoid SEEK_END + n is that since
>>> SEEK_END for a hash offset is (signed) MAX_LONG, so if one seeks
>>> beyond that it will wrap to a negative offset.
>> 
>> Makes sense.
>> 
>> Wishing this had been done as a separate patch, though, since it's
>> really addressing a separate issue from the $SUBJECT, and could
>> have used specific documentation of the change.  Nitpicky I know,
>> but it helps.
> 
> Sorry, my fault. 

No worries, I should have reviewed sooner too :)

> Maybe we should simply document it in the code? And
> how do we proceed in general. Shall I write a patch to use
> generic_file_llseek() and update that function to take more
> arguments? I don't think that would go into 3.4.

Unless there is obviously _wrong_ behavior to be fixed I don't think it's needed for 3.4.

We could maybe do one patch to make it lockless again, if there's good confidence in that, since it's sort of a "regression."

Trying to munge things into the upstream seek function would be post-3.4, I'm sure, if it turns out it can be done at all.

Thanks,
-Eric

> Thanks, Bernd

