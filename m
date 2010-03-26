From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: call blkdev_issue_flush on fsync
Date: Fri, 26 Mar 2010 14:37:42 -0500
Message-ID: <4BAD0D06.3000607@redhat.com>
References: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com> <37C3E508-AE2F-4FA5-9536-7F59B26CBBAC@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0CZThx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:53 -0400
In-Reply-To: <37C3E508-AE2F-4FA5-9536-7F59B26CBBAC@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/26/2010 02:24 PM, Andreas Dilger wrote:
> On 2010-03-26, at 10:50, Surbhi Palande wrote:
>> To ensure that bits are truly on-disk after an fsync,
>> we should call blkdev_issue_flush if barriers are supported.
>>
>> @@ -87,5 +89,7 @@ int ext3_sync_file(struct file * file, struct  
>> dentry *dentry, int datasync)
>> 		ret = sync_inode(inode, &wbc);
>> 	}
>> out:
>> +	if (journal && (journal->j_flags & JFS_BARRIER))
>> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>> 	return ret;
> 
> 
> I don't think we need yet ANOTHER barrier here.  If the filesystem is  
> mounted in data={journaled,ordered} mode it will have flushed the data  
> to disk as part of the journal commit.  If there is an external  
> journal, there were patches posted to have it flush the data on the  
> filesystem device at transaction commit time.
> 
> Since fsync on any inode always implies sync of the journal, the only  
> time that this would be needed is if we are running in no-journal  
> mode, or possibly in data=writeback mode.

And no-journal mode isn't possible in ext3 :)

Actually unless I'm totally confused, this patch doesn't apply at all,
and we already have:

        if (log_start_commit(journal, commit_tid)) {
                log_wait_commit(journal, commit_tid);
                goto out;
        }

        /*
         * In case we didn't commit a transaction, we have to flush
         * disk caches manually so that data really is on persistent
         * storage
         */
        if (test_opt(inode->i_sb, BARRIER))
                blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
out:
        return ret;

in ext3_sync_file(), from commit 56fcad29d4b3cbcbb2ed47a9d3ceca3f57175417...

-Eric
