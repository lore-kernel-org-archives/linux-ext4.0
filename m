From: Beata Michalska <b.michalska@samsung.com>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Thu, 16 Apr 2015 10:41:58 +0200
Message-ID: <552F75D6.4030902@samsung.com>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <552F308F.1050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 hughd@google.com, lczerner@redhat.com, hch@infradead.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, kyungmin.park@samsung.com,
 kmpark@infradead.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-reply-to: <552F308F.1050505@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 04/16/2015 05:46 AM, Eric Sandeen wrote:
> On 4/15/15 2:15 AM, Beata Michalska wrote:
>> Introduce configurable generic interface for file
>> system-wide event notifications to provide file
>> systems with a common way of reporting any potential
>> issues as they emerge.
>>
>> The notifications are to be issued through generic
>> netlink interface, by a dedicated, for file system
>> events, multicast group. The file systems might as
>> well use this group to send their own custom messages.
> 
> ...
> 
>> + 4.3 Threshold notifications:
>> +
>> + #include <linux/fs_event.h>
>> + void fs_event_alloc_space(struct super_block *sb, u64 ncount);
>> + void fs_event_free_space(struct super_block *sb, u64 ncount);
>> +
>> + Each filesystme supporting the treshold notifiactions should call
>> + fs_event_alloc_space/fs_event_free_space repsectively whenever the
>> + ammount of availbale blocks changes.
>> + - sb:     the filesystem's super block
>> + - ncount: number of blocks being acquired/released
> 
> so:
> 
>> +void fs_event_alloc_space(struct super_block *sb, u64 ncount)
>> +{
>> +	struct fs_trace_entry *en;
>> +	s64 count;
>> +
>> +	spin_lock(&fs_trace_lock);
> 
> Every allocation/free for every supported filesystem system-wide will be
> serialized on this global spinlock?  That sounds like a non-starter...
> 
> -Eric
> 
I guess there is a plenty room for improvements as this is an early version.
I do agree that this might be a performance bottleneck event though I've tried
to keep this to minimum - it's being taken only for hashtable look-up. But still...
I was considering placing the trace object within the super_block to skip
this look-up part but I'd like to gather more comments, especially on the concept
itself.

BR
Beata


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
