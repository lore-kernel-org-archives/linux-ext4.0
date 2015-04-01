From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: completely ignore last-mount and last-write within fudge_time
Date: Wed, 1 Apr 2015 14:08:22 -0400 (EDT)
Message-ID: <40AB2046-FEAB-4F77-9FB8-D6A4C2EDFD74@redhat.com>
References: <5509DCE4.1010706@redhat.com> <20150329023226.GA19097@thunk.org> <20150401130642.GL26339@quack.suse.cz> <20150401150837.GA7105@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44464 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbDASI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 14:08:28 -0400
In-Reply-To: <20150401150837.GA7105@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Apr 1, 2015, at 11:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Wed, Apr 01, 2015 at 03:06:42PM +0200, Jan Kara wrote:
>>>    e2fsck: use PROMPT_NONE for FUTURE_SB_LAST_*_FUDGED problems
>>> 
>>>    This allows us to print a message warning the user that there is
>>>    something funny going on with their hardware clock (probably time zone
>>>    issues caused by trying to be compatible with legacy OS's such as
>>>    Windows), without triggering a full file system check.
>>> 
>>>    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>>  OK, so this will just print the error but won't fix it unless in preen
>> or full check mode. Am I right. That sounds fine to me.
> 
> Actually, it will fix it unless the run in -n mode, but it won't count
> it as a "fix".  Hence, it won't trigger the full file system check.
> 
>                                       - Ted

Avoiding the full check is my only real concern so that's fine.  Docs might need updates.

-Eric