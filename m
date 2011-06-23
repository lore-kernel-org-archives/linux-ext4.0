From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: 	Repeatable
 "kernel BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Thu, 23 Jun 2011 18:23:30 -0400
Message-ID: <20110623222330.GC3064@thunk.org>
References: <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
 <20110403020227.GA19963@thunk.org>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <20110405001542.GE2832@thunk.org>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <20110405190738.GF2832@thunk.org>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49710 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082Ab1FWWXi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jun 2011 18:23:38 -0400
Content-Disposition: inline
In-Reply-To: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2011 at 01:32:48PM -0500, Moffett, Kyle D wrote:
> 
> Ted, since this new iteration has no customer data, passwords, keys, or
> any other private data, I'm going to try to get approval to release an
> exact EC2 image of this system for you to test with, including the fake
> data volume that I triggered the problem on.

That would be great!  Approximately how big are the images involved?

     	      	      		    	    - Ted
