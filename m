From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Mon, 11 Jul 2011 10:20:41 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1107111003170.3688@dhcp-27-109.brq.redhat.com>
References: <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <4E14CE15.90404@linux.vnet.ibm.com> <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
 <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca> <4E1614C1.1050209@linux.vnet.ibm.com> <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com> <1310149225.2970.2.camel@mingming-laptop> <507FA19B-1395-4237-98BF-7CD65F80A120@dilger.ca>
 <4E1960AE.1020707@redhat.com> <20110710233307.GE5615@thunk.org> <4E1A9B43.8020800@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-915444491-1310372445=:3688"
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1GKIUu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 04:20:50 -0400
In-Reply-To: <4E1A9B43.8020800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-915444491-1310372445=:3688
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 11 Jul 2011, Ric Wheeler wrote:

> On 07/11/2011 12:33 AM, Ted Ts'o wrote:
> > On Sun, Jul 10, 2011 at 09:19:58AM +0100, Ric Wheeler wrote:
> > > Just to wrap up this thread, I will throw out some of the use cases
> > > that I have seen....
> > Unless we clearly articulate what use case we are hoping to address, I
> > have to admit I'm a little dubious about whether it's worth it to add
> > "secure delete".  There are plenty of other solutions, including
> > user-space shred, destruction of an encryption key, etc.  All of these
> > solutions have tradeoffs between performance and security.
> > 
> > So if we're going to implement something, we should think very
> > carefully about what problem we are hoping to solve, and what sort of
> > adversaries/threat environment where we'd think this would be useful.
> > 
> > I'll observe that in many cases, where you have the sweating Enron
> > executive trying to destroy evidence, they're going to be thwarted by
> > automatic backup policies.  This is also true BTW if you're worried
> > about employment records --- and pawing through several terabytes of
> > backup tapes to delete (only) the employee records for Léo Apotheker
> > Platner after he resigned from SAG AG would really be unpleasant.  :-)
> > 
> > And of course, if you are using devices such as SSD's or
> > thin-provisioned devices, file-system level erasure may not really do
> > a lot of your anyway, even if you are using discard.
> > 
> > So --- does anyone have some thoughts about how this would actually
> > used by potential customers?  If not, my vote would be to keep things
> > as simple as possible, and if it's too complicated, to think carefully
> > about whether it's worth it to (re)-add this feature.
> > 
> > 					- Ted
> 
> I do think that the synchronous secure delete is useful to have, even if slow.
> 
> That said, as you point out, there are lots of ways that this will fail
> potentially, including:
> 
> * you might have copied a file or had blocks paged out that leave a "ghost"
> trace
> 
> * a simple secure delete that overwrites with zeros is not "sufficient" to
> erase tracks for some users (look at the multi-pass options shred does for
> example)
> 
> * ssd's or other devices do wear levelling and move data around internally so
> you might be able to rip the device apart and look at the raw flash and
> recover data

This is my concern as well. Allison I think that if you are going to do
next spin of the patches it would be nice to detect whether the device
supports secure discard or at least regular discard is zeroing the data,
because otherwise just plain overwrite with zeroes is not going to help
at all. SSD will use some other blocks and the data will be still there,
so there is no point in doing overwrite.

However if you do use discard (not sure what secure discard is actually
doing) then you're still not guaranteed to have everything wiped out,
because there might still be some parts of the file in other places of
the device due the previous rewrites. You'll have to use fitrim to get
rid of the other parts, but still there might be some data left in the
user restricted area of the device which the fw uses for better wear-
leveling.

Thanks!
-Lukas

> 
> That said, for all normal users, I do think that the zero out is still useful
> and reasonable.  The simple goal is that once securely deleting, your sys
> admin cannot use recovery tools or scan a block device and see your deleted
> file's data blocks.
> 
> Ric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--8323328-915444491-1310372445=:3688--
