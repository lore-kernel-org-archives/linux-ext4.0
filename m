From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 5/7] mke2fs: proceed if the user doesn't type anything
 after 5 seconds
Date: Wed, 30 Apr 2014 08:53:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404300849050.2671@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-5-git-send-email-tytso@mit.edu> <535E74D4.4050805@redhat.com> <20140428232634.GD7857@thunk.org> <535EF317.7050102@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaD3GxX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 02:53:23 -0400
In-Reply-To: <535EF317.7050102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Apr 2014, Eric Sandeen wrote:

> Date: Mon, 28 Apr 2014 19:32:23 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 5/7] mke2fs: proceed if the user doesn't type anything
>     after 5 seconds
> 
> On 4/28/14, 6:26 PM, Theodore Ts'o wrote:
> > On Mon, Apr 28, 2014 at 10:33:40AM -0500, Eric Sandeen wrote:
> >> On 4/26/14, 7:00 PM, Theodore Ts'o wrote:
> >>> If mke2fs needs to ask the user for permission, and the user doesn't
> >>> type anything for five seconds, proceed as if the user had said yes.
> >>>
> >>> This will allow us to add more stringent checks without breaking
> >>> existing scripts (much).
> >>
> >> Hm, this sounds a little dangerous - "-F" overrides a lot.
> > 
> > Actually, if you take a look at what we use proceed_question() for, it
> > doesn't actually override anything (up until now) that might lead to
> > data loss.  It's for things like trying to create an file system with
> > a block size greater than 4k on an x86 platform, creating a file
> > system larger than the apparent block size, etc.  The main goal was to
> > make sure the user actually *sees* the darned message.
> > 
> > Perhaps the only case where proceed_question() can prevent data loss
> > is the one where the user typo's /dev/sda3 as /dev/sda.  Everything
> > else is in the category of "we want to make sure the user sees the
> > warning".
> > 
> > The motivation behind this is adding this safety check:
> > 
> > % ./misc/mke2fs -t ext4 -L test-filesystem /dev/sdc3 8M
> > mke2fs 1.42.9 (4-Feb-2014)
> > /dev/sdc3 contains a ext4 file system labelled 'test-filesystem'
> > Proceed anyway (or wait 5 seconds) ? (y,n) 
> > 
> > Previously, we would blithely blow away /dev/sdc3 without even giving
> > a warning.  So if stdin (fd 0) is not a tty, we skip this test
> > entirely --- otherwise existing scripts would fail.  However, if a
> > script is attached to a tty, we would end up stalling the script
> > waiting for the user to answer yes/no where previously no question
> > would be asked at all.  This is the case where it's important that
> > proceed_question() will now pause five seconds, and then continue.
> 
> I guess it's up to you, but it gives me the heebie-jeebies.  xfs
> and btrfs already stop on an existing fs (or a partition table) unless
> the script adds the force option.  Stopping to make sure about an
> irreversible action - but proceeding after 5s anyway - seems to me
> like the worst of both worlds.  If it doesn't matter, don't ask.
> If it matters, wait for a response, however long it might take.
> 
> At least that's my take on it.  :)

I tend to agree. This solution sounds really scary and
unpredictable. It's true that we do not want to break scripts, so in
that case we could just test for tty and fallback to a old behaviour
if there is not tty attached. Otherwise ask.

Also overriding it with force is ok, but we might have another
argument just specifically for this case, let's say '-w |
--wipe-signatures' ?

-Lukas


> 
> -Eric
> 
> > 		   		   	    	       - Ted
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
