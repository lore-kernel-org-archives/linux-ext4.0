From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Ping.
Date: Thu, 15 Apr 2010 15:30:58 +0400
Message-ID: <87y6gp2brh.fsf@openvz.org>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
	<87ljd1vtth.fsf@openvz.org> <20100413181450.GA5720@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, adilger@sun.com, jack@suse.cz, david@fromorbit.com,
	viro@ZenIV.linux.org.uk, xemul@openvz.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100413181450.GA5720@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Apr 2010 14:14:50 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Apr 06, 2010 at 01:00:58PM +0400, Dmitry Monakhov wrote:
>> Dmitry Monakhov <dmonakhov@openvz.org> writes:
>> 
>> > This is 6'th version of extened inode owner patch-set.
>> > Please review it tell me what do you think about all this.
>> >  Are you agree with this approach?
>> >  Are you worry about some implementation details?
>> >  Is it ready for merge to some devel's tree?
>> Ping. I haven't got response about the patchset, just small note about
>> xattr-name from Andreas.
>> Please clarify what do you think about whole idea and
>> current patch-set state. What do i have to do to make a progress?
>
> As long as you still have the awkward ifdefs and different semantics for
About ifdefs style:
How can i avoid CONFIG_PROJECT_ID without bloating inode size?
embedded people will kill me for this.
I just act similar quota code, or you want protect prjid logic 
via quota config option?
I don't remember, are we already talk about this?
If so please remind me your vision.
> "isolation" vs "not"  there's still a NACK from me.  But in the end Al
> will have to decide if he wants to take your patches or not.
