From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: remove checker infrastructure
Date: Mon, 07 Jul 2014 10:01:57 -0500
Message-ID: <53BAB665.9050501@redhat.com>
References: <53505032.5060303@redhat.com> <20140704124824.GE10514@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaGGPCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 11:02:00 -0400
In-Reply-To: <20140704124824.GE10514@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/4/14, 7:48 AM, Theodore Ts'o wrote:
> On Thu, Apr 17, 2014 at 05:05:38PM -0500, Eric Sandeen wrote:
>> Per http://www.gnu.org/software/checker/ the gcc "-checker" option
>> is long deprecated.  Nuke it from e2fsprogs.
>>
>> Most people would never hit this, but people who love to turn
>> knobs, such as the reporter of kernel.org bz#74171, might
>> run into it and be sad.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, applied, with the necessary fixups so that e2fsprogs would
> actually compile afterwards.  :-)
> 
> (You didn't remove the @MAKEFILE_CHECKER@ from the Makefiles, and left
> a dependency on lib/Makefile.checker in MCONFIG.)

Gah, sorry. Thanks for fixing, not sure how I did that.

-Eric

> Cheers,
> 
> 					- Ted

