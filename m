From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Thu, 7 Jul 2011 20:46:54 -0600
Message-ID: <7AE9DA58-62BA-4FE9-B4C0-AEB6D46DB096@dilger.ca>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <4E14CE15.90404@linux.vnet.ibm.com> <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com> <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca> <4E1614C1.1050209@linux.vnet.ibm.com> <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3449 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1GHCqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2011 22:46:55 -0400
In-Reply-To: <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-07, at 6:09 PM, Amir Goldstein wrote:
> On Thu, Jul 7, 2011 at 11:19 PM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> 
>> Ah, ok then.  Yes, part of the requirements was to make secure delete work
>> for partial truncates, punch hole, and also indexed files.  So that will
>> save me some time if I can get the migrate routines work.  Thx for the
>> pointers all!
> 
> I realized that there is a basic flaw in the concept of deferred-secure-delete.
> From a security point of view, after a crash during a secure-delete,
> if the file is not there, all its data should have been wiped.
> Orphan cleanup on the next mount may be done on a system that
> doesn't respect secure delete.
> So for real security, the unlink/truncate command cannot return before
> all data is wiped.

I don't necessarily agree.  People who are using secure delete don't
necessarily want their performance to go into the toilet, which is what
would happen if each unlink/zero happened sequentially.  It is far more
efficient to submit a large batch of unlink/zero operations and then do
an sync() or fsync() at the end.  This allows multiple journal operations
to be coalesced (e.g. unlinks from directory) and block zero requests to
be merged.

> The unlink/truncate metadata changes must not even be committed
> before all data is wiped (or at least part of the data with partial truncate).

That depends on the user, I think.  If someone does "rm -r {dir}" it may
be better that the files are removed from the namespace more quickly, and
secure deleted (in a batch) more quickly, than having "rm" wait for each
file to be unlinked and maybe leave files in the namespace that didn't
even get a chance to be unlinked.

Cheers, Andreas





