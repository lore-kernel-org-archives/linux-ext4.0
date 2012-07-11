From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs alignment issues
Date: Wed, 11 Jul 2012 16:26:08 -0500
Message-ID: <4FFDEF70.3090202@redhat.com>
References: <4FFD7D9B.2080503@bobich.net> <4FFD9613.3050305@redhat.com> <20120711200557.GB5838@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Gordan Bobic <gordan@bobich.net>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2GKV05 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 17:26:57 -0400
In-Reply-To: <20120711200557.GB5838@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/11/12 3:05 PM, Theodore Ts'o wrote:
> On Wed, Jul 11, 2012 at 10:04:51AM -0500, Eric Sandeen wrote:

...

>>  I think Gordan suggested (if I understand it
>> right) that doing an array of ints might also solve the problem, since
>> ints should be on natural alignment.  Or maybe in some cases malloc/free
>> would be more obvious, if handling errors isn't too tricky.
> 
> In the specific case which Gordon has pointed out, the obvious thing
> to do is to just to set errno to ENOMEM, and return -1. since we
> already reflect an error code up to the caller if the FIEMAP ioctl()
> fails.
> 
> If someone sends me the patch, I will happily apply it.

Sure, I was planning on it :)

>> (IIRC "make gcc-wall" will also emit warnings for casts which change
>> natural alignment, among other things)
> 
> I'd have to check to be sure, but I don't think so, since it would
> have way too many false positives.  We *do* have code where we take
> char *'s and and then cast them to some other pointer type, and then
> dereference them.  And we do currently assume that it is safe to do
> this for on-disk data structures which are 4 byte aligned, in the
> directory entry code, for example.
> 
> I will *not* accept a patch which uses memcpy to copy each field in
> the on-disk superblock, or directory entry, into an int, just in case
> there is some insane architecture which requires that 4 byte integers
> be 32-byte aligned, or something else insane like that.

Well, let's just see where we're at, first, and see what it'll take,
case by case.

-Eric
