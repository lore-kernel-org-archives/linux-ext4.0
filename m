From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Mon, 01 Apr 2013 13:21:51 -0500
Message-ID: <5159D03F.5000606@redhat.com>
References: <51546EED.8030507@redhat.com> <5154AAB4.2000701@redhat.com> <5159A8D5.1000204@redhat.com> <20130401181718.GB22443@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab3DASWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 14:22:35 -0400
In-Reply-To: <20130401181718.GB22443@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/1/13 1:17 PM, Theodore Ts'o wrote:
> On Mon, Apr 01, 2013 at 10:33:41AM -0500, Eric Sandeen wrote:
>> +		/* Have we already started readdir on this dx dir? */
>> +		if (filp->private_data) {
>> +			err = -EINVAL;
>> +			goto hash32bits_out;
>> +		}
> 
> I'm not sure how much we care, but if filp->private_data is non-NULL
> and filp->f_pos == 0, then the application must have called
> rewinddir(), and at that point it would be fair game for us to free
> the rb_tree (see the code in ext4_dx_readdir() just after the comment
> "Some one has messed with f_pos; reset the world".)

Hm, I originally tested f_pos == 0, and Zach thought that wasn't the right
test, suggested f_private, and that seemed right to me, but yeah, I suppose
!f_pos && f_private means it got rewound.

> This would allow a bit more flexibility than just requiring that the
> ioctl be issued just after the opendir(), and allow it just after a
> call to rewinddir().

I guess I do wonder what real-world use that might have, though.

> This this would invalidate any previously issued telldir() cookies,
> but according to SuSv3, telldir() cookies are not guaranteed to be
> consistent after a rewinddir() or a closedir(), so it would be
> standards compliant to do this.

Well, could do.  Think it's worth it?

If so, then we could also allow flipping the flag on and off.
I suppose it's good to get the interface right to start with;
if we really want to be able to flip it on and off after a rewinddir,
then . . . ok, V4?  It's more flexible, but I don't know what the
usecase might be.

-Eric

> 						- Ted
> 

