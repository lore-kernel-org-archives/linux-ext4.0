From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/3] [RFC] vfs: add generic reserved space management
 interface
Date: Wed, 09 Dec 2009 17:51:17 +0300
Message-ID: <873a3kqjyy.fsf@openvz.org>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
 <20091209110836.GE4863@quack.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20091209110836.GE4863@quack.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 09-12-09 05:11:24, Dmitry Monakhov wrote:
>> Add new field "i_rsv_blocks" to generic inode. This value is
>> managed similar to i_blocks, i_bytes fileds (protected by i_lock).
>> This generic interface will be used by generic quota code similar
>> to i_blocks.
>   I guess some people won't like bloating the VFS inode. It personally
> makes my "quota" life easier but not that many filesystems need this
> (currently I'm aware of only ext4) so their complaints are reasonable...
Please read my answer to Christoph.
>From other point of view, we may change inode structure like this:
struct quota_ptr
{
        struct dquot            *dquot[MAXQUOTAS];
};
struct quota_rsv_ptr
{
        struct dquot            *dquot[MAXQUOTAS];
        qsize_t                 reservation;
};
struct inode {
....
#ifdef CONFIG_QUOTA
       union {
             struct quota_ptr i_dquot;
             struct quota_rsv_ptr i_dquot_rsv;
       };
#endif
....
};
Most file systems will use i_dquot, and file systems with reservation
will use quota_rsv_ptr.
Imho this is even better than, macro approach. But this requires
huge patch for each fs, but who cares. 
>   If we would eventually decide to go this way, I'd account reserved
> space in bytes - quota is really accounted in bytes (as some filesystems
> need this).
Yes you right, I wasn't happy about this too,  Will redo.
>
> 								Honza
