From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 11:00:20 -0500
Message-ID: <482C5E14.9030004@redhat.com>
References: <482868A5.1000102@redhat.com> <20080515144355.GB19325@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbYEOQAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 12:00:43 -0400
In-Reply-To: <20080515144355.GB19325@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>> As I look at my shiny new 500G disks with 32MB of cache, I find myself
>> wondering why the default for ext3 and ext4 is to have barriers disabled.
>>
>> This is a pretty dangerous default w.r.t. filesystem integrity on power
>> loss, no?
>   JFYI: SUSE kernel carries for ages a patch which changes this default.
> I'd be more than happy to drop it ;).
> 
> 								Honza

Did you ever send it upstream?  I'd ACK it :)

(I have a copy of it here... the fsync change seems sane too...)

@@ -85,7 +86,10 @@ int ext3_sync_file(struct file * file, s
                        .sync_mode = WB_SYNC_ALL,
                        .nr_to_write = 0, /* sys_fsync did this */
                };
+               journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
                ret = sync_inode(inode, &wbc);
+               if (journal && (journal->j_flags & JFS_BARRIER))
+                       blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
        }
 out:

I assume we need that for some power-plug-pull scenarios ... in fact I
had just been meaning to do something similar after reading an old
thread on barriers.  reiserfs & xfs do this already in their sync paths.

Thanks,

-Eric
