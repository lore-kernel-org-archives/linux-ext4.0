From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Sun, 10 Jul 2011 19:33:07 -0400
Message-ID: <20110710233307.GE5615@thunk.org>
References: <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
 <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
 <4E14CE15.90404@linux.vnet.ibm.com>
 <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
 <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
 <4E1614C1.1050209@linux.vnet.ibm.com>
 <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
 <1310149225.2970.2.camel@mingming-laptop>
 <507FA19B-1395-4237-98BF-7CD65F80A120@dilger.ca>
 <4E1960AE.1020707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60794 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab1GJXdQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 19:33:16 -0400
Content-Disposition: inline
In-Reply-To: <4E1960AE.1020707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 10, 2011 at 09:19:58AM +0100, Ric Wheeler wrote:
> Just to wrap up this thread, I will throw out some of the use cases
> that I have seen....

Unless we clearly articulate what use case we are hoping to address, I
have to admit I'm a little dubious about whether it's worth it to add
"secure delete".  There are plenty of other solutions, including
user-space shred, destruction of an encryption key, etc.  All of these
solutions have tradeoffs between performance and security.

So if we're going to implement something, we should think very
carefully about what problem we are hoping to solve, and what sort of
adversaries/threat environment where we'd think this would be useful.

I'll observe that in many cases, where you have the sweating Enron
executive trying to destroy evidence, they're going to be thwarted by
automatic backup policies.  This is also true BTW if you're worried
about employment records --- and pawing through several terabytes of
backup tapes to delete (only) the employee records for L=E9o Apotheker
Platner after he resigned from SAG AG would really be unpleasant.  :-)

And of course, if you are using devices such as SSD's or
thin-provisioned devices, file-system level erasure may not really do
a lot of your anyway, even if you are using discard.

So --- does anyone have some thoughts about how this would actually
used by potential customers?  If not, my vote would be to keep things
as simple as possible, and if it's too complicated, to think carefully
about whether it's worth it to (re)-add this feature.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
