From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 13:34:25 -0500
Message-ID: <482C8231.2090609@redhat.com>
References: <482868A5.1000102@redhat.com> <20080515144355.GB19325@atrey.karlin.mff.cuni.cz> <482C5E14.9030004@redhat.com> <20080515162135.GB3098@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbYEOSeb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 14:34:31 -0400
In-Reply-To: <20080515162135.GB3098@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On May 15, 2008  11:00 -0500, Eric Sandeen wrote:
>> ... the fsync change seems sane too...
>>
>> @@ -85,7 +86,10 @@ int ext3_sync_file(struct file * file, s
>>                         .sync_mode = WB_SYNC_ALL,
>>                         .nr_to_write = 0, /* sys_fsync did this */
>>                 };
>> +               journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
>>                 ret = sync_inode(inode, &wbc);
>> +               if (journal && (journal->j_flags & JFS_BARRIER))
>> +                       blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>>         }
>>  out:
>>
>> I assume we need that for some power-plug-pull scenarios ... in fact I
>> had just been meaning to do something similar after reading an old
>> thread on barriers.  reiserfs & xfs do this already in their sync paths.
> 
> Wouldn't it make more sense to add this into the generic do_fsync()
> routine?

blkdev_issue_flush() depends on barrier support:

        submit_bio(1 << BIO_RW_BARRIER, bio);

and I think only the filesystem can know for sure if it has barriers
currently in use and available?

-Eric
