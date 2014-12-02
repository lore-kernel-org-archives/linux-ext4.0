From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Date: Tue, 02 Dec 2014 19:55:48 +0200
Message-ID: <547DFD24.9070805@plexistor.com>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu> <1417154411-5367-2-git-send-email-tytso@mit.edu> <20141128172323.GD738@quack.suse.cz> <20141128181421.GA19461@google.com> <20141202125820.GE9092@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141202125820.GE9092@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12/02/2014 02:58 PM, Jan Kara wrote:
> On Fri 28-11-14 13:14:21, Ted Tso wrote:
>> On Fri, Nov 28, 2014 at 06:23:23PM +0100, Jan Kara wrote:
>>> Hum, when someone calls fsync() for an inode, you likely want to sync
>>> timestamps to disk even if everything else is clean. I think that doing
>>> what you did in last version:
>>> 	dirty = inode->i_state & I_DIRTY_INODE;
>>> 	inode->i_state &= ~I_DIRTY_INODE;
>>> 	spin_unlock(&inode->i_lock);
>>> 	if (dirty & I_DIRTY_TIME)
>>> 		mark_inode_dirty_sync(inode);
>>> looks better to me. IMO when someone calls __writeback_single_inode() we
>>> should write whatever we have...
>>
>> Yes, but we also have to distinguish between what happens on an
>> fsync() versus what happens on a periodic writeback if I_DIRTY_PAGES
>> (but not I_DIRTY_SYNC or I_DIRTY_DATASYNC) is set.  So there is a
>> check in the fsync() code path to handle the concern you raised above.
>   Ah, this is the thing you have been likely talking about but which I was
> constantly missing in my thoughts. You don't want to write times when inode
> has only dirty pages and timestamps - 

This I do not understand. I thought that I_DIRTY_TIME, and the all
lazytime mount option, is only for atime. So if there are dirty
pages then there are also m/ctime that changed and surly we want to
write these times to disk ASAP.

if we are lazytime also with m/ctime then I think I would like an
option for only atime lazy. because m/ctime is cardinal to some
operations even though I might want atime lazy.

Sorry for the slowness, I'm probably missing something
Thanks
Boaz

