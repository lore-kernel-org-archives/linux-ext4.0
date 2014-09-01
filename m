From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: tune2fs and setting noatime as a default mount options
Date: Mon, 1 Sep 2014 14:23:46 -0700
Message-ID: <CALCETrWwozeOGxbv1r1y=NUSxem_uTmfP=FbkcKy8YPzT=mLOA@mail.gmail.com>
References: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
 <54009D31.70703@redhat.com> <20140829225649.GC27177@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:52993 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaIAVYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Sep 2014 17:24:08 -0400
Received: by mail-la0-f52.google.com with SMTP id ty20so6763846lab.11
        for <linux-ext4@vger.kernel.org>; Mon, 01 Sep 2014 14:24:06 -0700 (PDT)
In-Reply-To: <20140829225649.GC27177@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 29, 2014 at 3:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 29, 2014 at 10:33:05AM -0500, Eric Sandeen wrote:
>>
>> > Is there a reason why noatime can't be set as a default mount option? Thinking of all these USB connected devices where it would be handy.
>>
>> I haven't looked, but I'm guessing it's because noatime is a
>> vfs-level switch, and by the time the ext4 superblock is getting
>> read and processed during mount, that chance has passed.
>
> Yes, and this is also the cause of this user complaint/bug:
>
>         https://bugzilla.kernel.org/show_bug.cgi?id=61601
>
> There was some discussion at the kernel summit by Andy Lutomirski to
> create new mount system call with sane parsing, and Al Viro wasn't
> totally against that idea.  If we do go forward with some of the ideas
> that was tossed about, this would be something else that would be a
> nice thing to fix at the same time.
>
> The whole distinction between VFS-level mount options (which are
> parsed in userspace and passed down into the kernel using bits in a
> bitfield) and file system-level mount options (which is parsed by the
> kernel and passed in from userspace as a string) is just nasty.
>
> What I would suggest is that all mount options would be passed all the
> way down to the file system, and then there would be a library
> function to handle common VFS-level mount options that would be called
> by the file system's mount option handling code.
>

To clarify: do you mean that per-superblock options would all be
strings and would all get passed down to the fs?  If so, I like it.  I
think that whatever corresponds to MNT_READONLY shouldn't be passed
down to the filesystem or necessarily specified when loading the
filesystem at all.  But MNT_READONLY is a very different thing than
"ro".

--Andy
