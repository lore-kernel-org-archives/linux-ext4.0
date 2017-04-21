From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: xattr-in-inode support
Date: Fri, 21 Apr 2017 10:54:23 +0300
Message-ID: <CAOQ4uxj=QJogKzpHRPwjPF+a9OuTLqEJoVx-VZWJY7a1dkcu=Q@mail.gmail.com>
References: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
 <20170414132720.je5ca2c5fibjn6qq@thunk.org> <20170420075823.GA18523@quack2.suse.cz>
 <61D86619-018B-4ED3-B0FB-C391F6442315@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        James Simmons <jsimmons@infradead.org>, tahsin@google.com,
        nauman@google.com, Theodore Tso <tytso@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35478 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036135AbdDUHyY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Apr 2017 03:54:24 -0400
Received: by mail-oi0-f66.google.com with SMTP id m34so8798745oik.2
        for <linux-ext4@vger.kernel.org>; Fri, 21 Apr 2017 00:54:24 -0700 (PDT)
In-Reply-To: <61D86619-018B-4ED3-B0FB-C391F6442315@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 21, 2017 at 12:22 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Apr 20, 2017, at 1:58 AM, Jan Kara <jack@suse.cz> wrote:
>>
[...]
>> One idea I had in mind was that one way of supporting larger xattrs would
>> be to support something like xattr fork - i.e., in the xattr space of the
>> inode we would have root of an extent tree describing xattr space of the
>> inode. Then inside the space described by the extent tree would be stored
>> xattrs - possibly in the same format as they are currently stored in a
>> block (we would just redefine that e_value_block+e_value_offs describe the
>> offset of xattr value inside the xattr space).

BTW, 'xattr fork' is the xfs way AFAIK and btrfs has 'xattr inodes'.

>
> Yes, this is what I was trying to get at with my previous email as well.
> There isn't much difference between allocating a bunch of blocks directly
> as the xattr space vs. an inode that is allocating those blocks.  The main
> difference from the current xattr inode implementation is that this packs
> multiple xattrs into a single inode, while the current code only stores a
> single value starting at offset=0, without any header.
>

That's not the only difference, is it?
Current ea-in-inode code can allocate many xattr inodes per regular inode.
'xattr fork' is equivalent to allocating a single 'xattr inode' per
regular inode.

I wonder if one-xattr-inode and one-EA-per-block can work out:
- EA block cannot have more than 1 EA
- EA can span more than 1 EA block (i.e. compound EA block)
- Refcounting is in the EA block as it is now, but may refcount a compund block
- inode A may have a reference to xattr-inode Ax, which is the host for writing
  new unshared EAs for inode A
- EA of inode B may have a shared EA with e_value_block pointing at block
  of xattr-inode Ax
- When refcount of any EA (compound) block drops to zero, punch holes in
  the xattr-inode hosting these blocks
- When inode A is deleted, it drops refcount on all the EA blocks its EAs
  are referencing
- If xattr-inode Ax has remaining EA block when inode A is going away,
  it transitions into a 'shared xattr-inode' and lives on the orphan list, or
  another dedicated list, until its own blocks count drops to zero.

I probably missed some details, maybe important ones as well,
but if I haven't, then this could reuse some of the existing EA dedup
code and cap the inodes overhead significantly (*).

(*) shared xattr-inodes may be compacted by handing their blocks over to
     a dedicated SHARED_XATTR_INO or to any random xattr-inode victim
     for that matter (i.e. of root inode).

Amir.
