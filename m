From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 11/12] ext4: fix the number of credits needed for acl ops with inline data
Date: Mon, 11 Feb 2013 09:16:31 -0700
Message-ID: <0D6F0971-7298-4E8C-ACDA-6E3D5C4AFF31@dilger.ca>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu> <1360446832-12724-12-git-send-email-tytso@mit.edu> <5117A3E2.6090802@tao.ma> <CAGDaZ_q7H1AMS2a6mjsBTq6zJAW8aWd08TQRgCDFC29qRJJTdQ@mail.gmail.com> <20130210194310.GB10801@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Shentino <shentino@gmail.com>, Tao Ma <tm@tao.ma>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Tao Ma <boyu.mt@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:56837 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab3BKQQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2013 11:16:34 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so2726652dak.20
        for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 08:16:33 -0800 (PST)
In-Reply-To: <20130210194310.GB10801@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-10, at 12:43, Theodore Ts'o <tytso@mit.edu> wrote:

> On Sun, Feb 10, 2013 at 10:15:14AM -0800, Shentino wrote:
>> Quick question from a n00b.
>> 
>> What are "credits"?
>> 
>> I imagine I'm not the only onlooker curious about it either.

It would be great to add this description to the ext4 wiki, since it explains transaction handles quite clearly. 

Cheers, Andreas

> A group of operations which need to be applied to the file system as
> an atomic set of block updates are grouped by handles.  This is very
> to "BEGIN TRANSACTION" and "END TRANSACTION" pairs in SQL.  For example:
> 
> BEGIN TRANSACTION
> INSERT INTO INODE_TABLE (ino, i_blocks, i_size, i_uid) VALUES
>     (11, 2, 1024, 12);
> UPDATE INODE_ALLOCATION_BITMAP SET in_use=TRUE where ino=11;
> END TRANSACTION
> 
> The reason why we use the terminology "starting a handle" instead of
> "starting a transaction" is because a large number of handles are
> bundled together to form a jbd2 transaction.  This is because commits
> are expensive, and for performance reasons we batch a large number of
> handles, or perhaps what you might call "micro-transactions" into a
> one large jbd2 transaction, which in general gets commited once every
> five seconds or so, unless a commit is explicitly requested, or we
> start running out of space in the journal.
> 
> In order to make sure that we don't run out of space, before we start
> a handle, we have to declare how the maximum number of blocks we are
> planning on modifying --- this reservation of space in the journal is
> also referred as journal credits, since each time we call
> ext4_journal_get_write_access(), if that block is not already part of
> the transaction, the number of credits associated with the handle will
> be decremented by one.
> 
> When we open a handle, if there is not sufficient space (credits) left
> in the current transaction, then start_this_handle() will request that
> the current transaction be committed, and then block until the a new
> transaction can be started.
> 
> When we are done, we close the handle.  If it turns out that we didn't
> need to modify as many blocks as we had declared when we opened the
> handle, or if some of the blocks that we modified were already part of
> the transaction, those excess credits are returned to the transaction.
> 
> So as an example, suppose we need to modify two metadata blocks
> associated with an inode.  That sequence might look like this:
> 
>    /* start a handle with two credits */
>    /* note: this can trigger a journal commit if there 
>       is not enough space left in the journal */
>    handle = ext4_journal_start(inode, 2);
> 
>    ext4_journal_get_write_access(handle, bh);
>    <modify the metadata block found in bh>
>    ext4_handle_dirty_metadata(handle, inode, bh)
> 
>    ext4_journal_get_write_access(handle, bh2);
>    <modify the metadata block found in bh2>
>    ext4_handle_dirty_metadata(handle, inode, bh2)
> 
>    /* note: this can trigger a journal commit if the handle
>       is marked synchronous, or if enough time has elapsed --- i.e.,
>       the 5 second commit timer. */
>    ext4_journal_stop(handle);
> 
> In the case where we are running in no journal mode,
> ext4_journal_start(), ext4_journal_get_write_access(), and
> ext4_journal_stop() are effectively no-ops, and
> ext4_handle_dirty_metadata() is mapped to mark_buffer_dirty_inode(bh,
> inode), or mark_buffer_dirty(bh) if inode is NULL.  (inode is NULL if
> we are modifying metadata blocks belonging to a specific inode, such
> as a block group descriptor block or an inode table block.)
> 
> Hope this helps / is interesting to those who are following along at
> home.  :-)
> 
>                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
