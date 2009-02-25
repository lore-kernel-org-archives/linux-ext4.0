From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Simple inode question (ext2/3)
Date: Wed, 25 Feb 2009 09:10:02 -0500
Message-ID: <87f94c370902250610u3f5929b1i9e56000e7bcdb44a@mail.gmail.com>
References: <20090224210515.GA7064@mit.edu>
	 <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk>
	 <20090225040654.GT3199@webber.adilger.int>
	 <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:21774 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZBYOKF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 09:10:05 -0500
Received: by qw-out-2122.google.com with SMTP id 5so60357qwi.37
        for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 06:10:02 -0800 (PST)
In-Reply-To: <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 5:59 AM, Felipe Franciosi <ozzy@doc.ic.ac.uk> wrote:

>
> As a matter of fact, I didn't see any critics to the question below. I can
> only assume that messing with inodes can look academic or not depending on
> the phase of the moon or something.
>
> ------------------8<------------------
> On 6 Jan 2009, at 10:36, Rohit Sharma wrote:
>>
>> I want to read data blocks from one inode
>> and copy it to other inode.
>>
>> I mean to copy data from data blocks associated with one inode
>> to the data blocks associated with other inode.
>>
>> Is that possible in kernel space.?
>> --

By chance that question was also asked on the kernelnewbies list.

The first responses there were also of the form "Why do you want to do that?"

FYI: It started a very long thread discussing what they were actually
doing. (This was part of the OHSM project that has been mentioned here
a couple times.)  It was eventually determined the proposed
online_defrag patchset was very similar to their need.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
