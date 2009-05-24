From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 23:58:12 +0530
Message-ID: <20090524182812.GB3001@skywalker>
References: <bug-13369-13602@http.bugzilla.kernel.org/> <200905240252.n4O2qmEu012024@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49124 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZEXS2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 14:28:19 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4OIQ3D6015621
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 04:26:03 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4OISJft344170
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 04:28:20 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4OISJ8g000321
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 04:28:19 +1000
Content-Disposition: inline
In-Reply-To: <200905240252.n4O2qmEu012024@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 24, 2009 at 02:52:48AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13369
> 
> 
> Theodore Tso <tytso@mit.edu> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |tytso@mit.edu
> 
> 
> 
> 
> --- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-05-24 02:52:48 ---
> So I'm glad you're using a filesystem with a 1k blocksize since it provides a
> good test case for us --- and we don't do enough testing for the case where the
> blocksize != pagesize.   But you do realize that the ext4 filesystem will be
> far more efficient with the larger 4k blocksize, right?
> 
> I'm not able to reproduce the problem on a filesystem with 1k blocksize running
> fsx, fsstress, and dbench using a 2.6.30-rc6 kernel with the full ext4 patch
> queue, using a netbook with an dual-core N270 Atom processor.   I'm retrying
> with a stock 2.6.30-rc6 kernel now...
> 

It is with nodelalloc. I am also finding some unmapped buffer_heads in
nodelalloc mode with data=journal. See the latest update for bug

http://bugzilla.kernel.org/show_bug.cgi?id=12624

-aneesh
