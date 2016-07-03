From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] ext4: don't call ext4_should_journal_data() on the
 journal inode
Date: Sun, 3 Jul 2016 09:05:05 +0200
Message-ID: <5778B921.9060603@oracle.com>
References: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
 <20160703051505.GA17739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43258 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcGCHFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jul 2016 03:05:15 -0400
In-Reply-To: <20160703051505.GA17739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/03/2016 07:15 AM, Theodore Ts'o wrote:
> On Sat, Jul 02, 2016 at 11:42:42PM +0200, Vegard Nossum wrote:
>> Certain combinations of mount options in the superblock will cause
>> set_journal_csum_feature_set() in ext4_fill_super() to fail after the
>> journal has been created. When iput() is called on the journal inode,
>> we will hit the BUG() in ext4_should_journal_data(). We can prevent
>> this by only calling ext4_should_journal_data() if we already know
>> that it's not the journal inode.
>
> Which mount options?  Can you please give a reproducer?

Unfortunately I can't share the reproducer, but...
s->mount_opt = 0xa882c020, which seems like it is:

EXT4_MOUNT_ERRORS_RO
EXT4_MOUNT_XATTR_USER
EXT4_MOUNT_POSIX_ACL
EXT4_MOUNT_BARRIER
EXT4_MOUNT_JOURNAL_CHECKSUM
EXT4_MOUNT_DELALLOC
EXT4_MOUNT_BLOCK_VALIDITY
EXT4_MOUNT_INIT_INODE_TABLE

At mount time, this ends up calling

jbd2_journal_clear_features(JBD2_FEATURE_COMPAT_CHECKSUM, 0, 
JBD2_FEATURE_INCOMPAT_CSUM_V3 | JBD2_FEATURE_INCOMPAT_CSUM_V2)
jbd2_journal_set_features(0, 0, JBD2_FEATURE_INCOMPAT_CSUM_V3) = 0 // fails
jbd2_journal_clear_features(0x0, 0x0, JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)

The reason the set_features() call ends up calling is because
journal->j_format_version == 1.

Maybe the "mount options" thing was a bit misleading and we should
rather say "Certain combinations of mount options
(EXT4_MOUNT_JOURNAL_CHECKSUM), journal format (v1), and superblock
features (EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) [...]" in the changelog.

Does that make more sense?

Hope this helps,


Vegard
