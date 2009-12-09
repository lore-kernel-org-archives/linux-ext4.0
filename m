From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/3] [RFC] vfs: add generic reserved space management
 interface
Date: Wed, 09 Dec 2009 17:24:59 +0300
Message-ID: <877hswql6s.fsf@openvz.org>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
 <20091209104542.GA10500@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20091209104542.GA10500@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Dec 09, 2009 at 05:11:24AM +0300, Dmitry Monakhov wrote:
>> Add new field "i_rsv_blocks" to generic inode. This value is
>> managed similar to i_blocks, i_bytes fileds (protected by i_lock).
>> This generic interface will be used by generic quota code similar
>> to i_blocks.
>
> Please don't bloat the VFS inode for this information.
But almost all recent file systems using extends and delayed allocation.
This means that we have to think about generic space reservation
management quota interface. Otherwise each fs will invent it's own 
callbacks. What do you think about hide it with CONFIG_QUOTA option?
May be introduce new CONFIG_QUOTA_RESERVATION?
