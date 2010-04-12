From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative metadata blocks
Date: Mon, 12 Apr 2010 17:52:53 +0400
Message-ID: <87633whj62.fsf@openvz.org>
References: <4BBCFD10.3030504@redhat.com> <87sk76tkx9.fsf@openvz.org>
	<4BBDF610.8030906@redhat.com> <87eiimtjne.fsf@openvz.org>
	<20100412131530.GB12238@atrey.karlin.mff.cuni.cz>
	<87iq7whk2t.fsf@openvz.org> <20100412134228.GL1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:15399 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0DLNxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 09:53:34 -0400
In-Reply-To: <20100412134228.GL1849@thunk.org> (tytso@mit.edu's message of
	"Mon, 12 Apr 2010 09:42:28 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Mon, Apr 12, 2010 at 05:33:14PM +0400, Dmitry Monakhov wrote:
>> BTW I'm too familiar with cross-devel-tree process
>> If tytso@ will get the patchset will you get an quota-related patches
>> to linux-fs tree too? Otherwise everybody have to wait for ext4-tree
>> push to linus's tree and when to linux-fs.
>
> I've already asked Jan if he would mind my carrying the quota patches
> in the ext4 tree, since I believe there's less chance of patch
> collisions with upcoming changes in the quota tree than if they were
> carried in the quota tree and we had to worry about changes to the
> ext4 tree.
Yess. i do understand that both interesting in common quota-related peace.
>
> These patches are also low-risk enough (they'll either work or they
> won't, and it's not hard to desk-check them for correctness) that we
> could push them to Linus now before the merge window, and see if he's
> willing to take them.  I have some data corruption bugfixes I need to
> push to Linus anyway....  I dunno if Linus will be willing to take
> them, but that's the other approach.
>
> 					- Ted
Both options is too complex (as least for my tiny brain)
Is is possible to accept quota related patches in both(linux-fs and
ext4) tires at least in for-next branches. Seems that git is able to
detect equivalent patches via cherry-picking-like mechanisms.
