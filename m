From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: proposed ext4 test matrix
Date: Mon, 16 May 2011 18:35:59 -0700
Message-ID: <1305596159.9671.8.camel@keith-laptop>
References: <E1QM1uy-00070D-KR@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:48394 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1EQBgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 21:36:16 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4H1JkId005651
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 19:19:46 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p4H1a36W150082
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 19:36:03 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4GJa2gG023207
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 13:36:02 -0600
In-Reply-To: <E1QM1uy-00070D-KR@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2011-05-16 at 13:49 -0400, Theodore Ts'o wrote:
> Per the discusison on the ext4 concall, here's a proposed ext4 test
> matrix.
> 
> 						- Ted
> 
> P.S.  There was something else I said I would send out, but I didn't
> write it down and I can't remember what it was.  Can someone remind me?
> Thanks!!
> 
> 
> 4k blocksize, no journal, nodealloc, noextents (ext2)
> 1k blocksize, no journal, nodealloc, noextents (ext2)
> 4k blocksize, journal, nodealloc, noextents (ext3)
> 1k blocksize, journal, nodealloc, noextents (ext3)
> 4k blocksize, journal, delalloc, extents
> 1k blocksize, journal, delalloc, extents
> 4k blocksize, nojournal, delalloc, extents
> 4k blocksize, journal, 64bits(*), delalloc, extents
> 1k blocksize, journal, 64bits(*), delalloc, extents
> 4k blocksize, nojournal, 64bits(*), delalloc, extents
> 4k blocksize, journal, delalloc, extents, quota enabled
> 1k blocksize, journal, delalloc, extents, quota enabled


What tests are we wanting to run? 

  Keith Mannthey
  LTC Filesystems 

