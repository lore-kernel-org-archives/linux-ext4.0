From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: i_mutex questions
Date: Tue, 13 Sep 2011 22:23:50 -0600
Message-ID: <8548BAE6-6464-4F1B-BD25-5F395514D753@dilger.ca>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com> <CAGBYx2b9PjBHOeuQSsU8n5W=A+A7davW0Dw=QMjRdfh6aL7rBQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Zhen Liang <liang@whamcloud.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20759 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1INEXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 00:23:55 -0400
In-Reply-To: <CAGBYx2b9PjBHOeuQSsU8n5W=A+A7davW0Dw=QMjRdfh6aL7rBQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-13, at 7:29 PM, Yongqiang Yang wrote:
> On Wed, Sep 14, 2011 at 2:33 AM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> Hi All,
>> 
>> I have been trying to find a way to synchronize punch hole with read and
>> write operations with out the use of i_mutex.  The concern is that after
>> punch hole has released the pages inside the hole, another process may remap
>> the page to a block before punch has taken i_data_sem.  I think putting
>> i_mutex around the punch hole operation would fix this, but since we are
>> trying to avoid further improper use of i_mutex, I am trying to avoid that
>> solution.
>> 
>> I cannot use i_data_sem to protect the pages because it seems most of the
>> code has already established a locking order of pages first, then
>> i_data_sem.  So moving i_data_sem up tends to cause a lot of dead locks.
>>  I'm thinking that there probably needs to be a another mutex involved some
>> where, but I wasnt sure if some one is already working on the idea of
>> introducing a replacement for i_mutex.  So I just wanted to know if there
>> are any plans already in motion for this, or if any one else could suggest
>> some ideas for the punch hole issue.  Thx all!
> 
> Lukas sent out a patch ([PATCH] ext4: Make reads/writes atomic with
> i_rwlock semaphore) which collected some feedbacks suggesting using
> extent lock instead of a read-write semaphore.  If there is extent
> lock implementation in ext4, then fallocate can use it, maybe
> dioread-nolock can use it as well, e.g. locking a range and unlocking
> the range until the extent is converted from unwritten to init.

We have a prototype patch for extent locking for ext4.  We are planning to
use this for parallel locking of htree directories, but it could potentially
be modified to for extent locking of files.

The current patch is below, but it hasn't gone through a lot of testing:

http://review.whamcloud.com/#patch,sidebyside,375,2,ldiskfs/kernel_patches/patches/ext4_pdirop-rhel6.patch

Cheers, Andreas





