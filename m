From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] Consolidated file encryption interface/semantics?
Date: Mon, 11 Jan 2016 23:47:56 -0800
Message-ID: <20160112074756.GB35051@jaegeuk.granlibakkenguest>
References: <56943319.9080802@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
To: Richard Weinberger <richard@nod.at>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56943319.9080802@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

Actually, I tried to prepare this quite long time ago [1], which was stuck
that moment unfortunately, since I needed to wait for how AOSP finally treats
with this feature. At some moment later, I couldn't even follow up every ext4
changes into this patch set, since the feature was not quickly settled down in
AOSP rather than what I expected.

But, now it seems that there's no strong reason to postpone this work any more.
If Ted doen't mind, I'd like to investigate all the diffs between ext4 and f2fs
first. And, in the mean time, let me get any comments about missing or ugly
design points in this patch set.
(Please, take a look at its basic approach only.)

[1] http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs.git/log/?h=crypto

This patch set adds the following files.
 - include/linux/fscrypt.h
 - fs/crypto/crypto.c
 - fs/crypto/policy.c
 - fs/crypto/keyinfo.c
 - fs/crypto/fname.c

And, it adds the below function pointers for each filesystems.

struct fscrypt_operations {
	int (*get_context)(struct inode *, void *, size_t, void *);
	int (*set_context)(struct inode *, const void *, size_t, int, void *);
	bool (*is_encrypted)(struct inode *);
	bool (*empty_dir)(struct inode *);
	unsigned (*max_namelen)(struct inode *);
};

Thanks,

On Mon, Jan 11, 2016 at 11:56:25PM +0100, Richard Weinberger wrote:
> Hi!
> 
> I consider adding file encryption to UBIFS.
> While looking into ext4 and f2fs I realized that both
> use the same data structures/concepts.
> 
> f2fs copy&pasted a lot from ext4.
> Before I do the next copy&paste, I'd to ask whether it would make sense
> to more parts of the ioctl() interface out to VFS?
> 
> Let's checkout the user visible interface:
> 
> ext4 offers:
> EXT4_IOC_SET_ENCRYPTION_POLICY
> EXT4_IOC_GET_ENCRYPTION_PWSALT
> EXT4_IOC_GET_ENCRYPTION_POLICY
> 
> with:
> #define EXT4_KEY_DESCRIPTOR_SIZE 8
> 
> /* Policy provided via an ioctl on the topmost directory */
> struct ext4_encryption_policy {
>         char version;
>         char contents_encryption_mode;
>         char filenames_encryption_mode;
>         char flags;
>         char master_key_descriptor[EXT4_KEY_DESCRIPTOR_SIZE];
> } __attribute__((__packed__));
> 
> 
> f2fs:
> F2FS_IOC_SET_ENCRYPTION_POLICY
> F2FS_IOC_GET_ENCRYPTION_POLICY
> F2FS_IOC_GET_ENCRYPTION_PWSALT
> 
> #define F2FS_KEY_DESCRIPTOR_SIZE        8
> 
> /* Policy provided via an ioctl on the topmost directory */
> struct f2fs_encryption_policy {
>         char version;
>         char contents_encryption_mode;
>         char filenames_encryption_mode;
>         char flags;
>         char master_key_descriptor[F2FS_KEY_DESCRIPTOR_SIZE];
> } __attribute__((__packed__));
> 
> So, the data structures are identical and AFAIK also the supported cipher modes are.
> But as both use their own ioctls having a single tool to control file encryption
> can be error prone in future.
> Interestingly the current ioctls for ext4 and f2fs resolve to the same integers,
> is this on purpose? :)
> 
> Wouldn't it be worthwhile having exactly the same ioctls such that util-linux could offer
> a decent file encryption tool which can be used by all file systems with file encryption
> support?
> 
> Another thing are semantics, ext4 implemented a policy which controls
> under which conditions encrypted files are allowed to be unlinked, moved, etc...
> f2fs adopted these from ext4. But can't we do that in VFS or at least
> agree one a policy and document it? :-)
> 
> Thanks,
> //richard
> 
> ------------------------------------------------------------------------------
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
