From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] ext4: recalculate s_blockfile_groups during resize2fs
Date: Sun, 5 May 2013 23:31:21 -0400 (EDT)
Message-ID: <9D9D3649-7D5C-4755-B850-D87B5F5D3453@redhat.com>
References: <518426F0.1000103@redhat.com> <20130506030637.GA4974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Lachlan McIlroy <lmcilroy@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:40241 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3EFDbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 23:31:23 -0400
In-Reply-To: <20130506030637.GA4974@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 5, 2013, at 10:06 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Fri, May 03, 2013 at 04:06:56PM -0500, Eric Sandeen wrote:
>> s_blockfile_groups is used to limit allocations for non-extent
>> files to block groups with block numbers less than 2^32.
>> However, it's not updated when the filesystem is resized online,
>> so the new groups are unavailable to non-extent files until a remount.
>> 
>> Fix this by updating the value in ext4_update_super() at
>> resize time.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I sent out a patch about two weeks ago, which has since been accepted
> into Linus's tree as commit c5c72d814cf0.  It's been marked for the
> for backporting into the stable trees.
> 
Argh, so you did!  One demerit for me for forgetting, and another for patching an old tree....

Thanks,
Eric

> Cheers,
> 
>                        - Ted
> 
> commit c5c72d814cf0f650010337c73638b25e6d14d2d4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Apr 21 20:19:43 2013 -0400
> 
>    ext4: fix online resizing for ext3-compat file systems
> 
>    Commit fb0a387dcdc restricts block allocations for indirect-mapped
>    files to block groups less than s_blockfile_groups.  However, the
>    online resizing code wasn't setting s_blockfile_groups, so the newly
>    added block groups were not available for non-extent mapped files.
> 
>    Reported-by: Eric Sandeen <sandeen@redhat.com>
>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>    Cc: stable@vger.kernel.org
