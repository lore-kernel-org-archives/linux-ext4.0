From: Nagachandra P <nagachandra@gmail.com>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 20:50:50 +0530
Message-ID: <CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
	<20130626140205.GE3875@thunk.org>
	<20130626145417.GB32092@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:65234 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3FZPUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jun 2013 11:20:52 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so13624980lab.25
        for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 08:20:51 -0700 (PDT)
In-Reply-To: <20130626145417.GB32092@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Theodore,

We also have seen case where the current allocation itself could cause
the lowmem shrinker to be called (which in-turn chooses the same
process for killing because of oom_adj_value of the current process,
oom_adj_value is a weight age value associated with each process based
on which the android low memory killer would select a process for
killing to get memory). If we chose to retry in such case we could end
up in endless loop of retrying the allocation. It would be better to
handle this without retrying.

We could your above suggestion which could address this specific path.
But, there are quiet a number of allocation in ext4 which could call
ext4_std_error on failure and we may need to look each one of them to
see on how do we handle each one of them. Do think this something that
could be done?

We have in the past tried some ugly hacks to workaround the problem
(by adjusting oom_adj_values, guarding them from being killed) but
they don't seem provide fool proof mechanism at high memory pressure
environment. Any advice on what we could try to fix the issue in
general would be appreciated?

Thanks again.

Best regards
Nagachandra

On Wed, Jun 26, 2013 at 8:24 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Jun 26, 2013 at 10:02:05AM -0400, Theodore Ts'o wrote:
>>
>> In this particular case, we could reflect the error all the way up to
>> the ftruncate(2) system call.  Fixing this is going to be a bit
>> involved, unfortunately; we'll need to update a fairly large number of
>> function signatures, including ext4_truncate(), ext4_ext_truncate(),
>> ext4_free_blocks(), and a number of others.
>
> One thing that comes to mind.  If we change things so that ftruncate
> reflects an ENOMEM error all the way up to userspace, one side effect
> of this is that the file may be partially truncated when ENOMEM is
> returned.  Applications may not be prepared for this.
>
> There would be a similar issue if we do the truncate in the unlink
> call and return ENOMEM in case of a failure, the file might not be
> unlinked, and in fact we might have a partially truncated file in the
> directory, which would probably cause all sorts of confusion.  So
> we're probably better off, putting the inode on a list of inodes in
> memory, and on the orphan list on disk, and then retry the truncation
> when memory is available.  Messy, but that probably gives the best
> result for applications living constantly in high memory pressure
> environments.
>
>                                                         - Ted
