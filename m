From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Thu, 11 Sep 2008 19:58:08 +0900
Message-ID: <85FB1C9FF587411A99FF66E76008D2A6@nsl.ad.nec.co.jp>
References: <20080818212819t-sato@mail.jp.nec.com>
	<48C012F3.3000408@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48C012F3.3000408@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

Eric Sandeen:
>> +static int ioctl_freeze(struct file *filp)
>> +{
>> +     struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +     if (!capable(CAP_SYS_ADMIN))
>> +         return -EPERM;
>> +
>> +     /* If filesystem doesn't support freeze feature, return. */
>> +     if (sb->s_op->write_super_lockfs == NULL)
>> +         return -EOPNOTSUPP;
>> +
>> +     /* If a regular file or a directory isn't specified, return. */
>> +     if (sb->s_bdev == NULL)
>> +         return -EINVAL;
>> +
>> +     /* Freeze */
>> +     sb = freeze_bdev(sb->s_bdev);
>> +     if (IS_ERR(sb))
>> +         return PTR_ERR(sb);
>> +     return 0;
>> +}
>
> Not a problem with your patch exactly, but I was just wondering; you
> check here whether the sb returned from freeze_bdev is an ERR_PTR (as
> does lock_fs()) - but, freeze_bdev never returns an error, does it?
> ->write_super_lockfs is a void...
>
> It really seems that at least we should be able to handle IO errors on
> the freeze request, and tell the user "No, your filesystem was not
> frozen..."?
>
> Maybe I'll whip up a patch to see about propagating freeze errors up
> from the filesystems that implement it, unless I'm missing some reason
> not to do so...?

Right.
We should handle an IO error which occurs in write_super_lockfs.
I will change the write_super_lockfs's type to "int" so that it can return an error.
And I will consider returning an error of ext3_write_super_lockfs because
journal_flush() in ext3_write_super_lockfs() doesn't handle an IO error.

> Also, should this be checking for a NULL returned from freeze_bdev as
> well?  I guess this should never happen if we have a file open on which
> we are calling the ioctl ...

I think ioctl_freeze doesn't need to check NULL because it never happen
as you said.

Cheers, Takashi
