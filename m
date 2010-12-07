From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] e2fsck: journal-replay-only
Date: Tue, 07 Dec 2010 16:38:39 +0100
Message-ID: <4CFE54FF.8000600@fastmail.fm>
References: <201011130009.08641.bs_lists@aakef.fastmail.fm> <20101206222714.GB24607@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43120 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775Ab0LGPil (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 10:38:41 -0500
In-Reply-To: <20101206222714.GB24607@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/06/2010 11:27 PM, Ted Ts'o wrote:
> On Sat, Nov 13, 2010 at 12:09:07AM +0100, Bernd Schubert wrote:
>> e2fsck: journal-replay-only
>>
>> As recently discussed on linux-ext4@vger.kernel.org add an option to e2fsck
>> to allow to replay the journal only. That will allow scripts, such as 
>> pacemakers 'Filesystem' RA to first replay the journal and if that sets
>> an error state from the journal replay, further check for that error 
>> (dumpe2fh -h | grep "Filesystem state:") and if that shows and error
>> to refuse to mount. It also allows automatic e2fsck scripts to first
>> replay the journal and on a second run after the real pass1 to passX checks
>> to test for the return code.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> 
> Hi Bernd,
> 
> My apologies for the delay.  I've made some slight cleanups to your
> patch, and committed it to the maint branch.  It will be in e2fsprogs
> 1.41.13.

Hello Ted,

thanks! And don't worry please, I'm rather busy either.

It is probably my very limited git knowledge, but I don't any recent
updated in e2fsprogs-git?

bernd@bathl e2fsprogs.git>git pull -v
>From git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs
 = [up to date]      e2fsprogs-interim -> origin/e2fsprogs-interim
 = [up to date]      maint      -> origin/maint
 = [up to date]      master     -> origin/master
 = [up to date]      next       -> origin/next
 = [up to date]      pu         -> origin/pu
 = [up to date]      tt/ras     -> origin/tt/ras
Already up-to-date.

bernd@bathl e2fsprogs.git>git branch
* maint
  master

(maint set up by "git branch --track maint origin/maint")

And the last commit is

commit 73fbe2323af6a2b4d807c80069657bf1449b3bff
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Sep 24 22:22:09 2010 -0400

    libext2fs: Change EXT2_FLAG_DIRECT_IO to avoid conflict with devel
branch

    The development branch of e2fsprogs already has a code point assigned
    in conflict with EXT2_FLAG_DIRECT_IO.  Fix this.

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


Thanks,
Bernd
