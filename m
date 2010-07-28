From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: disallow FS recursion from sb_issue_discard allocation
Date: Wed, 28 Jul 2010 20:12:15 +0200
Message-ID: <4C5072FF.6010009@fusionio.com>
References: <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com> <20100702181430.GD26916@redhat.com> <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com> <20100706161155.GA24461@redhat.com> <20100727134414.GC18966@thunk.org> <20100727153352.GA5574@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Mikulas Patocka <mpatocka@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100727153352.GA5574@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/27/2010 05:33 PM, Mike Snitzer wrote:
> On Tue, Jul 27 2010 at  9:44am -0400,
> Ted Ts'o <tytso@mit.edu> wrote:
> 
>> On Tue, Jul 06, 2010 at 12:11:56PM -0400, Mike Snitzer wrote:
>>> Filesystems can call sb_issue_discard on a memory reclaim path
>>> (e.g. ext4 calls sb_issue_discard during journal commit).
>>>
>>> Use GFP_NOFS in sb_issue_discard to avoid recursing back into the FS.
>>>
>>> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>>
>> Hi Jens,
>>
>> I never saw an ack from you on this patch.  Are you ok with it, and
>> have you grabbed it for your tree?  Do you want me to include this in
>> the ext4 tree, even though it's a patch to include/linux/blkdev.h?
> 
> Hi Ted,
> 
> Thanks for following up on this.  In my experience, Jens is more apt to
> pick up a patch if it gets explicitly 'Acked-by' other stake-holders
> (especially when a patch is motivated by another subsystem, in this case
> the proposed block change addresses a problem unique to fs/ext4).

I'll pick this up. I've been away for a few weeks and I'm currently
on vacation, but I'll push this with a few other pending patches
for .35 on monday.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
