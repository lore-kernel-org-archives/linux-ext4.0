From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 10:22:37 -0400
Message-ID: <20110509142237.GA19811@thunk.org>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
 <20110509135516.GJ4138@thunk.org>
 <20110509140537.GN4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36263 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1EIOWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:22:43 -0400
Content-Disposition: inline
In-Reply-To: <20110509140537.GN4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 04:05:37PM +0200, Jan Kara wrote:
>   Yes. ext4_append() can return ENOSPC and passed bh will get set to NULL
> without being marked dirty.

Ah, so the right fix then is to add to make the cleanup code like this:

		ext4_mark_inode_dirty(handle, dir);
		ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	        ext4_handle_dirty_metadata(handle, dir, bh2);
+		if (bh)
+			ext4_handle_dirty_metadata(handle, dir, bh);
		dx_release(frames);
		return retval;

Agreed?

						- Ted
