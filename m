From: Chris Hunter <chris.hunter@yale.edu>
Subject: Re: errors following ext3 to ext4 conversion
Date: Fri, 28 Aug 2015 12:23:54 -0400
Message-ID: <55E08B1A.6020503@yale.edu>
References: <55DE5F79.4010004@yale.edu> <20150827033949.GA12151@thunk.org>
 <55DE8771.9050109@redhat.com> <20150827041536.GH10037@birch.djwong.org>
 <20150827185845.GB3357@thunk.org> <55DF64CC.8060201@yale.edu>
 <20150827224652.GA5945@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vm-emlprdomg-03.its.yale.edu ([130.132.50.161]:39727 "EHLO
	vm-emlprdomg-03.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbbH1QX5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 12:23:57 -0400
In-Reply-To: <20150827224652.GA5945@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

You are correct there were human errors in these filesystem changes (eg. 
insufficient pre-checks/validation). I don't expect the software to 
compensate for poor planning.
For future reference, I desire a better understanding of risks involved 
in using tune2fs. I incorrectly assumed that tune2fs doesn't "do" 
anything until a filesystem is mounted.
Assuming you start with a clean filesystem, which tune2fs commands are 
the most dangerous ? which are the safest ?

thanks,
chris hunter
chris.hunter@yale.edu
"Experience is the teacher of all things." Julius Caesar


On 08/27/2015 06:46 PM, Theodore Ts'o wrote:
> On Thu, Aug 27, 2015 at 03:28:12PM -0400, Chris Hunter wrote:
>> Hi,
>> Thanks for the response. As Theodore pointed out, the filesystem already had
>> extents. I ran the tune2fs command on a filesystem that had previously been
>> converted from ext3 to ext4. I undid features (via tune2fs -O ^<flag>) but
>> the read-only fsck errors persist.
>
> Woah!  If the file system already had been converted from ext3 to
> ext4, why were you running the tune2fs command in the first place?  I
> had thought the tune2fs command was your _attempt_ to convert the
> filesystem from ext3 to ext4.  It was on that basis that I suggested
> that you use the "tune2fs -O ^<flag>" command to revert those changes.
>
>> Can you elaborate on the risky tune2fs options. I assume you mean changes
>> that can't be undone ? or  unsafe ?
>
> There are commands to change the inode size (for example) that need to
> allocate more blocks and then rewrite the inode table.  These commands
> are risky if your file system was corrupted before you attempt to run
> the tune2fs command.  For similar reasons, resize2fs forces you to do
> a a read/write check of the file system (so that the last fsck time
> can be updated, so resize2fs can *verify* that you ran the e2fsck
> command, intsead of lazily claiming you did when you didn't :-)
> *before* you run resize2fs.
>
> The main issue here is that you want to make sure the file system is
> in a stable state *before* you try to make involved changes.  At this
> point, I'm confused about what flags you had set on your file system
> before you ran your tune2fs command, so it's hard to know what to
> suggest.  But it's highly likely that no matter what was going on, the
> fact that your file system was corrupted has nothing to do with the
> tune2fs command.  The tune2fs -O command only flips a few bits in the
> superblock.  It's highly likely that your file system was corrupted
> *before* you ran the tune2fs command.
>
> It's for that reason that it's tempting to require an e2fsck before
> running a tune2fs -O command.  Unfortunately, in the past we've
> allowed this even for mounted file systems, and if you know what you
> are doing, and your file system is in a sane state, it's awfully
> convenient to turn on certain features even while the file system is
> mounted.
>
> The problem is that if you are an enterprise distribution who has to
> pay for staffing a help desk, or you're someone who's trying to help
> someone who is asking for advice on linux-ext4, it's awfully tempting
> to assume that we have to assume that users are idiots.  And sometimes
> it's not that they are, but because of ambiguities in bug reports.
> For example, what was the state of your file system before you ran the
> tune2fs command.  Was it a stock ext3 file system, or had you already
> converted it to ext4.  If so, how?  Was the file system mounted at any
> of these steps?  (Running e2fsck on a mounted file system is often
> going to lead to misleading file system problem reports.)
>
> So people who do this a lot often feel that tools have to be dumbed
> down, because otherwise it becomes a support nightmare....
>
> BTW, this is probably a good time to ask if your backups are up to
> date.  Because regardless of what happened, it's likely you will have
> suffered at least some data loss...
>
> 						- Ted
>
