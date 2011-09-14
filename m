From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: i_mutex questions
Date: Wed, 14 Sep 2011 11:36:02 -0700
Message-ID: <4E70F412.3040008@linux.vnet.ibm.com>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com> <CAGBYx2b9PjBHOeuQSsU8n5W=A+A7davW0Dw=QMjRdfh6aL7rBQ@mail.gmail.com> <8548BAE6-6464-4F1B-BD25-5F395514D753@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Zhen Liang <liang@whamcloud.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38952 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab1INSgK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 14:36:10 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8EIBxQv001763
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 14:11:59 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8EIa8WQ3297504
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 14:36:08 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8EIa7Io014429
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 14:36:08 -0400
In-Reply-To: <8548BAE6-6464-4F1B-BD25-5F395514D753@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/13/2011 09:23 PM, Andreas Dilger wrote:
> On 2011-09-13, at 7:29 PM, Yongqiang Yang wrote:
>> On Wed, Sep 14, 2011 at 2:33 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com>  wrote:
>>> Hi All,
>>>
>>> I have been trying to find a way to synchronize punch hole with read and
>>> write operations with out the use of i_mutex.  The concern is that after
>>> punch hole has released the pages inside the hole, another process may remap
>>> the page to a block before punch has taken i_data_sem.  I think putting
>>> i_mutex around the punch hole operation would fix this, but since we are
>>> trying to avoid further improper use of i_mutex, I am trying to avoid that
>>> solution.
>>>
>>> I cannot use i_data_sem to protect the pages because it seems most of the
>>> code has already established a locking order of pages first, then
>>> i_data_sem.  So moving i_data_sem up tends to cause a lot of dead locks.
>>>   I'm thinking that there probably needs to be a another mutex involved some
>>> where, but I wasnt sure if some one is already working on the idea of
>>> introducing a replacement for i_mutex.  So I just wanted to know if there
>>> are any plans already in motion for this, or if any one else could suggest
>>> some ideas for the punch hole issue.  Thx all!
>>
>> Lukas sent out a patch ([PATCH] ext4: Make reads/writes atomic with
>> i_rwlock semaphore) which collected some feedbacks suggesting using
>> extent lock instead of a read-write semaphore.  If there is extent
>> lock implementation in ext4, then fallocate can use it, maybe
>> dioread-nolock can use it as well, e.g. locking a range and unlocking
>> the range until the extent is converted from unwritten to init.
>
> We have a prototype patch for extent locking for ext4.  We are planning to
> use this for parallel locking of htree directories, but it could potentially
> be modified to for extent locking of files.
>
> The current patch is below, but it hasn't gone through a lot of testing:
>
> http://review.whamcloud.com/#patch,sidebyside,375,2,ldiskfs/kernel_patches/patches/ext4_pdirop-rhel6.patch
>
> Cheers, Andreas
>

Alrighty then, I will have a look at the existing patches.  Thx!

Allison Henderson

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

