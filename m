From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Mon, 23 Jul 2012 11:28:59 -0500
Message-ID: <500D7BCB.2060806@redhat.com>
References: <5009E62E.3020608@redhat.com> <20120721003953.GA9399@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab2GWQ3D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 12:29:03 -0400
In-Reply-To: <20120721003953.GA9399@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/20/12 7:39 PM, Theodore Ts'o wrote:
> On Fri, Jul 20, 2012 at 06:13:50PM -0500, Eric Sandeen wrote:
>> I'm looking at a situation where a root filesystem encountered an error and shut down, and therefore the error was stored in the journal.
>>
>> But for the root fs, it seems that nothing can clear it.
>>
>> If we do e2fsck -fy on a readonly mounted filesystem, then remount,rw the error persists:
>>
>> [25124.319387] EXT4-fs warning (device loop3): ext4_clear_journal_err:4281: Filesystem error recorded from previous mount: IO failure
>> [25124.331140] EXT4-fs warning (device loop3): ext4_clear_journal_err:4282: Marking fs in need of filesystem check.
>>
>> ad infinitum.
>>
>> It may be my fever-addled brain this week but I'm having a hard time following how this error is supposed to get set & cleared, especially if e2fsck has modified it while mounted ro.
>>
>> As soon as I mount rw again, load_superblock() sees the journal superblock has an error set, and copies it back into the journal->j_errno.
>>
>> After Ted's "e2fsck: correctly propagate error from journal to superblock" in e2fsprogs, at least an unmounted fs gets cleaned up, but I'm not sure what to do to fix this when it's mounted.  
> 
> The problem you describe should have been fixed by commit 6d75685e:
> e2fsck: handle an already recovered journal with a non-zero s_error
> field, which is in e2fsprogs 1.42.4.

Well, I tested e2fsprogs from git and saw the same trouble.  Let me look more closely at that commit.

-Eric

> 					- Ted
> 


