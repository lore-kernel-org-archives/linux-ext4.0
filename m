From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Mon, 7 Aug 2017 17:24:08 -0700
Message-ID: <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
References: <20170727131245.28279-1-jack@suse.cz> <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com> <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org> <20170801112603.GG4215@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35006 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbdHHAYJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Aug 2017 20:24:09 -0400
Received: by mail-vk0-f45.google.com with SMTP id d124so7599550vkf.2
        for <linux-ext4@vger.kernel.org>; Mon, 07 Aug 2017 17:24:09 -0700 (PDT)
In-Reply-To: <20170801112603.GG4215@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 1, 2017 at 4:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 01-08-17 04:02:41, Christoph Hellwig wrote:
>> On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
>> > Well, you are right I can make the implementation work with struct file
>> > flag as well - let's call it O_DAXDSYNC. However there are filesystem
>> > operations where you may need to answer question: Is there any fd with
>> > O_DAXDSYNC open against this inode (for operations that change file offset
>> > -> block mapping)? And in that case inode flag is straightforward while
>> > file flag is a bit awkward (you need to implement counter of fd's with that
>> > flag in the inode).
>>
>> We can still keep and inode flag as the internal implementation
>> detail.  As mentioned earlier the right flag to control behavior
>> of a mapping is an mmap flag.  And the initial naive implementation
>> would simply mark the inode as sync once the first MAP_SYNC open happens
>> on it.  We could then move to more precise tracking if/when needed.
>
> OK, makes sense and I like the MAP_SYNC proposal. I'll change it in my
> implementation.

Does sys_mmap() reject unknown flag values today? I'm either not
looking in the right place or it's missing and we'll need some
interface/mechanism to check if MAP_SYNC is honored.
