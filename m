From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group
 descriptor
Date: Thu, 15 Sep 2011 10:21:37 -0400
Message-ID: <20110915142137.GH15782@thunk.org>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
 <99156E1E-97E0-4165-B5E3-D54004846F95@dilger.ca>
 <CAOQ4uxgCqTEMBha-13aLy5mKExquK=3Ma5LheqKaPBzCo3PRCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42418 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1IOOVt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 10:21:49 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgCqTEMBha-13aLy5mKExquK=3Ma5LheqKaPBzCo3PRCw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 05:03:37PM +0300, Amir Goldstein wrote:
> > I'd prefer if these comments were "Snapshot exclude bitmap block" so
> > that it is more clear what an exclude bitmap is used for.
> 
> I'll change that.

I'll be sending out a combined patch very shortly which adds the
necessary fields for the snapshot and metadata checksum fields.  I
just want to make sure we're all on the same page about reserved
fields as far as the on-disk format is concerned.

> >
> > For consistency, it would also be good to name these "_lo" to match the
> > kernel fields.
> >
> 
> That's a major cleanup.
> Forgive me for not picking up that glove...

One way of handling these sorts of cleanups is to make the change in
the header file, and then do something like this:

#define bg_exclude_bitmap   bg_exclude_bitmap_lo

Then once you add the accessor functions to set/get the
exclude_bitmap, you can delete the #define to make sure you fixed up
all of your code to actually use the accessor functions.

       	    	    	     	     	      - Ted
