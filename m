From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Tue, 29 Jul 2008 22:03:38 -0500
Message-ID: <488FDA0A.5020408@redhat.com>
References: <bug-11175-27@http.bugzilla.kernel.org/> <20080729171207.d88728cf.akpm@linux-foundation.org> <20080730024856.GE29748@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	kernel.bugzilla@asheesh.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYG3DDs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 23:03:48 -0400
In-Reply-To: <20080730024856.GE29748@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Hmm... disassembling the code, it's pretty clear the problem is here
> in do_split(), around line 1208:
> 
> 	map = (struct dx_map_entry *) (data2 + blocksize);
> 	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
> 			     blocksize, hinfo, map);
> 	map -= count;
> 	dx_sort_map (map, count);
> 	/* Split the existing block in the middle, size-wise */
> 	size = 0;
> 	move = 0;
> 	for (i = count-1; i >= 0; i--) {
> 		/* is more than half of this entry in 2nd half of the block? */
> 		if (size + map[i].size/2 > blocksize/2)  <====

You sure this isn't our old friend
https://bugzilla.redhat.com/show_bug.cgi?id=451068 ?

which version of gcc compiled this?

-Eric
