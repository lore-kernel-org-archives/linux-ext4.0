From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted filesystem
Date: Thu, 26 Sep 2013 19:39:30 -0500
Message-ID: <5244D3C2.4090606@redhat.com>
References: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com> <20130926235658.GD6011@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab3I0Ajd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Sep 2013 20:39:33 -0400
In-Reply-To: <20130926235658.GD6011@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/26/13 6:56 PM, Theodore Ts'o wrote:
> On Thu, Sep 26, 2013 at 06:00:04PM -0300, Carlos Maiolino wrote:
>> Several users use to run e2image over a mounted filesystem, providing
>> inconsistent, useless e2images.
>> This patch adds a warning in such cases, notifying the user and also adds a
>> force option making e2image able to run over Read-only filesystems.
> 
> It should be perfectly safe to run e2image on a read-only mounted file
> system option, so it's not obvious to me why the force option would be
> needed in that case.

right now Carlos' test isn't checking for readonly; just mounted, right?

But I think it should check for ro, and allow it by default in that case,
I agree.

> Also, if we are saving a "normal" (not a raw or qcow) e2image file, we
> are only backing up the statically located metadata blocks (i.e.,
> superblock, block group descriptors, inode table, and allocation
> bitmaps).  If we do this on a mounted file system, the e2image file is
> less useful, but I'm not sure I'd call it completely useless.  If the
> goal is to backup critical metadata, it will do that just fine.  So
> maybe it's worthy of a warning, but I'm not sure it should require a
> force option.

I asked Carlos to do this after getting the 2nd customer filesystem
image in a week which was useless for triage due to having been run
on a live, mounted fs...

I fear that a warning would be ignored, but *shrug* - at least something
so we have some hope of getting something useful out the other end
of e2image -r or -Q...

TBH I've never used a "normal" image; if you want to allow it to
run on an RW filesystem that won't bother me at all.  ;)

> If the user is trying to capture a raw or qcow image file, I agree
> that requiring that the file systme either be mounted read-only, not
> mounted at all, or that a force option be specified, makes sense.

cool.  :)

-Eric

> 	   	   	  	       	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

