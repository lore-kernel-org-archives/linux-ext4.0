From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
 ext4_forget()
Date: Mon, 16 Nov 2009 12:31:46 +0530
Message-ID: <20091116070146.GA8600@skywalker.linux.vnet.ibm.com>
References: <20091114232912.GF4221@mit.edu>
 <1258245059-17687-1-git-send-email-tytso@mit.edu>
 <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
 <20091115204346.GE4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46007 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZKPHBq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 02:01:46 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp04.in.ibm.com (8.14.3/8.13.1) with ESMTP id nAG71n1q027891
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 12:31:49 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAG71mLv1700012
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 12:31:48 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nAG71m6x007345
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 12:31:48 +0530
Content-Disposition: inline
In-Reply-To: <20091115204346.GE4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 03:43:46PM -0500, Theodore Tso wrote:
> On Sun, Nov 15, 2009 at 12:34:48PM +0530, Aneesh Kumar K.V wrote:
> > 
> > I guess we need to make sure we call ext4_forget with correct
> > is_metadata values. I did the below patch. The xattr changes in the
> > patch should be split as a separate one.  I am not sure why we do a
> > get_bh there.
> 
> It doesn't hurt to call ext4_forget() with the correct values, but I
> figured it was easier just to make ext4_forget() DTRT thing by
> checking the inode type since it has access to i_mode.  My patch
> didn't take into account symlinks, though.   Good catch on your part.


May be you want to merge the ext4_remove_blocks changes also. That make
sure anybody reading code doesn't have to spent time in figuring out
why ext4_forget is called with metadata = 0 and ext4_free_blocks is called
with metadata = 1.

-aneesh

