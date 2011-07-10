From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Sun, 10 Jul 2011 09:19:58 +0100
Message-ID: <4E1960AE.1020707@redhat.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <4E14CE15.90404@linux.vnet.ibm.com> <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com> <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca> <4E1614C1.1050209@linux.vnet.ibm.com> <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com> <1310149225.2970.2.camel@mingming-laptop> <507FA19B-1395-4237-98BF-7CD65F80A120@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Amir Goldstein <amir73il@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1GJIUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 04:20:10 -0400
In-Reply-To: <507FA19B-1395-4237-98BF-7CD65F80A120@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/09/2011 12:49 AM, Andreas Dilger wrote:
> On 2011-07-08, at 12:20 PM, Mingming Cao wrote:
>> On Fri, 2011-07-08 at 03:09 +0300, Amir Goldstein wrote:
>>> I realized that there is a basic flaw in the concept of deferred-secure-delete.
>>>  From a security point of view, after a crash during a secure-delete,
>>> if the file is not there, all its data should have been wiped.
>>> Orphan cleanup on the next mount may be done on a system that
>>> doesn't respect secure delete.
>>> So for real security, the unlink/truncate command cannot return before
>>> all data is wiped.
>> I agree. I think the user who expect secure delete will be expecting the
>> data being completely wiped off from disk, instead of wondering when the
>> OS/fs will really get rid of the data on the hidden inode by background
>> thread.  Secure delete should be synchronous.
> I'm not going to argue further for async secure delete, but just wanted
> to point out that userspace can determine when the "shred" is safely done
> on disk (or any other operation for that matter) by doing a sync afterward.
> It wouldn't have to "wonder" about anything.
>
> My original proposal for using the delete thread included having sync()
> block until all of the background secure unlink/overwrite operations were
> finished.  That would allow deleting many files at one time, and then
> sending all of the requests to the disk more efficiently.
>
>
> I am just imagining some Enron accountant sweating for hours as his sync
> secure-delete is running at 50-100 files/sec (seek limit if there are
> 1 or 2 seeks/file) on a filesystem with 1M files in it, instead of being
> able to delete 50000 files/sec asynchronously and wait a few minutes at
> the end as the sync completes. ;-)
>
> A better solution is to just encrypt the data with a per-inode key and
> then just overwrite the inode securely when it is unlinked, so when the
> key is erased the data is unrecoverable.  I imagine that ecryptfs or
> similar might do something like that (I don't know much about it, honestly).
>
>
> Note that this should probably get an EXT4_FEATURE_COMPAT_SECDEL flag, so
> e2fsck knows to also wipe secure-delete files when they are unlinked due
> to inode corruption, or similar.
>
> This reminds me I also have an e2fsck patch that we've been carrying for a
> few years for shared block handling that allows e2fsck to optionally move
> inodes to lost+found, delete them, or wipe the shared blocks option.  This
> is necessary to avoid data leakage between users in case there is some
> corruption that links one user's inode to another user's blocks.  I'll send
> that in another email.
>
> Cheers, Andreas
>

Just to wrap up this thread, I will throw out some of the use cases that I have 
seen:

(1) In some parts of the world, an employer has a hard requirement to eliminate 
records in so many days after termination for any reason (the EU iirc)

(2) legal or data retention requirements. Sarbanes/Oxley (aka SOX) in the US 
requires firms to retain data on trades for a specified amount of days. In a 
similar way, email is often required to be retained during any legal proceedings

(3) "Scrubbing" a whole disk of data before an upgrade/return to the vendor 
(usually done by wiping disks, not removing/scrubbing individual files).

As you point out, performance is a critical aspect of several of these use 
cases. Imagine the shifty trader watching the clock to see when they can start 
deleting electronic evidence of shady trades :)  That said, the promise has to 
be that there is no shadow of data left on disk (even after a crash or recovery).

I think that the synchronous method is the easy and obvious way to do this for 
most use cases, but as you say, you can always use "shred" from user space to do 
something a bit different....

Ric


