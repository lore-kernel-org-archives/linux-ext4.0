From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the
 inode table
Date: Tue, 23 Sep 2008 10:16:13 +0100
Message-ID: <20080923101613.58768083@lxorguk.ukuu.org.uk>
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52315 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbYIWJQh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2008 05:16:37 -0400
In-Reply-To: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 22 Sep 2008 20:35:23 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> 
> With modern hard drives, reading 64k takes roughly the same time as
> reading a 4k block.  So request adjacent inode table blocks to reduce
> the time it takes when iterating over directories (especially when doing
> this in htree sort order) in a cold cache case.  With this patch, the
> time it takes to run "git status" on a kernel tree after flushing the
> caches via "echo 3 > /proc/sys/vm/drop_caches", is reduced by 21%.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: Alan Cox <alan@redhat.com>

I'm actually suprised that 16 is the magic tuning number you've used and
a bigger one isn't even more of a win

Alan
